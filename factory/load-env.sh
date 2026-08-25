#!/bin/bash
# Loads environment variables into $GITHUB_ENV
set -e

ENV_FILE=".env"

# Ensure file exists
if [ ! -f "$ENV_FILE" ]; then
  echo "$ENV_FILE not found"
  exit 1
fi

# Export everything temporarily to resolve dependencies
set -a
source "$ENV_FILE"
set +a

# Parse and output resolved env vars to $GITHUB_ENV
while IFS='=' read -r key val; do
  # Skip comments and empty lines
  [[ "$key" =~ ^[[:space:]]*# ]] && continue
  [[ -z "$key" || -z "$val" ]] && continue

  # Strip quotes if present
  val="${!key}"  # Resolve the value from the environment
  echo "$key=$val" >> "$GITHUB_ENV"
done < <(grep -v '^\s*#' "$ENV_FILE" | grep -v '^\s*$')
