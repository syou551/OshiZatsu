-- テスト用データベース初期化スクリプト
-- このファイルはPostgreSQLコンテナ起動時に自動実行されます

-- テスト用の拡張機能を有効化
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- oshizatsuデータベースを作成（本番用）
CREATE DATABASE oshizatsu;

-- oshizatsu_testデータベースに接続してスキーマを作成
\c oshizatsu_test;

-- スキーマを作成（database.goのMigrate関数と同じ内容）
-- ユーザーテーブル
CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    name VARCHAR(255) NOT NULL,
    picture TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

-- FCMトークンテーブル
CREATE TABLE IF NOT EXISTS fcm_tokens (
    id UUID PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    token TEXT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
    UNIQUE(user_id, token)
);

-- チャンネルテーブル
CREATE TABLE IF NOT EXISTS channels (
    id UUID PRIMARY KEY,
    channel_id VARCHAR(255) UNIQUE NOT NULL,
    name VARCHAR(255) NOT NULL,
    last_video_id VARCHAR(255),
    last_live_scheduled_time TIMESTAMP,
    is_live BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

-- ユーザーチャンネル関連テーブル
CREATE TABLE IF NOT EXISTS user_channels (
    id UUID PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    channel_id UUID NOT NULL REFERENCES channels(id) ON DELETE CASCADE,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    UNIQUE(user_id, channel_id)
);

-- 通知テーブル
CREATE TABLE IF NOT EXISTS notifications (
    id UUID PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    channel_id UUID NOT NULL REFERENCES channels(id) ON DELETE CASCADE,
    channel_name VARCHAR(255) NOT NULL,
    title VARCHAR(255) NOT NULL,
    body TEXT NOT NULL,
    type VARCHAR(50) NOT NULL,
    is_read BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

-- YouTube動画テーブル
CREATE TABLE IF NOT EXISTS youtube_videos (
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
);

-- インデックスを作成
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);
CREATE INDEX IF NOT EXISTS idx_fcm_tokens_user_id ON fcm_tokens(user_id);
CREATE INDEX IF NOT EXISTS idx_channels_channel_id ON channels(channel_id);
CREATE INDEX IF NOT EXISTS idx_user_channels_user_id ON user_channels(user_id);
CREATE INDEX IF NOT EXISTS idx_user_channels_channel_id ON user_channels(channel_id);
CREATE INDEX IF NOT EXISTS idx_notifications_user_id ON notifications(user_id);
CREATE INDEX IF NOT EXISTS idx_notifications_created_at ON notifications(created_at);
CREATE INDEX IF NOT EXISTS idx_youtube_videos_channel_id ON youtube_videos(channel_id);
CREATE INDEX IF NOT EXISTS idx_youtube_videos_video_id ON youtube_videos(video_id);

-- テスト用のサンプルユーザーを作成
INSERT INTO users (id, email, name, picture, created_at, updated_at) VALUES
    (uuid_generate_v4(), 'test1@example.com', 'テストユーザー1', 'https://example.com/avatar1.jpg', NOW(), NOW()),
    (uuid_generate_v4(), 'test2@example.com', 'テストユーザー2', 'https://example.com/avatar2.jpg', NOW(), NOW())
ON CONFLICT (email) DO NOTHING;

-- テスト用のサンプルチャンネルを作成
INSERT INTO channels (id, channel_id, name, last_video_id, last_live_scheduled_time, is_live, created_at, updated_at) VALUES
    (uuid_generate_v4(), 'UC-lHJZR3Gqxm24_Vd_AJ5Yw', 'テストチャンネル1', 'video1', NULL, false, NOW(), NOW()),
    (uuid_generate_v4(), 'UC-2', 'テストチャンネル2', 'video2', NOW() + INTERVAL '1 hour', true, NOW(), NOW())
ON CONFLICT (channel_id) DO NOTHING;

-- テスト用のサンプル通知を作成
INSERT INTO notifications (id, user_id, channel_id, channel_name, title, body, type, is_read, created_at) VALUES
    (uuid_generate_v4(), 
     (SELECT id FROM users WHERE email = 'test1@example.com' LIMIT 1),
     (SELECT id FROM channels WHERE channel_id = 'UC-lHJZR3Gqxm24_Vd_AJ5Yw' LIMIT 1),
     'テストチャンネル1', 
     'ライブ配信が予約されました', 
     'テストチャンネル1のライブ配信が予約されました', 
     'scheduled', 
     false, 
     NOW()),
    (uuid_generate_v4(), 
     (SELECT id FROM users WHERE email = 'test2@example.com' LIMIT 1),
     (SELECT id FROM channels WHERE channel_id = 'UC-2' LIMIT 1),
     'テストチャンネル2', 
     'ライブ配信が開始されました', 
     'テストチャンネル2のライブ配信が開始されました', 
     'started', 
     true, 
     NOW() - INTERVAL '1 hour')
ON CONFLICT DO NOTHING;

-- テスト用のサンプルYouTube動画を作成
INSERT INTO youtube_videos (id, video_id, channel_id, title, description, scheduled_start_time, actual_start_time, status, created_at, updated_at) VALUES
    (uuid_generate_v4(), 
     'video1', 
     (SELECT id FROM channels WHERE channel_id = 'UC-lHJZR3Gqxm24_Vd_AJ5Yw' LIMIT 1),
     'テスト動画1', 
     'これはテスト用の動画です', 
     NOW() + INTERVAL '2 hours', 
     NULL, 
     'scheduled', 
     NOW(), 
     NOW()),
    (uuid_generate_v4(), 
     'video2', 
     (SELECT id FROM channels WHERE channel_id = 'UC-2' LIMIT 1),
     'テスト動画2', 
     'これはライブ配信中の動画です', 
     NOW() - INTERVAL '1 hour', 
     NOW() - INTERVAL '1 hour', 
     'live', 
     NOW(), 
     NOW())
ON CONFLICT (video_id) DO NOTHING;

-- テスト用のサンプルFCMトークンを作成
INSERT INTO fcm_tokens (id, user_id, token, created_at, updated_at) VALUES
    (uuid_generate_v4(), 
     (SELECT id FROM users WHERE email = 'test1@example.com' LIMIT 1),
     'test_fcm_token_1', 
     NOW(), 
     NOW()),
    (uuid_generate_v4(), 
     (SELECT id FROM users WHERE email = 'test2@example.com' LIMIT 1),
     'test_fcm_token_2', 
     NOW(), 
     NOW())
ON CONFLICT (user_id, token) DO NOTHING;

-- テスト用のサンプルユーザーチャンネル関連を作成
INSERT INTO user_channels (id, user_id, channel_id, created_at) VALUES
    (uuid_generate_v4(), 
     (SELECT id FROM users WHERE email = 'test1@example.com' LIMIT 1),
     (SELECT id FROM channels WHERE channel_id = 'UC-lHJZR3Gqxm24_Vd_AJ5Yw' LIMIT 1),
     NOW()),
    (uuid_generate_v4(), 
     (SELECT id FROM users WHERE email = 'test2@example.com' LIMIT 1),
     (SELECT id FROM channels WHERE channel_id = 'UC-2' LIMIT 1),
     NOW())
ON CONFLICT (user_id, channel_id) DO NOTHING;

-- テスト用データの確認
SELECT 'Test data initialization completed' as status;
SELECT COUNT(*) as user_count FROM users;
SELECT COUNT(*) as channel_count FROM channels;
SELECT COUNT(*) as notification_count FROM notifications;
