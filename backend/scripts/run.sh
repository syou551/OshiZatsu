#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

if [ ! -f .env ]; then
  echo ".env not found. Create one (see .env.example or test.env)."
  exit 1
fi

export $(grep -v '^#' .env | xargs)

go run ./cmd/server
