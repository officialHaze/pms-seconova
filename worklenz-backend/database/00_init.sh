#!/bin/bash
set -e

echo "Starting database initialization..."

SCRIPT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# SQL_DIR="/docker-entrypoint-initdb.d/sql"
SQL_DIR="$SCRIPT_ROOT/sql"
# MIGRATIONS_DIR="/docker-entrypoint-initdb.d/migrations"
MIGRATIONS_DIR="$SCRIPT_ROOT/sql/migrations"
# BACKUP_DIR="/docker-entrypoint-initdb.d/pg_backups"
BACKUP_DIR=""
ENV_FILE="$SCRIPT_ROOT/../.env"

# Load .env file
# Check if the file exists before loading
if [ -f "$ENV_FILE" ]; then
  # Automatically export all variables declared inside the sourced file
  set -a
  source "$ENV_FILE"
  set +a
  echo "✅ Successfully loaded environment from: $ENV_FILE"
else
  echo "❌ ERROR: Environment file not found at '$ENV_FILE'"
  exit 1
fi

# Set pg password once to use in every sql exec
export PGPASSWORD="${DB_PASSWORD}"

# --------------------------------------------
# 🗄️ STEP 1: Attempt to restore latest backup
# --------------------------------------------

if [ -d "$BACKUP_DIR" ]; then
  LATEST_BACKUP=$(ls -t "$BACKUP_DIR"/*.sql 2>/dev/null | head -n 1)
else
  LATEST_BACKUP=""
fi

if [ -f "$LATEST_BACKUP" ]; then
  echo "🗄️ Found latest backup: $LATEST_BACKUP"
  echo "⏳ Restoring from backup..."
  psql -h "$MIGRATION_DB_HOST" -U "$POSTGRES_USER" -d "$POSTGRES_DB" <"$LATEST_BACKUP"
  echo "✅ Backup restoration complete. Skipping schema and migrations."
  exit 0
else
  echo "ℹ️ No valid backup found. Proceeding with base schema and migrations."
fi

# --------------------------------------------
# 🏗️ STEP 2: Continue with base schema setup
# --------------------------------------------

# Set pg password once to use in every sql exec
# export PGPASSWORD="${DB_PASSWORD}"

# Create migrations table if it doesn't exist
psql -h "$MIGRATION_DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" -c "
  CREATE TABLE IF NOT EXISTS schema_migrations (
    version TEXT PRIMARY KEY,
    applied_at TIMESTAMP DEFAULT now()
  );
"

# List of base schema files to execute in order
BASE_SQL_FILES=(
  "0_extensions.sql"
  "1_tables.sql"
  "indexes.sql"
  "4_functions.sql"
  "triggers.sql"
  "3_views.sql"
  "2_dml.sql"
  "5_database_user.sql"
  "6_org_wk_days_table.sql"
  "7_functions.sql"
  "8_functions.sql"
)

echo "Running base schema SQL files in order..."

for file in "${BASE_SQL_FILES[@]}"; do
  full_path="$SQL_DIR/$file"
  if [ -f "$full_path" ]; then
    echo "Executing $file..."
    psql -h "$MIGRATION_DB_HOST" -p "$DB_PORT" -U "$DB_USER" -w -d "$DB_NAME" -f "$full_path"
  else
    echo "WARNING: $file not found, skipping."
  fi
done

echo "✅ Base schema SQL execution complete."

# --------------------------------------------
# 🚀 STEP 3: Apply SQL migrations
# --------------------------------------------

if [ -d "$MIGRATIONS_DIR" ] && compgen -G "$MIGRATIONS_DIR/*.sql" >/dev/null; then
  echo "Applying migrations..."
  for f in "$MIGRATIONS_DIR"/*.sql; do
    version=$(basename "$f")
    if ! psql -h "$MIGRATION_DB_HOST" -p $DB_PORT -U "$DB_USER" -d "$DB_NAME" -tAc "SELECT 1 FROM schema_migrations WHERE version = '$version'" | grep -q 1; then
      echo "Applying migration: $version"
      psql -h "$MIGRATION_DB_HOST" -p $DB_PORT -U "$DB_USER" -d "$DB_NAME" -f "$f"
      psql -h "$MIGRATION_DB_HOST" -p $DB_PORT -U "$DB_USER" -d "$DB_NAME" -c "INSERT INTO schema_migrations (version) VALUES ('$version');"
    else
      echo "Skipping already applied migration: $version"
    fi
  done
else
  echo "No migration files found or directory is empty, skipping migrations."
fi

echo "🎉 Database initialization completed successfully."
