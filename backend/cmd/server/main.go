package main

import (
	"context"
	"crypto/tls"
	"fmt"
	"log"
	"net"
	"os"
	"strings"

	"oshizatsu-backend/internal/auth"
	"oshizatsu-backend/internal/models"
	"oshizatsu-backend/internal/notification"
	"oshizatsu-backend/internal/youtube"
	"oshizatsu-backend/proto"

	"github.com/joho/godotenv"
	"github.com/robfig/cron/v3"
	"google.golang.org/grpc"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/credentials"
	"google.golang.org/grpc/status"
	"google.golang.org/protobuf/types/known/timestamppb"
)

// Server gRPCサーバー
type Server struct {
	proto.UnimplementedAuthServiceServer
	proto.UnimplementedChannelServiceServer
	proto.UnimplementedNotificationServiceServer

	authService         *auth.AuthService
	youtubeService      *youtube.YouTubeService
	notificationService *notification.NotificationService
	db                  *models.Database
}

// NewServer 新しいサーバーを作成
func NewServer(db *models.Database) (*Server, error) {
	authService, err := auth.NewAuthService(db)
	if err != nil {
		return nil, fmt.Errorf("failed to create auth service: %v", err)
	}

	youtubeService, err := youtube.NewYouTubeService(db)
	if err != nil {
		return nil, fmt.Errorf("failed to create YouTube service: %v", err)
	}

	notificationService, err := notification.NewNotificationService(db)
	if err != nil {
		return nil, fmt.Errorf("failed to create notification service: %v", err)
	}

	return &Server{
		authService:         authService,
		youtubeService:      youtubeService,
		notificationService: notificationService,
		db:                  db,
	}, nil
}

// Login ログイン処理
func (s *Server) Login(ctx context.Context, req *proto.LoginRequest) (*proto.LoginResponse, error) {
	// OIDC対応: emailフィールドがJWT形式(3パート)ならIDトークンとして扱う
	if looksLikeJWT(req.Email) && req.Password == "" {
		idToken := req.Email
		user, err := s.authService.ValidateToken(ctx, idToken)
		if err != nil {
			return nil, status.Errorf(codes.Unauthenticated, "invalid oidc token: %v", err)
		}
		return &proto.LoginResponse{
			AccessToken:  idToken,
			RefreshToken: "",
			UserInfo: &proto.UserInfo{
				Id:      user.ID,
				Email:   user.Email,
				Name:    user.Name,
				Picture: user.Picture,
			},
		}, nil
	}

	// 従来の簡易ログイン: メールでユーザー作成 + ランダムトークン生成
	user, err := s.authService.CreateUser(req.Email, "User", "")
	if err != nil {
		return nil, status.Errorf(codes.Internal, "failed to create user: %v", err)
	}

	token, err := s.authService.GenerateToken(user.ID)
	if err != nil {
		return nil, status.Errorf(codes.Internal, "failed to generate token: %v", err)
	}

	return &proto.LoginResponse{
		AccessToken:  token,
		RefreshToken: token, // 簡略化のため同じトークンを使用
		UserInfo: &proto.UserInfo{
			Id:      user.ID,
			Email:   user.Email,
			Name:    user.Name,
			Picture: user.Picture,
		},
	}, nil
}

func looksLikeJWT(s string) bool {
	if s == "" {
		return false
	}
	return strings.Count(s, ".") == 2
}

// Logout ログアウト処理
func (s *Server) Logout(ctx context.Context, req *proto.LogoutRequest) (*proto.LogoutResponse, error) {
	// 簡略化のため、常に成功を返す
	return &proto.LogoutResponse{
		Success: true,
	}, nil
}

// GetUserInfo ユーザー情報取得
func (s *Server) GetUserInfo(ctx context.Context, req *proto.GetUserInfoRequest) (*proto.GetUserInfoResponse, error) {
	user, err := s.authService.ValidateToken(ctx, req.AccessToken)
	if err != nil {
		return nil, status.Errorf(codes.Unauthenticated, "invalid token: %v", err)
	}

	return &proto.GetUserInfoResponse{
		UserInfo: &proto.UserInfo{
			Id:      user.ID,
			Email:   user.Email,
			Name:    user.Name,
			Picture: user.Picture,
		},
	}, nil
}

// UpdateUserInfo ユーザー情報更新
func (s *Server) UpdateUserInfo(ctx context.Context, req *proto.UpdateUserInfoRequest) (*proto.UpdateUserInfoResponse, error) {
	user, err := s.authService.ValidateToken(ctx, req.AccessToken)
	if err != nil {
		return nil, status.Errorf(codes.Unauthenticated, "invalid token: %v", err)
	}

	// ユーザー情報を更新
	if req.Name != "" {
		user.Name = req.Name
	}
	if req.Picture != "" {
		user.Picture = req.Picture
	}

	// データベースを更新
	if err := s.authService.UpdateUser(user); err != nil {
		return nil, status.Errorf(codes.Internal, "failed to update user: %v", err)
	}

	return &proto.UpdateUserInfoResponse{
		Success: true,
		Message: "User information updated successfully",
		UserInfo: &proto.UserInfo{
			Id:      user.ID,
			Email:   user.Email,
			Name:    user.Name,
			Picture: user.Picture,
		},
	}, nil
}

// SubscribeChannel チャンネル登録
func (s *Server) SubscribeChannel(ctx context.Context, req *proto.SubscribeChannelRequest) (*proto.SubscribeChannelResponse, error) {
	user, err := s.authService.ValidateToken(ctx, req.AccessToken)
	if err != nil {
		return nil, status.Errorf(codes.Unauthenticated, "invalid token: %v", err)
	}

	// チャンネルを作成または取得
	channel := models.NewChannel(req.ChannelId, req.ChannelName)
	if err := s.createChannel(channel); err != nil {
		return nil, status.Errorf(codes.Internal, "failed to create channel: %v", err)
	}

	// 既存のチャンネルを取得（作成されたチャンネルまたは既存のチャンネル）
	existingChannel, err := s.getChannelByChannelID(req.ChannelId)
	if err != nil {
		return nil, status.Errorf(codes.Internal, "failed to get channel: %v", err)
	}

	// ユーザーが既にこのチャンネルに登録しているかチェック
	userChannels, err := s.getUserChannels(user.ID)
	if err != nil {
		return nil, status.Errorf(codes.Internal, "failed to get user channels: %v", err)
	}

	for _, userChannel := range userChannels {
		if userChannel.ChannelID == req.ChannelId {
			return &proto.SubscribeChannelResponse{
				Success: false,
				Message: "既にこのチャンネルに登録されています",
			}, nil
		}
	}

	// ユーザーチャンネル関連を作成
	userChannel := models.NewUserChannel(user.ID, existingChannel.ID)
	if err := s.createUserChannel(userChannel); err != nil {
		return nil, status.Errorf(codes.Internal, "failed to subscribe to channel: %v", err)
	}

	return &proto.SubscribeChannelResponse{
		Success: true,
		Message: "Successfully subscribed to channel",
	}, nil
}

// UnsubscribeChannel チャンネル登録解除
func (s *Server) UnsubscribeChannel(ctx context.Context, req *proto.UnsubscribeChannelRequest) (*proto.UnsubscribeChannelResponse, error) {
	user, err := s.authService.ValidateToken(ctx, req.AccessToken)
	if err != nil {
		return nil, status.Errorf(codes.Unauthenticated, "invalid token: %v", err)
	}

	// チャンネルを取得
	channel, err := s.getChannelByChannelID(req.ChannelId)
	if err != nil {
		return nil, status.Errorf(codes.NotFound, "channel not found: %v", err)
	}

	// ユーザーチャンネル関連を削除
	if err := s.deleteUserChannel(user.ID, channel.ID); err != nil {
		return nil, status.Errorf(codes.Internal, "failed to unsubscribe from channel: %v", err)
	}

	return &proto.UnsubscribeChannelResponse{
		Success: true,
		Message: "Successfully unsubscribed from channel",
	}, nil
}

// GetSubscribedChannels 登録チャンネル一覧取得
func (s *Server) GetSubscribedChannels(ctx context.Context, req *proto.GetSubscribedChannelsRequest) (*proto.GetSubscribedChannelsResponse, error) {
	user, err := s.authService.ValidateToken(ctx, req.AccessToken)
	if err != nil {
		return nil, status.Errorf(codes.Unauthenticated, "invalid token: %v", err)
	}

	channels, err := s.getUserChannels(user.ID)
	if err != nil {
		return nil, status.Errorf(codes.Internal, "failed to get subscribed channels: %v", err)
	}

	var protoChannels []*proto.Channel
	for _, channel := range channels {
		var lastLiveScheduled *timestamppb.Timestamp
		if channel.LastLiveScheduledTime != nil {
			lastLiveScheduled = timestamppb.New(*channel.LastLiveScheduledTime)
		}

		protoChannels = append(protoChannels, &proto.Channel{
			Id:                channel.ID,
			Name:              channel.Name,
			ChannelId:         channel.ChannelID,
			LastLiveScheduled: lastLiveScheduled,
			IsLive:            channel.IsLive,
		})
	}

	return &proto.GetSubscribedChannelsResponse{
		Channels: protoChannels,
	}, nil
}

// RegisterFCMToken FCMトークン登録
func (s *Server) RegisterFCMToken(ctx context.Context, req *proto.RegisterFCMTokenRequest) (*proto.RegisterFCMTokenResponse, error) {
	user, err := s.authService.ValidateToken(ctx, req.AccessToken)
	if err != nil {
		return nil, status.Errorf(codes.Unauthenticated, "invalid token: %v", err)
	}

	if err := s.notificationService.RegisterFCMToken(user.ID, req.FcmToken); err != nil {
		return nil, status.Errorf(codes.Internal, "failed to register FCM token: %v", err)
	}

	return &proto.RegisterFCMTokenResponse{
		Success: true,
		Message: "Successfully registered FCM token",
	}, nil
}

// UnregisterFCMToken FCMトークン削除
func (s *Server) UnregisterFCMToken(ctx context.Context, req *proto.UnregisterFCMTokenRequest) (*proto.UnregisterFCMTokenResponse, error) {
	user, err := s.authService.ValidateToken(ctx, req.AccessToken)
	if err != nil {
		return nil, status.Errorf(codes.Unauthenticated, "invalid token: %v", err)
	}

	if err := s.notificationService.UnregisterFCMToken(user.ID, req.FcmToken); err != nil {
		return nil, status.Errorf(codes.Internal, "failed to unregister FCM token: %v", err)
	}

	return &proto.UnregisterFCMTokenResponse{
		Success: true,
		Message: "Successfully unregistered FCM token",
	}, nil
}

// GetNotifications 通知一覧取得
func (s *Server) GetNotifications(ctx context.Context, req *proto.GetNotificationsRequest) (*proto.GetNotificationsResponse, error) {
	user, err := s.authService.ValidateToken(ctx, req.AccessToken)
	if err != nil {
		return nil, status.Errorf(codes.Unauthenticated, "invalid token: %v", err)
	}

	notifications, err := s.getUserNotifications(user.ID, req.Limit, req.Offset)
	if err != nil {
		return nil, status.Errorf(codes.Internal, "failed to get notifications: %v", err)
	}

	var protoNotifications []*proto.Notification
	for _, notification := range notifications {
		protoNotifications = append(protoNotifications, &proto.Notification{
			Id:          notification.ID,
			Title:       notification.Title,
			Body:        notification.Body,
			ChannelId:   notification.ChannelID,
			ChannelName: notification.ChannelName,
			Type:        proto.NotificationType(proto.NotificationType_value[notification.Type]),
			CreatedAt:   timestamppb.New(notification.CreatedAt),
			IsRead:      notification.IsRead,
		})
	}

	return &proto.GetNotificationsResponse{
		Notifications: protoNotifications,
		TotalCount:    int32(len(protoNotifications)),
	}, nil
}

// MarkNotificationAsRead 通知を既読にする
func (s *Server) MarkNotificationAsRead(ctx context.Context, req *proto.MarkNotificationAsReadRequest) (*proto.MarkNotificationAsReadResponse, error) {
	user, err := s.authService.ValidateToken(ctx, req.AccessToken)
	if err != nil {
		return nil, status.Errorf(codes.Unauthenticated, "invalid token: %v", err)
	}

	err = s.markNotificationAsRead(req.NotificationId, user.ID)
	if err != nil {
		return nil, status.Errorf(codes.Internal, "failed to mark notification as read: %v", err)
	}

	return &proto.MarkNotificationAsReadResponse{
		Success: true,
		Message: "Notification marked as read",
	}, nil
}

// DeleteNotification 通知を削除
func (s *Server) DeleteNotification(ctx context.Context, req *proto.DeleteNotificationRequest) (*proto.DeleteNotificationResponse, error) {
	user, err := s.authService.ValidateToken(ctx, req.AccessToken)
	if err != nil {
		return nil, status.Errorf(codes.Unauthenticated, "invalid token: %v", err)
	}

	err = s.deleteNotification(req.NotificationId, user.ID)
	if err != nil {
		return nil, status.Errorf(codes.Internal, "failed to delete notification: %v", err)
	}

	return &proto.DeleteNotificationResponse{
		Success: true,
		Message: "Notification deleted",
	}, nil
}

// データベース操作のヘルパーメソッド
func (s *Server) createChannel(channel *models.Channel) error {
	query := `INSERT INTO channels (id, channel_id, name, last_video_id, last_live_scheduled_time, is_live, created_at, updated_at) VALUES ($1, $2, $3, $4, $5, $6, $7, $8) ON CONFLICT (channel_id) DO NOTHING`

	_, err := s.db.Exec(query, channel.ID, channel.ChannelID, channel.Name, channel.LastVideoID,
		channel.LastLiveScheduledTime, channel.IsLive, channel.CreatedAt, channel.UpdatedAt)
	return err
}

func (s *Server) getChannelByChannelID(channelID string) (*models.Channel, error) {
	query := `SELECT id, channel_id, name, last_video_id, last_live_scheduled_time, is_live, created_at, updated_at FROM channels WHERE channel_id = $1`

	var channel models.Channel
	err := s.db.QueryRow(query, channelID).Scan(
		&channel.ID, &channel.ChannelID, &channel.Name, &channel.LastVideoID,
		&channel.LastLiveScheduledTime, &channel.IsLive, &channel.CreatedAt, &channel.UpdatedAt,
	)

	if err != nil {
		return nil, err
	}

	return &channel, nil
}

func (s *Server) createUserChannel(userChannel *models.UserChannel) error {
	query := `INSERT INTO user_channels (id, user_id, channel_id, created_at) VALUES ($1, $2, $3, $4) ON CONFLICT (user_id, channel_id) DO NOTHING`

	_, err := s.db.Exec(query, userChannel.ID, userChannel.UserID, userChannel.ChannelID, userChannel.CreatedAt)
	return err
}

func (s *Server) deleteUserChannel(userID, channelID string) error {
	query := `DELETE FROM user_channels WHERE user_id = $1 AND channel_id = $2`

	_, err := s.db.Exec(query, userID, channelID)
	return err
}

func (s *Server) getUserChannels(userID string) ([]*models.Channel, error) {
	query := `
		SELECT c.id, c.channel_id, c.name, c.last_video_id, c.last_live_scheduled_time, c.is_live, c.created_at, c.updated_at
		FROM channels c
		JOIN user_channels uc ON c.id = uc.channel_id
		WHERE uc.user_id = $1
	`

	rows, err := s.db.Query(query, userID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var channels []*models.Channel
	for rows.Next() {
		var channel models.Channel
		err := rows.Scan(
			&channel.ID, &channel.ChannelID, &channel.Name, &channel.LastVideoID,
			&channel.LastLiveScheduledTime, &channel.IsLive, &channel.CreatedAt, &channel.UpdatedAt,
		)
		if err != nil {
			return nil, err
		}
		channels = append(channels, &channel)
	}

	return channels, nil
}

func (s *Server) getUserNotifications(userID string, limit, offset int32) ([]*models.Notification, error) {
	query := `
		SELECT id, user_id, channel_id, channel_name, title, body, type, is_read, created_at
		FROM notifications
		WHERE user_id = $1
		ORDER BY created_at DESC
		LIMIT $2 OFFSET $3
	`

	rows, err := s.db.Query(query, userID, limit, offset)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var notifications []*models.Notification
	for rows.Next() {
		var notification models.Notification
		err := rows.Scan(
			&notification.ID, &notification.UserID, &notification.ChannelID,
			&notification.ChannelName, &notification.Title, &notification.Body,
			&notification.Type, &notification.IsRead, &notification.CreatedAt,
		)
		if err != nil {
			return nil, err
		}
		notifications = append(notifications, &notification)
	}

	return notifications, nil
}

func (s *Server) markNotificationAsRead(notificationID, userID string) error {
	query := `UPDATE notifications SET is_read = true WHERE id = $1 AND user_id = $2`

	result, err := s.db.Exec(query, notificationID, userID)
	if err != nil {
		return err
	}

	rowsAffected, err := result.RowsAffected()
	if err != nil {
		return err
	}

	if rowsAffected == 0 {
		return fmt.Errorf("notification not found or not owned by user")
	}

	return nil
}

func (s *Server) deleteNotification(notificationID, userID string) error {
	query := `DELETE FROM notifications WHERE id = $1 AND user_id = $2`

	result, err := s.db.Exec(query, notificationID, userID)
	if err != nil {
		return err
	}

	rowsAffected, err := result.RowsAffected()
	if err != nil {
		return err
	}

	if rowsAffected == 0 {
		return fmt.Errorf("notification not found or not owned by user")
	}

	return nil
}

func main() {
	// 環境変数を読み込み
	if err := godotenv.Load(); err != nil {
		log.Printf("Warning: .env file not found")
	}

	// データベースに接続
	db, err := models.NewDatabase()
	if err != nil {
		log.Fatalf("Failed to connect to database: %v", err)
	}
	defer db.Close()

	// データベースマイグレーションを実行
	if err := db.Migrate(); err != nil {
		log.Fatalf("Failed to run database migration: %v", err)
	}

	// サーバーを作成
	server, err := NewServer(db)
	if err != nil {
		log.Fatalf("Failed to create server: %v", err)
	}

	// ポートを取得
	port := os.Getenv("GRPC_PORT")
	if port == "" {
		port = "50051"
	}

	// ホストを取得（デフォルトは全てのインターフェース）
	host := os.Getenv("GRPC_HOST")
	if host == "" {
		host = "127.0.0.1"
	}

	// SSL設定を確認
	useTLS := os.Getenv("USE_TLS")
	var lis net.Listener
	var grpcServer *grpc.Server

	if useTLS == "true" {
		// TLS証明書を読み込み
		cert, err := tls.LoadX509KeyPair("ssl/server.crt", "ssl/server.key")
		if err != nil {
			log.Fatalf("Failed to load TLS certificate: %v", err)
		}

		config := &tls.Config{
			Certificates: []tls.Certificate{cert},
		}

		// TLSリスナーを作成
		lis, err = tls.Listen("tcp", host+":"+port, config)
		if err != nil {
			log.Fatalf("Failed to listen with TLS: %v", err)
		}

		// TLS認証情報でgRPCサーバーを作成
		creds := credentials.NewTLS(config)
		grpcServer = grpc.NewServer(grpc.Creds(creds))
		log.Printf("Server listening with TLS on %s:%s", host, port)
	} else {
		// 通常のリスナーを作成
		lis, err = net.Listen("tcp", host+":"+port)
		if err != nil {
			log.Fatalf("Failed to listen: %v", err)
		}

		grpcServer = grpc.NewServer()
		log.Printf("Server listening without TLS on %s:%s", host, port)
	}

	// サービスを登録
	proto.RegisterAuthServiceServer(grpcServer, server)
	proto.RegisterChannelServiceServer(grpcServer, server)
	proto.RegisterNotificationServiceServer(grpcServer, server)

	// YouTube APIチェックの定期実行を開始
	c := cron.New()
	c.AddFunc("@every 1m", func() {
		log.Println("Checking for new live streams...")
		if err := server.youtubeService.CheckForNewLiveStreams(); err != nil {
			log.Printf("Error checking for new live streams: %v", err)
		}
	})
	c.Start()

	log.Printf("Server listening on port %s", port)
	if err := grpcServer.Serve(lis); err != nil {
		log.Fatalf("Failed to serve: %v", err)
	}
}
