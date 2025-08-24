# 推し雑 フロントエンド

推しの雑談配信通知アプリ「推し雑」のFlutterフロントエンド実装です。

## 機能

- ユーザー認証（ログイン・ログアウト）
- YouTubeチャンネル登録・管理
- ライブ配信通知の表示・管理
- プッシュ通知（FCM）
- 設定管理

## 技術スタック

- Flutter 3.0+
- Dart 3.0+
- Riverpod（状態管理）
- Go Router（ナビゲーション）
- Firebase Cloud Messaging
- gRPC（バックエンド通信）

## セットアップ

### 前提条件

- Flutter 3.0以上
- Dart 3.0以上
- Android Studio / VS Code
- Firebase プロジェクト

### 1. 依存関係のインストール

```bash
flutter pub get
```

### 2. Firebase設定

1. Firebaseプロジェクトを作成
2. Android/iOSアプリを追加
3. 設定ファイルをダウンロード：
   - Android: `google-services.json` を `android/app/` に配置
   - iOS: `GoogleService-Info.plist` を `ios/Runner/` に配置

### 3. アプリの実行

```bash
# Android
flutter run

# iOS
flutter run -d ios
```

## アプリ構造

```
lib/
├── app.dart                    # アプリのメイン構造
├── main.dart                   # エントリーポイント
├── core/
│   ├── theme/                  # テーマ定義
│   └── services/               # 共通サービス
├── features/
│   ├── auth/                   # 認証機能
│   ├── channels/               # チャンネル管理
│   ├── notifications/          # 通知管理
│   └── settings/               # 設定
└── generated/                  # gRPC生成コード
```

## 画面構成

### 認証画面
- ログインページ
- メールアドレス・パスワード認証
- OIDC認証（syou551.dev）

### メイン画面
- チャンネル一覧
- 通知一覧
- 設定画面

### チャンネル管理
- チャンネル登録
- チャンネル削除
- ライブ配信状況表示

### 通知管理
- 通知一覧表示
- 既読・未読管理
- 通知削除

### 設定
- 通知設定
- アプリ設定
- アカウント設定
- データ管理

## 開発

### 新しい機能の追加

1. 機能ディレクトリを作成: `lib/features/feature_name/`
2. プレゼンテーション層を実装: `presentation/`
3. ドメイン層を実装: `domain/`
4. データ層を実装: `data/`

### テスト

```bash
# ユニットテスト
flutter test

# ウィジェットテスト
flutter test test/widget_test.dart
```

### ビルド

```bash
# Android APK
flutter build apk

# Android App Bundle
flutter build appbundle

# iOS
flutter build ios
```

## 設定

### 環境変数

- `GRPC_SERVER_URL`: gRPCサーバーのURL
- `FIREBASE_PROJECT_ID`: FirebaseプロジェクトID

### 通知設定

- フォアグラウンド通知
- バックグラウンド通知
- ローカル通知

## デザイン

### カラーテーマ

- プライマリカラー: ピンク系（推しの色）
- セカンダリカラー: ブルー系
- 背景色: ライトグレー
- テキスト色: ダークグレー

### アイコン

- Material Design Icons
- カスタムアイコン（アプリアイコン）

## ライセンス

MIT License
