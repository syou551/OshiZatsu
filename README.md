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

## クイックスタート

### 1. データベースの起動
```bash
cd backend
make db-up
```

### 2. バックエンドの起動
```bash
cd backend
cp test.env credential/.env
make run
```

### 3. フロントエンドの起動
```bash
cd frontend
flutter pub get
flutter run
```

## セットアップ

### 前提条件

- Go 1.21以上
- Flutter 3.0以上
- Docker & Docker Compose
- Firebase プロジェクト
- YouTube Data API v3 キー
- syou551.dev アカウント

### データベース（PostgreSQL）

プロジェクトではDocker Composeを使用してPostgreSQLを起動します。

1. データベースの起動
```bash
cd backend
make db-up
```

2. データベースの停止
```bash
make db-down
```

3. データベースのログ確認
```bash
make db-logs
```

**接続情報:**
- Host: localhost
- Port: 5432
- Test Database: oshizatsu_test
- Prod Database: oshizatsu
- Username: postgres
- Password: password
- pgAdmin: http://localhost:8081 (admin@test.com / admin)

### バックエンド

1. 依存関係のインストール
```bash
cd backend
make tidy
```

2. 環境変数の設定
```bash
# テスト用環境変数を使用する場合
cp test.env credential/.env

# または、本番用の環境変数ファイルを作成
# credential/.env ファイルを作成し、必要な値を設定
```

**必要な環境変数:**
- `DB_HOST` - データベースホスト（デフォルト: localhost）
- `DB_PORT` - データベースポート（デフォルト: 5432）
- `DB_USER` - データベースユーザー名（デフォルト: postgres）
- `DB_PASSWORD` - データベースパスワード（デフォルト: password）
- `DB_NAME` - データベース名（テスト用: oshizatsu_test、本番用: oshizatsu）
- `GRPC_PORT` - gRPCサーバーポート（デフォルト: 50052）
- `YOUTUBE_API_KEY` - YouTube Data API v3キー
- `FIREBASE_CONFIG_PATH` - Firebase設定ファイルのパス
- `OIDC_ISSUER_URL` - OIDCプロバイダーのURL
- `OIDC_CLIENT_ID` - OIDCクライアントID
- `OIDC_CLIENT_SECRET` - OIDCクライアントシークレット

3. サーバーのビルド
```bash
make build
```

4. サーバーの起動
```bash
make run
```

**利用可能なMakeコマンド:**
- `make help` - 利用可能なコマンドを表示
- `make build` - バックエンドバイナリをビルド
- `make run` - .envファイルを使用してバックエンドを起動
- `make db-up` - Docker ComposeでPostgreSQLを起動
- `make db-down` - PostgreSQLを停止
- `make db-logs` - PostgreSQLのログを表示
- `make tidy` - go mod tidyを実行
- `make test` - バックエンドテストを実行

### フロントエンド

1. 依存関係のインストール
```bash
cd frontend
flutter pub get
```

2. Firebase設定
- Firebaseプロジェクトを作成
- Android/iOSアプリを追加
- 設定ファイルをダウンロード：
  - Android: `google-services.json` を `android/app/` に配置
  - iOS: `GoogleService-Info.plist` を `ios/Runner/` に配置

3. アプリの実行
```bash
# Android
flutter run

# iOS
flutter run -d ios

# 特定のデバイスで実行
flutter devices
flutter run -d <device_id>
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

### テスト用環境

テスト用のPostgreSQLコンテナを管理するための専用Makefileが用意されています。

```bash
cd backend
make -f Makefile.test help
```

**テスト用Makeコマンド:**
- `make -f Makefile.test start` - テスト用PostgreSQLコンテナを起動
- `make -f Makefile.test stop` - テスト用PostgreSQLコンテナを停止
- `make -f Makefile.test restart` - テスト用PostgreSQLコンテナを再起動
- `make -f Makefile.test clean` - テスト用コンテナとボリュームを削除
- `make -f Makefile.test test-db` - データベース接続テスト
- `make -f Makefile.test test-integration` - 統合テストを実行
- `make -f Makefile.test logs` - コンテナのログを表示
- `make -f Makefile.test db-connect` - oshizatsu_testデータベースに接続
- `make -f Makefile.test db-connect-prod` - oshizatsuデータベースに接続
- `make -f Makefile.test db-status` - データベースの状態を確認

### テスト

```bash
# バックエンド
cd backend
make test

# または個別のテスト
go test ./test/...

# フロントエンド
cd frontend
flutter test
```

### ビルド

```bash
# バックエンド
cd backend
make build

# フロントエンド
cd frontend
flutter build apk
flutter build ios
```

### 開発用スクリプト

```bash
# バックエンドの起動スクリプト
cd backend
./scripts/run.sh
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
