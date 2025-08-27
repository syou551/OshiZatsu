package models

import (
	"database/sql"
	"fmt"
	"log"
	"os"

	_ "github.com/lib/pq"
)

// Database データベース接続管理
type Database struct {
	*sql.DB
}

// NewDatabase 新しいデータベース接続を作成
func NewDatabase() (*Database, error) {
	// 環境変数からデータベース接続情報を取得
	dbHost := getEnv("DB_HOST", "localhost")
	dbPort := getEnv("DB_PORT", "5432")
	dbUser := getEnv("DB_USER", "postgres")
	dbPassword := getEnv("DB_PASSWORD", "password")
	dbName := getEnv("DB_NAME", "oshizatsu")

	// データベース接続文字列を作成
	connStr := fmt.Sprintf("host=%s port=%s user=%s password=%s dbname=%s sslmode=disable",
		dbHost, dbPort, dbUser, dbPassword, dbName)

	// データベースに接続
	db, err := sql.Open("postgres", connStr)
	if err != nil {
		return nil, fmt.Errorf("failed to connect to database: %v", err)
	}

	// 接続をテスト
	if err := db.Ping(); err != nil {
		return nil, fmt.Errorf("failed to ping database: %v", err)
	}

	log.Println("Successfully connected to database")

	return &Database{db}, nil
}

// Close データベース接続を閉じる
func (db *Database) Close() error {
	return db.DB.Close()
}

// Migrate データベースマイグレーションを実行
func (db *Database) Migrate() error {
	queries := []string{
		// ユーザーテーブル
		`CREATE TABLE IF NOT EXISTS users (
			id UUID PRIMARY KEY,
			email VARCHAR(255) UNIQUE NOT NULL,
			name VARCHAR(255) NOT NULL,
			picture TEXT,
			created_at TIMESTAMP NOT NULL DEFAULT NOW(),
			updated_at TIMESTAMP NOT NULL DEFAULT NOW()
		)`,

		// FCMトークンテーブル
		`CREATE TABLE IF NOT EXISTS fcm_tokens (
			id UUID PRIMARY KEY,
			user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
			token TEXT NOT NULL,
			created_at TIMESTAMP NOT NULL DEFAULT NOW(),
			updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
			UNIQUE(user_id, token)
		)`,

		// チャンネルテーブル
		`CREATE TABLE IF NOT EXISTS channels (
			id UUID PRIMARY KEY,
			channel_id VARCHAR(255) UNIQUE NOT NULL,
			name VARCHAR(255) NOT NULL,
			last_video_id VARCHAR(255),
			last_live_scheduled_time TIMESTAMP,
			is_live BOOLEAN NOT NULL DEFAULT FALSE,
			created_at TIMESTAMP NOT NULL DEFAULT NOW(),
			updated_at TIMESTAMP NOT NULL DEFAULT NOW()
		)`,

		// ユーザーチャンネル関連テーブル
		`CREATE TABLE IF NOT EXISTS user_channels (
			id UUID PRIMARY KEY,
			user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
			channel_id UUID NOT NULL REFERENCES channels(id) ON DELETE CASCADE,
			created_at TIMESTAMP NOT NULL DEFAULT NOW(),
			UNIQUE(user_id, channel_id)
		)`,

		// 通知テーブル
		`CREATE TABLE IF NOT EXISTS notifications (
			id UUID PRIMARY KEY,
			user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
			channel_id UUID NOT NULL REFERENCES channels(id) ON DELETE CASCADE,
			channel_name VARCHAR(255) NOT NULL,
			title VARCHAR(255) NOT NULL,
			body TEXT NOT NULL,
			type VARCHAR(50) NOT NULL,
			is_read BOOLEAN NOT NULL DEFAULT FALSE,
			created_at TIMESTAMP NOT NULL DEFAULT NOW()
		)`,

		// YouTube動画テーブル
		`CREATE TABLE IF NOT EXISTS youtube_videos (
			id UUID PRIMARY KEY,
			video_id VARCHAR(255) UNIQUE NOT NULL,
			channel_id UUID NOT NULL REFERENCES channels(id) ON DELETE CASCADE,
			title VARCHAR(500) NOT NULL,
			description TEXT,
			scheduled_start_time TIMESTAMP,
			actual_start_time TIMESTAMP,
			status VARCHAR(50) NOT NULL,
			created_at TIMESTAMP NOT NULL DEFAULT NOW(),
			updated_at TIMESTAMP NOT NULL DEFAULT NOW()
		)`,

		// インデックスを作成
		`CREATE INDEX IF NOT EXISTS idx_users_email ON users(email)`,
		`CREATE INDEX IF NOT EXISTS idx_fcm_tokens_user_id ON fcm_tokens(user_id)`,
		`CREATE INDEX IF NOT EXISTS idx_channels_channel_id ON channels(channel_id)`,
		`CREATE INDEX IF NOT EXISTS idx_user_channels_user_id ON user_channels(user_id)`,
		`CREATE INDEX IF NOT EXISTS idx_user_channels_channel_id ON user_channels(channel_id)`,
		`CREATE INDEX IF NOT EXISTS idx_notifications_user_id ON notifications(user_id)`,
		`CREATE INDEX IF NOT EXISTS idx_notifications_created_at ON notifications(created_at)`,
		`CREATE INDEX IF NOT EXISTS idx_youtube_videos_channel_id ON youtube_videos(channel_id)`,
		`CREATE INDEX IF NOT EXISTS idx_youtube_videos_video_id ON youtube_videos(video_id)`,
	}

	// 各クエリを実行
	for i, query := range queries {
		if _, err := db.Exec(query); err != nil {
			return fmt.Errorf("failed to execute migration query %d: %v", i+1, err)
		}
		log.Printf("Executed migration query %d", i+1)
	}

	log.Println("Database migration completed successfully")
	return nil
}

// getEnv 環境変数を取得（デフォルト値付き）
func getEnv(key, defaultValue string) string {
	if value := os.Getenv(key); value != "" {
		return value
	}
	return defaultValue
}
