#!/bin/bash

# BuildKitを使用してDockerイメージをビルドし、OTelテレメトリを収集

echo "Starting BuildKit and Jaeger..."
docker-compose up -d

echo "Waiting for services to be ready..."
sleep 5

echo "Building Docker image with BuildKit..."
buildctl \
  --addr tcp://localhost:1234 \
  build \
  --frontend dockerfile.v0 \
  --local context=. \
  --local dockerfile=. \
  --output type=image,name=myapp:latest,push=false \
  --opt build-arg:BUILDKIT_INLINE_CACHE=1 \
  --progress=plain

echo "Build complete!"
echo "View traces at: http://localhost:16686"
echo ""
echo "To stop services: docker-compose down"