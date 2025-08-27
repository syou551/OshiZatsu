package test

import (
	"log"
	"os"
	"testing"

	"github.com/joho/godotenv"
)

func TestMain(m *testing.M) {
	// Load test environment variables
	_ = godotenv.Load("../test.env")
	// Ensure fallback auth is used during tests
	os.Setenv("TEST_MODE", "true")

	exit := m.Run()
	if exit != 0 {
		log.Printf("Tests exited with code %d", exit)
	}
	os.Exit(exit)
}
