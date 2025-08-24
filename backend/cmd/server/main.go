package main

import (
	"context"
	"fmt"
	"log"
	"net"
	"os"

	"oshizatsu-backend/internal/auth"
	"oshizatsu-backend/internal/models"
	"oshizatsu-backend/internal/notification"
	"oshizatsu-backend/internal/youtube"
	"oshizatsu-backend/proto"

	"github.com/joho/godotenv"
	"github.com/robfig/cron/v3"
	"google.golang.org/grpc"
	"google.golang.org/grpc/codes"
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
	// 簡略化のため、メールアドレスでユーザーを検索または作成
	user, err := s.authService.CreateUser(req.Email, "User", "")
	if err != nil {
		return nil, status.Errorf(codes.Internal, "failed to create user: %v", err)
	}

	// トークンを生成
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

	// ユーザーチャンネル関連を作成
	userChannel := models.NewUserChannel(user.ID, channel.ID)
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

	// gRPCサーバーを作成
	grpcServer := grpc.NewServer()

	// サービスを登録
	proto.RegisterAuthServiceServer(grpcServer, server)
	proto.RegisterChannelServiceServer(grpcServer, server)
	proto.RegisterNotificationServiceServer(grpcServer, server)

	// ポートを取得
	port := os.Getenv("GRPC_PORT")
	if port == "" {
		port = "50051"
	}

	// リスナーを作成
	lis, err := net.Listen("tcp", ":"+port)
	if err != nil {
		log.Fatalf("Failed to listen: %v", err)
	}

	// YouTube APIチェックの定期実行を開始
	c := cron.New()
	c.AddFunc("@hourly", func() {
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
