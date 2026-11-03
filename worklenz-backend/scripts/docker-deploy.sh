#!/usr/bin/env bash

# Deploy a simple build of the backend in docker (npm run build)

set -euo pipefail

SCRIPT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_ROOT}/.." && pwd)"
PROJECT_ROOT="$(cd "${REPO_ROOT}/.." && pwd)"

# ── 1. Load .env ──────────────────────────────────────────────────────────────
ENV_FILE_NAME=".env.docker"

ENV_FILE="${REPO_ROOT}/${ENV_FILE_NAME}"

if [[ ! -f "${ENV_FILE}" ]]; then
  echo "ERROR: env file '${ENV_FILE_NAME}' not found in project root" >&2
  exit 1
fi

echo "→ Loading '${ENV_FILE_NAME}' ..."
set -a
# shellcheck source=/dev/null
source "${ENV_FILE}"
set +a

if [[ -z "${TAG:-}" ]]; then
  echo "ERROR: TAG is not set in ${ENV_FILE_NAME}" >&2
  exit 1
fi

if [[ -z "${USERNAME:-}" ]]; then
  echo "ERROR: USERNAME is not set in ${ENV_FILE_NAME}" >&2
  exit 1
fi

CONTAINER_NAME="pms-seconova-backend"

# ── 2. Docker build ───────────────────────────────────────────────────────────
echo "🔨 Building image with tag: ${TAG}"
docker build \
  -t "${USERNAME}/${CONTAINER_NAME}:${TAG}" \
  -f "${REPO_ROOT}/Dockerfile" \
  "${REPO_ROOT}"

echo "✅ Done! Image built: ${USERNAME}/${CONTAINER_NAME}:${TAG}"

# ── 3. Docker deploy ───────────────────────────────────────────────────────────
echo "📤 Pushing image to docker hub..."

docker push ${USERNAME}/${CONTAINER_NAME}:${TAG}

echo "✅ Done! Image pushed to docker hub"
