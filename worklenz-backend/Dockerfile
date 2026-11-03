# --- Stage 1: Build ---
FROM node:22-slim AS builder

ARG RELEASE_VERSION
RUN apt-get update && apt-get install -y \
    python3 \
    make \
    g++ \
    curl \
    postgresql-server-dev-all \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /backend

COPY package*.json ./
RUN npm ci

COPY . .
RUN npm run build

RUN echo "$RELEASE_VERSION" > release

# --- Stage 2: Production Image ---
FROM node:22-slim

RUN apt-get update && apt-get install -y libpq5 && rm -rf /var/lib/apt/lists/*

WORKDIR /backend

COPY --from=builder /backend/package*.json ./
COPY --from=builder /backend/build ./build
COPY --from=builder /backend/node_modules ./node_modules
COPY --from=builder /backend/release ./release
COPY --from=builder /backend/worklenz-email-templates ./worklenz-email-templates
COPY --from=builder /backend/scripts/migrate.js ./scripts/migrate.js
COPY --from=builder /backend/scripts/migrate-bootstrap.js ./scripts/migrate-bootstrap.js
COPY --from=builder /backend/database/pg-migrations ./database/pg-migrations

RUN groupadd -r appgroup && useradd -r -g appgroup appuser

# Give USER and GROUP appropriate perms
RUN mkdir -p /var/log && chown -R appuser:appgroup /var/log
RUN chown -R appuser:appgroup /backend

EXPOSE 3000

# Switch to non-root user
USER appuser

CMD ["node", "build/bin/www"]
