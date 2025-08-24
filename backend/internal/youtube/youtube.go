package youtube

import (
	"encoding/xml"
	"fmt"
	"io"
	"net/http"
	"os"
	"strings"
	"time"

	"oshizatsu-backend/internal/models"

	"google.golang.org/api/googleapi/transport"
	"google.golang.org/api/youtube/v3"
)

// YouTubeService YouTube API連携サービス
type YouTubeService struct {
	service *youtube.Service
	db      *models.Database
}

// RSSFeed RSSフィードの構造
type RSSFeed struct {
	XMLName xml.Name `xml:"feed"`
	Entries []Entry  `xml:"entry"`
}

// Entry RSSエントリの構造
type Entry struct {
	VideoID string `xml:"videoId"`
	Title   string `xml:"title"`
	Updated string `xml:"updated"`
}

// NewYouTubeService 新しいYouTubeサービスを作成
func NewYouTubeService(db *models.Database) (*YouTubeService, error) {
	// YouTube APIキーを環境変数から取得
	apiKey := os.Getenv("YOUTUBE_API_KEY")
	if apiKey == "" {
		return nil, fmt.Errorf("YOUTUBE_API_KEY environment variable is required")
	}

	// YouTube APIクライアントを作成
	client := &http.Client{
		Transport: &transport.APIKey{Key: apiKey},
	}

	service, err := youtube.New(client)
	if err != nil {
		return nil, fmt.Errorf("failed to create YouTube service: %v", err)
	}

	return &YouTubeService{
		service: service,
		db:      db,
	}, nil
}

// GetLatestVideos RSSフィードから最新の動画を取得
func (y *YouTubeService) GetLatestVideos(channelID string) ([]Entry, error) {
	// RSSフィードのURLを作成
	rssURL := fmt.Sprintf("https://www.youtube.com/feeds/videos.xml?channel_id=%s", channelID)

	// RSSフィードを取得
	resp, err := http.Get(rssURL)
	if err != nil {
		return nil, fmt.Errorf("failed to fetch RSS feed: %v", err)
	}
	defer resp.Body.Close()

	// レスポンスを読み取り
	body, err := io.ReadAll(resp.Body)
	if err != nil {
		return nil, fmt.Errorf("failed to read response body: %v", err)
	}

	// XMLをパース
	var feed RSSFeed
	if err := xml.Unmarshal(body, &feed); err != nil {
		return nil, fmt.Errorf("failed to parse RSS feed: %v", err)
	}

	return feed.Entries, nil
}

// GetVideoDetails 動画の詳細情報を取得
func (y *YouTubeService) GetVideoDetails(videoIDs []string) ([]*youtube.Video, error) {
	if len(videoIDs) == 0 {
		return []*youtube.Video{}, nil
	}

	// 動画IDをカンマ区切りで結合
	videoIDsStr := strings.Join(videoIDs, ",")

	// YouTube APIで動画情報を取得
	call := y.service.Videos.List([]string{"liveStreamingDetails", "snippet"}).Id(videoIDsStr)
	response, err := call.Do()
	if err != nil {
		return nil, fmt.Errorf("failed to get video details: %v", err)
	}

	return response.Items, nil
}

// CheckForNewLiveStreams 新しいライブ配信をチェック
func (y *YouTubeService) CheckForNewLiveStreams() error {
	// 登録されているチャンネルを取得
	channels, err := y.getSubscribedChannels()
	if err != nil {
		return fmt.Errorf("failed to get subscribed channels: %v", err)
	}

	for _, channel := range channels {
		if err := y.checkChannelForNewLiveStreams(channel); err != nil {
			fmt.Printf("Error checking channel %s: %v\n", channel.ChannelID, err)
			continue
		}
	}

	return nil
}

// checkChannelForNewLiveStreams 特定のチャンネルで新しいライブ配信をチェック
func (y *YouTubeService) checkChannelForNewLiveStreams(channel *models.Channel) error {
	// 最新の動画を取得
	entries, err := y.GetLatestVideos(channel.ChannelID)
	if err != nil {
		return fmt.Errorf("failed to get latest videos: %v", err)
	}

	if len(entries) == 0 {
		return nil
	}

	// 最新の動画IDを取得
	latestVideoID := entries[0].VideoID

	// 既に処理済みの動画の場合はスキップ
	if channel.LastVideoID == latestVideoID {
		return nil
	}

	// 動画の詳細情報を取得
	videos, err := y.GetVideoDetails([]string{latestVideoID})
	if err != nil {
		return fmt.Errorf("failed to get video details: %v", err)
	}

	if len(videos) == 0 {
		return nil
	}

	video := videos[0]

	// ライブ配信の情報をチェック
	if video.LiveStreamingDetails != nil {
		// ライブ配信が予約されている場合
		if video.LiveStreamingDetails.ScheduledStartTime != "" {
			scheduledTime, err := time.Parse(time.RFC3339, video.LiveStreamingDetails.ScheduledStartTime)
			if err != nil {
				return fmt.Errorf("failed to parse scheduled start time: %v", err)
			}

			// 新しいライブ配信の予約を検出
			if channel.LastLiveScheduledTime == nil || scheduledTime.After(*channel.LastLiveScheduledTime) {
				// チャンネル情報を更新
				channel.LastVideoID = latestVideoID
				channel.LastLiveScheduledTime = &scheduledTime
				channel.IsLive = false
				channel.UpdatedAt = time.Now()

				if err := y.updateChannel(channel); err != nil {
					return fmt.Errorf("failed to update channel: %v", err)
				}

				// 通知を送信
				if err := y.sendScheduledNotification(channel, video); err != nil {
					return fmt.Errorf("failed to send scheduled notification: %v", err)
				}
			}
		}

		// ライブ配信が開始された場合
		if video.LiveStreamingDetails.ActualStartTime != "" {
			_, err := time.Parse(time.RFC3339, video.LiveStreamingDetails.ActualStartTime)
			if err != nil {
				return fmt.Errorf("failed to parse actual start time: %v", err)
			}

			// ライブ配信が開始されたことを検出
			if !channel.IsLive {
				// チャンネル情報を更新
				channel.LastVideoID = latestVideoID
				channel.IsLive = true
				channel.UpdatedAt = time.Now()

				if err := y.updateChannel(channel); err != nil {
					return fmt.Errorf("failed to update channel: %v", err)
				}

				// 通知を送信
				if err := y.sendStartedNotification(channel, video); err != nil {
					return fmt.Errorf("failed to send started notification: %v", err)
				}
			}
		}
	}

	// 通常の動画の場合は、LastVideoIDのみ更新
	if video.LiveStreamingDetails == nil {
		channel.LastVideoID = latestVideoID
		channel.UpdatedAt = time.Now()

		if err := y.updateChannel(channel); err != nil {
			return fmt.Errorf("failed to update channel: %v", err)
		}
	}

	return nil
}

// getSubscribedChannels 登録されているチャンネルを取得
func (y *YouTubeService) getSubscribedChannels() ([]*models.Channel, error) {
	query := `SELECT id, channel_id, name, last_video_id, last_live_scheduled_time, is_live, created_at, updated_at FROM channels`

	rows, err := y.db.Query(query)
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

// updateChannel チャンネル情報を更新
func (y *YouTubeService) updateChannel(channel *models.Channel) error {
	query := `UPDATE channels SET last_video_id = $1, last_live_scheduled_time = $2, is_live = $3, updated_at = $4 WHERE id = $5`

	_, err := y.db.Exec(query, channel.LastVideoID, channel.LastLiveScheduledTime, channel.IsLive, channel.UpdatedAt, channel.ID)
	return err
}

// sendScheduledNotification ライブ配信予約通知を送信
func (y *YouTubeService) sendScheduledNotification(channel *models.Channel, video *youtube.Video) error {
	// チャンネルをサブスクライブしているユーザーを取得
	users, err := y.getSubscribedUsers(channel.ID)
	if err != nil {
		return fmt.Errorf("failed to get subscribed users: %v", err)
	}

	// 各ユーザーに通知を送信
	for _, user := range users {
		notification := models.NewNotification(
			user.ID,
			channel.ID,
			channel.Name,
			"ライブ配信が予約されました",
			fmt.Sprintf("%s のライブ配信が予約されました", channel.Name),
			"scheduled",
		)

		if err := y.createNotification(notification); err != nil {
			fmt.Printf("Failed to create notification for user %s: %v\n", user.ID, err)
			continue
		}
	}

	return nil
}

// sendStartedNotification ライブ配信開始通知を送信
func (y *YouTubeService) sendStartedNotification(channel *models.Channel, video *youtube.Video) error {
	// チャンネルをサブスクライブしているユーザーを取得
	users, err := y.getSubscribedUsers(channel.ID)
	if err != nil {
		return fmt.Errorf("failed to get subscribed users: %v", err)
	}

	// 各ユーザーに通知を送信
	for _, user := range users {
		notification := models.NewNotification(
			user.ID,
			channel.ID,
			channel.Name,
			"ライブ配信が開始されました",
			fmt.Sprintf("%s のライブ配信が開始されました", channel.Name),
			"started",
		)

		if err := y.createNotification(notification); err != nil {
			fmt.Printf("Failed to create notification for user %s: %v\n", user.ID, err)
			continue
		}
	}

	return nil
}

// getSubscribedUsers チャンネルをサブスクライブしているユーザーを取得
func (y *YouTubeService) getSubscribedUsers(channelID string) ([]*models.User, error) {
	query := `
		SELECT u.id, u.email, u.name, u.picture, u.created_at, u.updated_at
		FROM users u
		JOIN user_channels uc ON u.id = uc.user_id
		WHERE uc.channel_id = $1
	`

	rows, err := y.db.Query(query, channelID)
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
func (y *YouTubeService) createNotification(notification *models.Notification) error {
	query := `INSERT INTO notifications (id, user_id, channel_id, channel_name, title, body, type, is_read, created_at) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9)`

	_, err := y.db.Exec(query, notification.ID, notification.UserID, notification.ChannelID,
		notification.ChannelName, notification.Title, notification.Body, notification.Type,
		notification.IsRead, notification.CreatedAt)
	return err
}
