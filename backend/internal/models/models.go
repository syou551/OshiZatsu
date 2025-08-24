package models

import (
	"time"

	"github.com/google/uuid"
)

// User ユーザー情報
type User struct {
	ID        string    `json:"id" db:"id"`
	Email     string    `json:"email" db:"email"`
	Name      string    `json:"name" db:"name"`
	Picture   string    `json:"picture" db:"picture"`
	CreatedAt time.Time `json:"created_at" db:"created_at"`
	UpdatedAt time.Time `json:"updated_at" db:"updated_at"`
}

// FCMToken FCMトークン管理
type FCMToken struct {
	ID        string    `json:"id" db:"id"`
	UserID    string    `json:"user_id" db:"user_id"`
	Token     string    `json:"token" db:"token"`
	CreatedAt time.Time `json:"created_at" db:"created_at"`
	UpdatedAt time.Time `json:"updated_at" db:"updated_at"`
}

// Channel YouTubeチャンネル情報
type Channel struct {
	ID                    string     `json:"id" db:"id"`
	ChannelID             string     `json:"channel_id" db:"channel_id"`
	Name                  string     `json:"name" db:"name"`
	LastVideoID           string     `json:"last_video_id" db:"last_video_id"`
	LastLiveScheduledTime *time.Time `json:"last_live_scheduled_time" db:"last_live_scheduled_time"`
	IsLive                bool       `json:"is_live" db:"is_live"`
	CreatedAt             time.Time  `json:"created_at" db:"created_at"`
	UpdatedAt             time.Time  `json:"updated_at" db:"updated_at"`
}

// UserChannel ユーザーとチャンネルの関連
type UserChannel struct {
	ID        string    `json:"id" db:"id"`
	UserID    string    `json:"user_id" db:"user_id"`
	ChannelID string    `json:"channel_id" db:"channel_id"`
	CreatedAt time.Time `json:"created_at" db:"created_at"`
}

// Notification 通知情報
type Notification struct {
	ID          string    `json:"id" db:"id"`
	UserID      string    `json:"user_id" db:"user_id"`
	ChannelID   string    `json:"channel_id" db:"channel_id"`
	ChannelName string    `json:"channel_name" db:"channel_name"`
	Title       string    `json:"title" db:"title"`
	Body        string    `json:"body" db:"body"`
	Type        string    `json:"type" db:"type"` // "scheduled" or "started"
	IsRead      bool      `json:"is_read" db:"is_read"`
	CreatedAt   time.Time `json:"created_at" db:"created_at"`
}

// YouTubeVideo YouTube動画情報
type YouTubeVideo struct {
	ID                 string     `json:"id" db:"id"`
	VideoID            string     `json:"video_id" db:"video_id"`
	ChannelID          string     `json:"channel_id" db:"channel_id"`
	Title              string     `json:"title" db:"title"`
	Description        string     `json:"description" db:"description"`
	ScheduledStartTime *time.Time `json:"scheduled_start_time" db:"scheduled_start_time"`
	ActualStartTime    *time.Time `json:"actual_start_time" db:"actual_start_time"`
	Status             string     `json:"status" db:"status"` // "upcoming", "live", "ended"
	CreatedAt          time.Time  `json:"created_at" db:"created_at"`
	UpdatedAt          time.Time  `json:"updated_at" db:"updated_at"`
}

// NewUser 新しいユーザーを作成
func NewUser(email, name, picture string) *User {
	return &User{
		ID:        uuid.New().String(),
		Email:     email,
		Name:      name,
		Picture:   picture,
		CreatedAt: time.Now(),
		UpdatedAt: time.Now(),
	}
}

// NewFCMToken 新しいFCMトークンを作成
func NewFCMToken(userID, token string) *FCMToken {
	return &FCMToken{
		ID:        uuid.New().String(),
		UserID:    userID,
		Token:     token,
		CreatedAt: time.Now(),
		UpdatedAt: time.Now(),
	}
}

// NewChannel 新しいチャンネルを作成
func NewChannel(channelID, name string) *Channel {
	return &Channel{
		ID:        uuid.New().String(),
		ChannelID: channelID,
		Name:      name,
		IsLive:    false,
		CreatedAt: time.Now(),
		UpdatedAt: time.Now(),
	}
}

// NewUserChannel 新しいユーザーチャンネル関連を作成
func NewUserChannel(userID, channelID string) *UserChannel {
	return &UserChannel{
		ID:        uuid.New().String(),
		UserID:    userID,
		ChannelID: channelID,
		CreatedAt: time.Now(),
	}
}

// NewNotification 新しい通知を作成
func NewNotification(userID, channelID, channelName, title, body, notificationType string) *Notification {
	return &Notification{
		ID:          uuid.New().String(),
		UserID:      userID,
		ChannelID:   channelID,
		ChannelName: channelName,
		Title:       title,
		Body:        body,
		Type:        notificationType,
		IsRead:      false,
		CreatedAt:   time.Now(),
	}
}

// NewYouTubeVideo 新しいYouTube動画を作成
func NewYouTubeVideo(videoID, channelID, title, description, status string) *YouTubeVideo {
	return &YouTubeVideo{
		ID:          uuid.New().String(),
		VideoID:     videoID,
		ChannelID:   channelID,
		Title:       title,
		Description: description,
		Status:      status,
		CreatedAt:   time.Now(),
		UpdatedAt:   time.Now(),
	}
}
