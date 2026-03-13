---
description: 'Docker best practices covering multi-stage builds, minimal base images, security, health checks, layer caching, and signal handling'
applyTo: '**/Dockerfile, **/Dockerfile.*, **/*.dockerfile, **/docker-compose*.yml, **/docker-compose*.yaml'
---

# Docker Best Practices

## Multi-Stage Builds

Separate build dependencies from runtime to minimize image size and attack surface.

```dockerfile
# Stage 1: Build
FROM maven:3.9-eclipse-temurin-21 AS build
WORKDIR /app
COPY pom.xml .
RUN mvn dependency:go-offline -B
COPY src/ src/
RUN mvn package -DskipTests -B

# Stage 2: Runtime
FROM eclipse-temurin:21-jre-alpine AS runtime
WORKDIR /app
COPY --from=build /app/target/app.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
```

For Node.js:

```dockerfile
FROM node:20-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm ci --production=false
COPY . .
RUN npm run build

FROM node:20-alpine AS runtime
WORKDIR /app
COPY --from=build /app/dist ./dist
COPY --from=build /app/node_modules ./node_modules
COPY package*.json ./
EXPOSE 3000
CMD ["node", "dist/index.js"]
```

## Minimal Base Images

- Prefer `-alpine` or `-slim` variants
- Use `scratch` for statically linked Go binaries
- Pin image versions with SHA digests for reproducibility in production

```dockerfile
# ✅ GOOD — pinned and minimal
FROM python:3.12-slim

# ❌ BAD — unpinned, full image
FROM python:latest
```

## .dockerignore

Always include a `.dockerignore` to exclude unnecessary files from the build context:

```
.git
.gitignore
node_modules
*.md
.env
.env.*
test/
tests/
coverage/
.vscode/
.idea/
__pycache__/
*.pyc
```

## Non-Root User

Never run containers as root. Create a dedicated user:

```dockerfile
RUN addgroup --system appgroup && adduser --system --ingroup appgroup appuser
USER appuser
```

For Alpine:

```dockerfile
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser
```

## Health Checks

Define health checks so orchestrators can verify container readiness:

```dockerfile
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
  CMD curl -f http://localhost:8080/health || exit 1
```

For containers without curl:

```dockerfile
HEALTHCHECK --interval=30s --timeout=5s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:8080/health || exit 1
```

## Layer Caching

Order instructions from least-changing to most-changing:

```dockerfile
# 1. Base image (rarely changes)
FROM node:20-alpine

# 2. System dependencies (rarely changes)
RUN apk add --no-cache curl

# 3. Application dependencies (changes when deps update)
WORKDIR /app
COPY package*.json ./
RUN npm ci --production

# 4. Application code (changes frequently)
COPY . .
```

- Copy dependency manifests before source code to maximize cache hits
- Use `--mount=type=cache` for build tool caches (BuildKit):

```dockerfile
RUN --mount=type=cache,target=/root/.m2 mvn package -DskipTests -B
```

## Signal Handling

Use `exec` form for `ENTRYPOINT` and `CMD` so signals (SIGTERM) reach the application:

```dockerfile
# ✅ GOOD — exec form, PID 1 receives signals
ENTRYPOINT ["java", "-jar", "app.jar"]

# ❌ BAD — shell form, shell is PID 1
ENTRYPOINT java -jar app.jar
```

For applications that need graceful shutdown:

```dockerfile
STOPSIGNAL SIGTERM
```

If wrapping with a shell script, use `exec`:

```bash
#!/bin/sh
exec java -jar /app/app.jar "$@"
```

## Security Scanning

- Scan images in CI before pushing to registry
- Use tools like Trivy, Grype, or Docker Scout

```yaml
# ADO pipeline step
- script: |
    trivy image --exit-code 1 --severity HIGH,CRITICAL myapp:latest
  displayName: 'Scan Container Image'
```

## Docker Compose Best Practices

```yaml
services:
  api:
    build:
      context: .
      dockerfile: Dockerfile
      target: runtime
    ports:
      - "8080:8080"
    environment:
      - DB_HOST=db
    depends_on:
      db:
        condition: service_healthy
    restart: unless-stopped
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:8080/health"]
      interval: 30s
      timeout: 5s
      retries: 3

  db:
    image: postgres:16-alpine
    environment:
      POSTGRES_DB: appdb
      POSTGRES_USER: app
      POSTGRES_PASSWORD_FILE: /run/secrets/db_password
    volumes:
      - db-data:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U app"]
      interval: 10s
      timeout: 5s
      retries: 5

volumes:
  db-data:
```

## Additional Guidelines

- One process per container
- Use `.env` files for local development, never commit them
- Set resource limits (`mem_limit`, `cpus`) in compose for local parity
- Tag images with commit SHA and semantic version, not just `latest`
- Log to stdout/stderr — let the orchestrator handle log routing
