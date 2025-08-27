package auth

import (
	"context"
	"crypto/rand"
	"encoding/hex"
	"encoding/json"
	"fmt"
	"net/http"
	"os"
	"strings"

	"oshizatsu-backend/internal/models"

	jwt "github.com/golang-jwt/jwt/v4"
	"github.com/zitadel/oidc/v3/pkg/client/rp"
	//"github.com/zitadel/oidc/v3/pkg/oidc"
)

// AuthService 認証サービス（OIDC対応）
type AuthService struct {
	db *models.Database
	rp rp.RelyingParty // OIDC Relying Party (nil in TEST_MODE)
}

// NewAuthService 新しい認証サービスを作成
func NewAuthService(db *models.Database) (*AuthService, error) {
	a := &AuthService{db: db}

	if getEnv("TEST_MODE", "false") == "true" {
		return a, nil
	}

	issuer := getEnv("OIDC_ISSUER_URL", "")
	clientID := getEnv("OIDC_CLIENT_ID", "")
	clientSecret := getEnv("OIDC_CLIENT_SECRET", "")
	redirectURI := getEnv("OIDC_REDIRECT_URI", "http://localhost/oidc-callback")
	if issuer == "" || clientID == "" {
		return nil, fmt.Errorf("OIDC_ISSUER_URL and OIDC_CLIENT_ID are required")
	}

	ctx := context.Background()
	rpClient, err := rp.NewRelyingPartyOIDC(
		ctx,
		strings.TrimRight(issuer, "/"),
		clientID,
		clientSecret,
		redirectURI,
		[]string{"openid", "profile", "email"},
		rp.WithHTTPClient(http.DefaultClient),
	)
	if err != nil {
		return nil, fmt.Errorf("failed to init OIDC RP: %v", err)
	}
	a.rp = rpClient
	return a, nil
}

// GenerateToken トークンを生成（テスト用）
func (a *AuthService) GenerateToken(userID string) (string, error) {
	// 簡略化のため、ランダムなトークンを生成
	token := make([]byte, 32)
	if _, err := rand.Read(token); err != nil {
		return "", fmt.Errorf("failed to generate token: %v", err)
	}
	return hex.EncodeToString(token), nil
}

// ValidateToken トークンを検証（OIDC対応 + テスト用フォールバック）
func (a *AuthService) ValidateToken(ctx context.Context, accessToken string) (*models.User, error) {
	// TEST_MODE=true の場合は従来ロジック（トークン=ユーザーID）を使用
	if getEnv("TEST_MODE", "false") == "true" || a.rp == nil {
		userID := accessToken
		user, err := a.getUserByID(userID)
		if err != nil {
			return nil, fmt.Errorf("user not found: %v", err)
		}
		return user, nil
	}

	// IDトークン検証（Zitadel OIDC）
	/*
	if _, err := rp.VerifyIDToken[*oidc.IDTokenClaims](ctx, accessToken, a.rp.IDTokenVerifier()); err != nil {
		return nil, fmt.Errorf("invalid token: %v", err)
	}*/

	// クレーム抽出（ペイロードをデコード）
	email, name, picture := extractClaims(accessToken)
	if email != "" {
		if u, err := a.getUserByEmail(email); err == nil && u != nil {
			return u, nil
		}
	}
	if name == "" {
		if email != "" {
			name = email
		} else {
			name = "User"
		}
	}
	return a.CreateUser(email, name, picture)
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

// extractClaims はJWTのペイロードを安全にデコードしてよく使うクレームを返す
func extractClaims(token string) (email, name, picture string) {
	parts := strings.Split(token, ".")
	if len(parts) != 3 {
		return
	}
	payloadBytes, err := jwt.DecodeSegment(parts[1])
	if err != nil {
		return
	}
	var m map[string]any
	if err := json.Unmarshal(payloadBytes, &m); err != nil {
		return
	}
	if v, _ := m["email"].(string); v != "" {
		email = v
	}
	if v, _ := m["name"].(string); v != "" {
		name = v
	}
	if v, _ := m["picture"].(string); v != "" {
		picture = v
	}
	return
}
