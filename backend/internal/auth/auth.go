package auth

import (
	"context"
	"crypto/rand"
	"encoding/hex"
	"fmt"
	"os"

	"oshizatsu-backend/internal/models"
)

// AuthService 認証サービス（簡略化版）
type AuthService struct {
	db *models.Database
}

// NewAuthService 新しい認証サービスを作成
func NewAuthService(db *models.Database) (*AuthService, error) {
	return &AuthService{
		db: db,
	}, nil
}

// GenerateToken トークンを生成
func (a *AuthService) GenerateToken(userID string) (string, error) {
	// 簡略化のため、ランダムなトークンを生成
	token := make([]byte, 32)
	if _, err := rand.Read(token); err != nil {
		return "", fmt.Errorf("failed to generate token: %v", err)
	}
	return hex.EncodeToString(token), nil
}

// ValidateToken トークンを検証（簡略化版）
func (a *AuthService) ValidateToken(ctx context.Context, accessToken string) (*models.User, error) {
	// 簡略化のため、トークンからユーザーIDを直接取得する想定
	// 実際の実装では、JWTトークンの検証を行う
	userID := accessToken // 簡略化のため、トークンをユーザーIDとして扱う

	// データベースからユーザー情報を取得
	user, err := a.getUserByID(userID)
	if err != nil {
		return nil, fmt.Errorf("user not found: %v", err)
	}

	return user, nil
}

// CreateUser ユーザーを作成
func (a *AuthService) CreateUser(email, name, picture string) (*models.User, error) {
	user := models.NewUser(email, name, picture)

	if err := a.createUser(user); err != nil {
		return nil, fmt.Errorf("failed to create user: %v", err)
	}

	return user, nil
}

// getUserByEmail メールアドレスでユーザーを取得
func (a *AuthService) getUserByEmail(email string) (*models.User, error) {
	query := `SELECT id, email, name, picture, created_at, updated_at FROM users WHERE email = $1`

	var user models.User
	err := a.db.QueryRow(query, email).Scan(
		&user.ID, &user.Email, &user.Name, &user.Picture,
		&user.CreatedAt, &user.UpdatedAt,
	)

	if err != nil {
		return nil, err
	}

	return &user, nil
}

// getUserByID IDでユーザーを取得
func (a *AuthService) getUserByID(id string) (*models.User, error) {
	query := `SELECT id, email, name, picture, created_at, updated_at FROM users WHERE id = $1`

	var user models.User
	err := a.db.QueryRow(query, id).Scan(
		&user.ID, &user.Email, &user.Name, &user.Picture,
		&user.CreatedAt, &user.UpdatedAt,
	)

	if err != nil {
		return nil, err
	}

	return &user, nil
}

// createUser ユーザーを作成
func (a *AuthService) createUser(user *models.User) error {
	query := `INSERT INTO users (id, email, name, picture, created_at, updated_at) VALUES ($1, $2, $3, $4, $5, $6)`

	_, err := a.db.Exec(query, user.ID, user.Email, user.Name, user.Picture, user.CreatedAt, user.UpdatedAt)
	return err
}

// updateUser ユーザーを更新
func (a *AuthService) updateUser(user *models.User) error {
	query := `UPDATE users SET name = $1, picture = $2, updated_at = $3 WHERE id = $4`

	_, err := a.db.Exec(query, user.Name, user.Picture, user.UpdatedAt, user.ID)
	return err
}

// getEnv 環境変数を取得（デフォルト値付き）
func getEnv(key, defaultValue string) string {
	if value := os.Getenv(key); value != "" {
		return value
	}
	return defaultValue
}
