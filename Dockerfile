# マルチステージビルドの例
# 各ステージの実行時間を測定するために意図的に処理を追加

# ステージ1: ベースイメージのセットアップ
FROM alpine:3.19 AS base
LABEL stage="base-setup"
LABEL description="Installing base system dependencies"
RUN apk add --no-cache \
    curl \
    jq \
    git && \
    sleep 2  # 意図的な遅延でステージを識別しやすくする

# ステージ2: 依存関係のインストール
FROM base AS dependencies
LABEL stage="dependencies-install"
LABEL description="Installing application dependencies"
WORKDIR /app
RUN apk add --no-cache \
    nodejs \
    npm \
    python3 \
    py3-pip && \
    sleep 3  # 依存関係インストールのシミュレーション

# ステージ3: ビルド処理
FROM dependencies AS build
LABEL stage="application-build"
LABEL description="Building the application"
COPY . /app/
RUN echo "Building application..." && \
    sleep 5 && \
    echo "Build complete"

# ステージ4: テスト実行
FROM build AS test
LABEL stage="test-execution"
LABEL description="Running tests"
RUN echo "Running tests..." && \
    sleep 2 && \
    echo "Tests passed"

# ステージ5: 最終イメージ
FROM alpine:3.19 AS final
LABEL stage="final-image"
LABEL description="Production-ready image"
WORKDIR /app
COPY --from=build /app /app
RUN apk add --no-cache nodejs && \
    sleep 1
CMD ["echo", "Application ready"]