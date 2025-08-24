# 推し雑（OshiZatsu）

推しの雑談配信通知アプリ「推し雑」の実装です。

## 概要

推しのYouTubeチャンネルを登録しておくと、推しの「雑談」配信が予約されたときと開始されたときに通知を受け取れるアプリです。

## 機能

- YouTubeチャンネル登録・管理（各アカウント5つまで）
- ライブ配信の自動検知（1時間ごと）
- プッシュ通知（FCM）
- ユーザー認証（OIDC）
- 通知履歴管理

## 技術スタック

### バックエンド
- Go 1.21+
- gRPC
- PostgreSQL
- Firebase Cloud Messaging
- YouTube Data API v3
- OIDC（syou551.dev）

### フロントエンド
- Flutter 3.0+
- Dart 3.0+
- Riverpod（状態管理）
- Go Router（ナビゲーション）
- Firebase Cloud Messaging

## プロジェクト構造

```
OshiZatsu/
├── backend/                    # Goバックエンド
│   ├── cmd/server/            # メインサーバー
│   ├── internal/              # 内部パッケージ
│   │   ├── auth/             # 認証機能
│   │   ├── models/           # データモデル
│   │   ├── notification/     # 通知機能
│   │   └── youtube/          # YouTube API連携
│   ├── proto/                # gRPCプロトコル定義
│   └── test/                 # テストコード
├── frontend/                  # Flutterフロントエンド
│   ├── lib/                  # Dartソースコード
│   │   ├── core/             # 共通機能
│   │   ├── features/         # 機能別モジュール
│   │   └── generated/        # gRPC生成コード
│   ├── android/              # Android設定
│   └── ios/                  # iOS設定
└── docs/                     # ドキュメント
```

## セットアップ

### 前提条件

- Go 1.21以上
- Flutter 3.0以上
- PostgreSQL
- Firebase プロジェクト
- YouTube Data API v3 キー
- syou551.dev アカウント

### バックエンド

1. データベースのセットアップ
```bash
cd backend
# PostgreSQLデータベースを作成
createdb oshizatsu
```

2. 環境変数の設定
```bash
cp env.example .env
# .envファイルを編集して必要な値を設定
```

3. 依存関係のインストール
```bash
go mod tidy
```

4. サーバーの起動
```bash
go run cmd/server/main.go
```

### フロントエンド

1. 依存関係のインストール
```bash
cd frontend
flutter pub get
```

2. Firebase設定
- Firebaseプロジェクトを作成
- Android/iOSアプリを追加
- 設定ファイルをダウンロード

3. アプリの実行
```bash
flutter run
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

### テスト

```bash
# バックエンド
cd backend
go test ./test/...

# フロントエンド
cd frontend
flutter test
```

### ビルド

```bash
# バックエンド
cd backend
go build -o bin/server cmd/server/main.go

# フロントエンド
cd frontend
flutter build apk
flutter build ios
```

## デプロイ

### バックエンド
- Docker化対応予定
- Kubernetes対応予定

### フロントエンド
- Google Play Store
- Apple App Store

## ライセンス

MIT License

## 貢献

1. このリポジトリをフォーク
2. 機能ブランチを作成
3. 変更をコミット
4. プルリクエストを作成

## 作者

推し雑開発チーム
