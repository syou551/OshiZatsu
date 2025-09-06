.PHONY: help build run db-up db-down db-logs tidy test

help:
	@echo "make build       # Build backend binary"
	@echo "make run         # Run backend with .env"
	@echo "make db-up       # Start Postgres via docker-compose"
	@echo "make db-down     # Stop Postgres"
	@echo "make db-logs     # Tail Postgres logs"
	@echo "make tidy        # go mod tidy"
	@echo "make test        # Run backend tests"

build:
	cd cmd/server && go build -o ../../bin/oshizatsu-server

run:
	@if [ ! -f ./credential/.env ]; then echo ".env not found. Copy backend/test.env or create .env at ./credential/.env"; exit 1; fi
	@echo "Loading env from ./credential/.env and starting server..."
	env $$(grep -v '^#' ./credential/.env | xargs) go run ./cmd/server

db-up:
	docker compose -f docker-compose.test.yml up -d postgres-test

db-down:
	docker compose -f docker-compose.test.yml down

db-logs:
	docker compose -f docker-compose.test.yml logs -f postgres-test

tidy:
	go mod tidy

test:
	go test ./...
