# テスト用PostgreSQL環境

このディレクトリには、バックエンドのテスト用PostgreSQL環境が含まれています。

## 概要

- **PostgreSQL 15**: Alpine Linuxベースの軽量コンテナ
- **pgAdmin 4**: データベース管理ツール（オプション）
- **oshizatsu_test**: テスト用データベース（サンプルデータ付き）
- **oshizatsu**: 本番用データベース（空のスキーマのみ）
- **自動初期化**: コンテナ起動時に両データベースのスキーマが自動作成

## ファイル構成

```
backend/
├── docker-compose.test.yml    # テスト用Docker Compose設定
├── init-test-db.sql          # oshizatsu_test初期化スクリプト
├── init-oshizatsu-db.sql     # oshizatsu初期化スクリプト
├── test.env                  # テスト用環境変数
├── Makefile.test             # テスト用Makefile
└── README.test.md           # このファイル
```

## クイックスタート

### 1. テスト用PostgreSQLコンテナを起動

```bash
# Makefileを使用
make -f Makefile.test start

# または直接Docker Composeを使用
docker-compose -f docker-compose.test.yml up -d
```

### 2. データベース接続を確認

```bash
# 接続テスト
make -f Makefile.test test-db

# データベース状態確認
make -f Makefile.test db-status
```

### 3. テストを実行

```bash
# 統合テスト実行
make -f Makefile.test test-integration

# または個別のテスト
export $(cat test.env | xargs) && go test -v ./test/...
```

## 接続情報

### PostgreSQL
- **Host**: localhost
- **Port**: 5432
- **Test Database**: oshizatsu_test
- **Prod Database**: oshizatsu
- **Username**: postgres
- **Password**: password

### pgAdmin（オプション）
- **URL**: http://localhost:8081
- **Email**: admin@test.com
- **Password**: admin

## 利用可能なコマンド

### Makefileコマンド

```bash
# ヘルプ表示
make -f Makefile.test help

# コンテナ起動
make -f Makefile.test start

# コンテナ停止
make -f Makefile.test stop

# コンテナ再起動
make -f Makefile.test restart

# クリーンアップ（コンテナとボリューム削除）
make -f Makefile.test clean

# データベース接続テスト
make -f Makefile.test test-db

# データベース状態確認
make -f Makefile.test db-status

# 統合テスト実行
make -f Makefile.test test-integration

# ログ表示
make -f Makefile.test logs

# データベースに直接接続
make -f Makefile.test db-connect

# oshizatsuデータベースに直接接続
make -f Makefile.test db-connect-prod

# データベース状態確認
make -f Makefile.test db-status
```

### Docker Composeコマンド

```bash
# コンテナ起動
docker-compose -f docker-compose.test.yml up -d

# コンテナ停止
docker-compose -f docker-compose.test.yml down

# ログ表示
docker-compose -f docker-compose.test.yml logs -f

# コンテナとボリューム削除
docker-compose -f docker-compose.test.yml down -v
```

## データベース構成

### oshizatsu_test（テスト用データベース）

初期化スクリプト（`init-test-db.sql`）により、以下のテストデータが自動作成されます：

### ユーザー
- test1@example.com / テストユーザー1
- test2@example.com / テストユーザー2

### チャンネル
- UC-lHJZR3Gqxm24_Vd_AJ5Yw / テストチャンネル1
- UC-2 / テストチャンネル2（ライブ配信中）

### 通知
- 予約配信通知（未読）
- 開始配信通知（既読）

### YouTube動画
- テスト動画1（予約配信）
- テスト動画2（ライブ配信中）

### FCMトークン
- test_fcm_token_1
- test_fcm_token_2

### oshizatsu（本番用データベース）

初期化スクリプト（`init-oshizatsu-db.sql`）により、スキーマのみが作成されます：
- テーブル: 6個（users, channels, notifications, fcm_tokens, user_channels, youtube_videos）
- インデックス: 9個
- データ: 空（テストデータなし）

## 環境変数

テスト実行時は `test.env` ファイルの環境変数が使用されます：

```bash
# テスト用環境変数を読み込み
export $(cat test.env | xargs)

# テスト実行
go test -v ./test/...
```

## トラブルシューティング

### ポートが既に使用されている場合

```bash
# 使用中のポートを確認
lsof -i :5432
lsof -i :8081

# 既存のコンテナを停止
docker-compose -f docker-compose.test.yml down
```

### データベース接続エラー

```bash
# コンテナの状態確認
docker ps

# ログ確認
make -f Makefile.test logs

# コンテナ再起動
make -f Makefile.test restart
```

### テストデータが正しく作成されていない場合

```bash
# コンテナとボリュームを削除
make -f Makefile.test clean

# 再起動
make -f Makefile.test start

# データ確認
make -f Makefile.test db-status
```

## 開発時の注意点

1. **ポート番号**: 本番環境（5432）とテスト環境（5433）で異なるポートを使用
2. **データベース名**: テスト用データベース（oshizatsu_test）を使用
3. **データ分離**: テストデータは本番データと完全に分離
4. **自動クリーンアップ**: テスト終了後は `make -f Makefile.test clean` でクリーンアップ

## 本番環境との違い

| 項目 | テスト環境 | 本番環境 |
|------|------------|----------|
| ポート | 5432 | 5432 |
| データベース名 | oshizatsu_test | oshizatsu |
| データ永続化 | ボリューム | 永続化 |
| 初期データ | サンプルデータ | 空 |
| ログレベル | debug | info |
