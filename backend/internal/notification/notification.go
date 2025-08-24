package notification

import (
	"context"
	"fmt"
	"os"

	"oshizatsu-backend/internal/models"

	firebase "firebase.google.com/go/v4"
	"firebase.google.com/go/v4/messaging"
	"google.golang.org/api/option"
)

// NotificationService FCM通知サービス
type NotificationService struct {
	app    *firebase.App
	client *messaging.Client
	db     *models.Database
}

// NewNotificationService 新しい通知サービスを作成
func NewNotificationService(db *models.Database) (*NotificationService, error) {
	// Firebase設定ファイルのパスを環境変数から取得
	configPath := os.Getenv("FIREBASE_CONFIG_PATH")
	if configPath == "" {
		return nil, fmt.Errorf("FIREBASE_CONFIG_PATH environment variable is required")
	}

	// Firebaseアプリを初期化
	opt := option.WithCredentialsFile(configPath)
	app, err := firebase.NewApp(context.Background(), nil, opt)
	if err != nil {
		return nil, fmt.Errorf("failed to initialize Firebase app: %v", err)
	}

	// FCMクライアントを作成
	client, err := app.Messaging(context.Background())
	if err != nil {
		return nil, fmt.Errorf("failed to create FCM client: %v", err)
	}

	return &NotificationService{
		app:    app,
		client: client,
		db:     db,
	}, nil
}

// RegisterFCMToken FCMトークンを登録
func (n *NotificationService) RegisterFCMToken(userID, token string) error {
	// 既存のトークンをチェック
	existingToken, err := n.getFCMTokenByUserID(userID)
	if err == nil {
		// 既存のトークンが同じ場合は何もしない
		if existingToken.Token == token {
			return nil
		}
		// 既存のトークンを更新
		return n.updateFCMToken(existingToken.ID, token)
	}

	// 新しいトークンを作成
	fcmToken := models.NewFCMToken(userID, token)
	return n.createFCMToken(fcmToken)
}

// UnregisterFCMToken FCMトークンを削除
func (n *NotificationService) UnregisterFCMToken(userID, token string) error {
	query := `DELETE FROM fcm_tokens WHERE user_id = $1 AND token = $2`
	_, err := n.db.Exec(query, userID, token)
	return err
}

// SendNotification 通知を送信
func (n *NotificationService) SendNotification(notification *models.Notification) error {
	// ユーザーのFCMトークンを取得
	tokens, err := n.getFCMTokensByUserID(notification.UserID)
	if err != nil {
		return fmt.Errorf("failed to get FCM tokens: %v", err)
	}

	if len(tokens) == 0 {
		return fmt.Errorf("no FCM tokens found for user %s", notification.UserID)
	}

	// 各トークンに通知を送信
	for _, token := range tokens {
		if err := n.sendToToken(token.Token, notification); err != nil {
			fmt.Printf("Failed to send notification to token %s: %v\n", token.Token, err)
			continue
		}
	}

	return nil
}

// SendNotificationToChannel チャンネルの全サブスクライバーに通知を送信
func (n *NotificationService) SendNotificationToChannel(channelID, title, body, notificationType string) error {
	// チャンネルをサブスクライブしているユーザーを取得
	users, err := n.getSubscribedUsers(channelID)
	if err != nil {
		return fmt.Errorf("failed to get subscribed users: %v", err)
	}

	// 各ユーザーに通知を送信
	for _, user := range users {
		notification := models.NewNotification(
			user.ID,
			channelID,
			"", // チャンネル名は後で設定
			title,
			body,
			notificationType,
		)

		if err := n.SendNotification(notification); err != nil {
			fmt.Printf("Failed to send notification to user %s: %v\n", user.ID, err)
			continue
		}

		// データベースに通知を保存
		if err := n.createNotification(notification); err != nil {
			fmt.Printf("Failed to save notification for user %s: %v\n", user.ID, err)
			continue
		}
	}

	return nil
}

// sendToToken 特定のトークンに通知を送信
func (n *NotificationService) sendToToken(token string, notification *models.Notification) error {
	message := &messaging.Message{
		Token: token,
		Notification: &messaging.Notification{
			Title: notification.Title,
			Body:  notification.Body,
		},
		Data: map[string]string{
			"notification_id": notification.ID,
			"channel_id":      notification.ChannelID,
			"channel_name":    notification.ChannelName,
			"type":            notification.Type,
		},
		Android: &messaging.AndroidConfig{
			Notification: &messaging.AndroidNotification{
				ChannelID: "oshizatsu_notifications",
				Priority:  messaging.PriorityHigh,
			},
		},
		APNS: &messaging.APNSConfig{
			Payload: &messaging.APNSPayload{
				Aps: &messaging.Aps{
					Alert: &messaging.ApsAlert{
						Title: notification.Title,
						Body:  notification.Body,
					},
					Sound: "default",
				},
			},
		},
	}

	_, err := n.client.Send(context.Background(), message)
	return err
}

// getFCMTokenByUserID ユーザーIDでFCMトークンを取得
func (n *NotificationService) getFCMTokenByUserID(userID string) (*models.FCMToken, error) {
	query := `SELECT id, user_id, token, created_at, updated_at FROM fcm_tokens WHERE user_id = $1 LIMIT 1`

	var token models.FCMToken
	err := n.db.QueryRow(query, userID).Scan(
		&token.ID, &token.UserID, &token.Token, &token.CreatedAt, &token.UpdatedAt,
	)

	if err != nil {
		return nil, err
	}

	return &token, nil
}

// getFCMTokensByUserID ユーザーIDでFCMトークンを取得（複数）
func (n *NotificationService) getFCMTokensByUserID(userID string) ([]*models.FCMToken, error) {
	query := `SELECT id, user_id, token, created_at, updated_at FROM fcm_tokens WHERE user_id = $1`

	rows, err := n.db.Query(query, userID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var tokens []*models.FCMToken
	for rows.Next() {
		var token models.FCMToken
		err := rows.Scan(
			&token.ID, &token.UserID, &token.Token, &token.CreatedAt, &token.UpdatedAt,
		)
		if err != nil {
			return nil, err
		}
		tokens = append(tokens, &token)
	}

	return tokens, nil
}

// createFCMToken FCMトークンを作成
func (n *NotificationService) createFCMToken(token *models.FCMToken) error {
	query := `INSERT INTO fcm_tokens (id, user_id, token, created_at, updated_at) VALUES ($1, $2, $3, $4, $5)`

	_, err := n.db.Exec(query, token.ID, token.UserID, token.Token, token.CreatedAt, token.UpdatedAt)
	return err
}

// updateFCMToken FCMトークンを更新
func (n *NotificationService) updateFCMToken(tokenID, newToken string) error {
	query := `UPDATE fcm_tokens SET token = $1, updated_at = NOW() WHERE id = $2`

	_, err := n.db.Exec(query, newToken, tokenID)
	return err
}

// getSubscribedUsers チャンネルをサブスクライブしているユーザーを取得
func (n *NotificationService) getSubscribedUsers(channelID string) ([]*models.User, error) {
	query := `
		SELECT u.id, u.email, u.name, u.picture, u.created_at, u.updated_at
		FROM users u
		JOIN user_channels uc ON u.id = uc.user_id
		WHERE uc.channel_id = $1
	`

	rows, err := n.db.Query(query, channelID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var users []*models.User
	for rows.Next() {
		var user models.User
		err := rows.Scan(
			&user.ID, &user.Email, &user.Name, &user.Picture,
			&user.CreatedAt, &user.UpdatedAt,
		)
		if err != nil {
			return nil, err
		}
		users = append(users, &user)
	}

	return users, nil
}

// createNotification 通知を作成
func (n *NotificationService) createNotification(notification *models.Notification) error {
	query := `INSERT INTO notifications (id, user_id, channel_id, channel_name, title, body, type, is_read, created_at) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9)`

	_, err := n.db.Exec(query, notification.ID, notification.UserID, notification.ChannelID,
		notification.ChannelName, notification.Title, notification.Body, notification.Type,
		notification.IsRead, notification.CreatedAt)
	return err
}
