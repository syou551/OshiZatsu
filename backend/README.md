# 推し雑 バックエンド

推しの雑談配信通知アプリ「推し雑」のバックエンド実装です。

## 機能

- YouTubeチャンネル登録・管理
- ライブ配信の自動検知
- プッシュ通知（FCM）
- ユーザー認証（OIDC）
- gRPC API

## 技術スタック

- Go 1.21+
- gRPC
- PostgreSQL
- Firebase Cloud Messaging
- YouTube Data API v3
- OIDC（syou551.dev）

## セットアップ

### 前提条件

- Go 1.21以上
- PostgreSQL
- YouTube Data API v3 キー
- Firebase プロジェクト
- syou551.dev アカウント

### 1. 依存関係のインストール

```bash
go mod tidy
```

### 2. 環境変数の設定

`env.example`をコピーして`.env`ファイルを作成し、必要な値を設定してください：

```bash
cp env.example .env
```

### 3. データベースのセットアップ

PostgreSQLデータベースを作成し、接続情報を環境変数に設定してください。

### 4. YouTube APIキーの取得

[Google Cloud Console](https://console.cloud.google.com/)でYouTube Data API v3を有効にし、APIキーを取得してください。

### 5. Firebase設定

Firebaseプロジェクトを作成し、サービスアカウントキーをダウンロードして`firebase-config.json`として保存してください。

### 6. サーバーの起動

```bash
go run cmd/server/main.go
```

## API仕様

### 認証サービス

- `Login`: ユーザーログイン
- `Logout`: ユーザーログアウト
- `GetUserInfo`: ユーザー情報取得

### チャンネルサービス

- `SubscribeChannel`: チャンネル登録
- `UnsubscribeChannel`: チャンネル登録解除
- `GetSubscribedChannels`: 登録チャンネル一覧取得

### 通知サービス

- `RegisterFCMToken`: FCMトークン登録
- `UnregisterFCMToken`: FCMトークン削除
- `GetNotifications`: 通知一覧取得

## テスト

```bash
go test ./test/...
```

## アーキテクチャ

```
backend/
├── cmd/
│   └── server/          # メインサーバー
├── internal/
│   ├── auth/           # 認証機能
│   ├── models/         # データモデル
│   ├── notification/   # 通知機能
│   └── youtube/        # YouTube API連携
├── proto/              # gRPCプロトコル定義
└── test/               # テストコード
```

## データベーススキーマ

- `users`: ユーザー情報
- `channels`: YouTubeチャンネル情報
- `user_channels`: ユーザーとチャンネルの関連
- `notifications`: 通知情報
- `fcm_tokens`: FCMトークン管理
- `youtube_videos`: YouTube動画情報

## 定期実行タスク

- YouTube APIチェック: 1時間ごとに新しいライブ配信をチェック

## 開発

### 新しい機能の追加

1. プロトコル定義を`proto/oshizatsu.proto`に追加
2. gRPCコードを生成: `protoc --go_out=. --go_opt=paths=source_relative --go-grpc_out=. --go-grpc_opt=paths=source_relative proto/oshizatsu.proto`
3. 実装を`internal/`に追加
4. テストを`test/`に追加

### デバッグ

ログレベルを環境変数で制御できます：

```bash
export LOG_LEVEL=debug
```

## ライセンス

MIT License
