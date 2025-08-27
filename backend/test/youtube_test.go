package test

import (
	"testing"

	"oshizatsu-backend/internal/models"
	"oshizatsu-backend/internal/youtube"
)

func TestYouTubeService_GetLatestVideos(t *testing.T) {
	// テスト用データベースを作成
	db, err := createTestDatabase()
	if err != nil {
		t.Fatalf("Failed to create test database: %v", err)
	}
	defer db.Close()

	// YouTubeサービスを作成（APIキーが設定されていない場合はスキップ）
	youtubeService, err := youtube.NewYouTubeService(db)
	if err != nil {
		t.Skipf("Skipping test due to missing YouTube API key: %v", err)
	}

	// テストケース
	tests := []struct {
		name      string
		channelID string
		wantErr   bool
	}{
		{
			name:      "有効なチャンネルID",
			channelID: "UC-lHJZR3Gqxm24_Vd_AJ5Yw", // PewDiePieのチャンネルID
			wantErr:   false,
		},
		{
			name:      "無効なチャンネルID",
			channelID: "invalid-channel-id",
			wantErr:   true,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			entries, err := youtubeService.GetLatestVideos(tt.channelID)
			if (err != nil) != tt.wantErr {
				t.Errorf("GetLatestVideos() error = %v, wantErr %v", err, tt.wantErr)
				return
			}

			if !tt.wantErr && len(entries) == 0 {
				t.Error("GetLatestVideos() returned empty entries for valid channel")
			}
		})
	}
}

func TestYouTubeService_GetVideoDetails(t *testing.T) {
	// テスト用データベースを作成
	db, err := createTestDatabase()
	if err != nil {
		t.Fatalf("Failed to create test database: %v", err)
	}
	defer db.Close()

	// YouTubeサービスを作成
	youtubeService, err := youtube.NewYouTubeService(db)
	if err != nil {
		t.Skipf("Skipping test due to missing YouTube API key: %v", err)
	}

	// テストケース
	tests := []struct {
		name     string
		videoIDs []string
		wantErr  bool
	}{
		{
			name:     "有効な動画ID",
			videoIDs: []string{"dQw4w9WgXcQ"}, // Rick Astley - Never Gonna Give You Up
			wantErr:  false,
		},
		{
			name:     "無効な動画ID",
			videoIDs: []string{"invalid-video-id"},
			wantErr:  true,
		},
		{
			name:     "空の動画IDリスト",
			videoIDs: []string{},
			wantErr:  false,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			videos, err := youtubeService.GetVideoDetails(tt.videoIDs)
			if (err != nil) != tt.wantErr {
				t.Errorf("GetVideoDetails() error = %v, wantErr %v", err, tt.wantErr)
				return
			}

			if !tt.wantErr && len(tt.videoIDs) > 0 && len(videos) == 0 {
				t.Error("GetVideoDetails() returned empty videos for valid video IDs")
			}
		})
	}
}

func TestYouTubeService_CheckForNewLiveStreams(t *testing.T) {
	// テスト用データベースを作成
	db, err := createTestDatabase()
	if err != nil {
		t.Fatalf("Failed to create test database: %v", err)
	}
	defer db.Close()

	// YouTubeサービスを作成
	youtubeService, err := youtube.NewYouTubeService(db)
	if err != nil {
		t.Skipf("Skipping test due to missing YouTube API key: %v", err)
	}

	// テストケース
	tests := []struct {
		name    string
		wantErr bool
	}{
		{
			name:    "ライブ配信チェック",
			wantErr: false,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			err := youtubeService.CheckForNewLiveStreams()
			if (err != nil) != tt.wantErr {
				t.Errorf("CheckForNewLiveStreams() error = %v, wantErr %v", err, tt.wantErr)
				return
			}
		})
	}
}

func TestYouTubeService_ChannelOperations(t *testing.T) {
	// テスト用データベースを作成
	db, err := createTestDatabase()
	if err != nil {
		t.Fatalf("Failed to create test database: %v", err)
	}
	defer db.Close()

	// YouTubeサービスを作成
	youtubeService, err := youtube.NewYouTubeService(db)
	if err != nil {
		t.Skipf("Skipping test due to missing YouTube API key: %v", err)
	}

	// 基本的な機能テスト
	if youtubeService == nil {
		t.Error("YouTube service is nil")
	}
}

func TestYouTubeService_NotificationOperations(t *testing.T) {
	t.Skip("Skipping test due to missing call notification makeing function")
	// テスト用データベースを作成
	db, err := createTestDatabase()
	if err != nil {
		t.Fatalf("Failed to create test database: %v", err)
	}
	defer db.Close()

	// YouTubeサービスを作成
	youtubeService, err := youtube.NewYouTubeService(db)
	if err != nil {
		t.Skipf("Skipping test due to missing YouTube API key: %v", err)
	}

	// テストユーザーを作成
	user := models.NewUser("test@example.com", "Test User", "")
	if err := createTestUser(db, user); err != nil {
		t.Fatalf("Failed to create test user: %v", err)
	}

	// 基本的な機能テスト
	if youtubeService == nil {
		t.Error("YouTube service is nil")
	}

	// 通知が作成されたことを確認
	notifications, err := getUserNotifications(db, user.ID, 10, 0)
	if err != nil {
		t.Fatalf("Failed to get user notifications: %v", err)
	}

	if len(notifications) == 0 {
		t.Error("No notifications found after creation")
	}
}

// ヘルパー関数
func createTestUser(db *models.Database, user *models.User) error {
	query := `INSERT INTO users (id, email, name, picture, created_at, updated_at) VALUES ($1, $2, $3, $4, $5, $6)`
	_, err := db.Exec(query, user.ID, user.Email, user.Name, user.Picture, user.CreatedAt, user.UpdatedAt)
	return err
}

func createTestUserChannel(db *models.Database, userChannel *models.UserChannel) error {
	query := `INSERT INTO user_channels (id, user_id, channel_id, created_at) VALUES ($1, $2, $3, $4)`
	_, err := db.Exec(query, userChannel.ID, userChannel.UserID, userChannel.ChannelID, userChannel.CreatedAt)
	return err
}

func getUserNotifications(db *models.Database, userID string, limit, offset int32) ([]*models.Notification, error) {
	query := `
		SELECT id, user_id, channel_id, channel_name, title, body, type, is_read, created_at
		FROM notifications
		WHERE user_id = $1
		ORDER BY created_at DESC
		LIMIT $2 OFFSET $3
	`

	rows, err := db.Query(query, userID, limit, offset)
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
