#!/bin/bash

# 配置镜像信息
IMAGE_NAME="dengwanlin/onebot"
TAG="latest"
BUILD_CONTEXT="./docker-build"

# 将编译的二进制复制到docker-build目录
TARGET_DIR="/home/qingshu/IdeaProjects/OneBotMultiplatform/examples/app/build/bin"
TARGET_ARM64="$TARGET_DIR/linuxArm64/releaseExecutable/app-*.kexe"
TARGET_AMD64="$TARGET_DIR/linuxX64/releaseExecutable/app-*.kexe"

# 发生错误时立即退出
set -e

echo "🚀 开始构建流程..."

# 复制文件到 docker-build/arm64/, docker-build/amd64/
echo "📂 正在准备目录结构..."
mkdir -p "$BUILD_CONTEXT/arm64"
mkdir -p "$BUILD_CONTEXT/amd64"

echo "🚚 复制二进制文件..."
cp $TARGET_ARM64 "$BUILD_CONTEXT/arm64"
cp $TARGET_AMD64 "$BUILD_CONTEXT/amd64"

# 配置 buildx
BUILDER_NAME="multi-builder"
if ! docker buildx inspect "$BUILDER_NAME" > /dev/null 2>&1; then
    echo "🛠  创建新的 Buildx 实例..."
    docker buildx create --name "$BUILDER_NAME" \
        --driver docker-container \
        --driver-opt network=host \
        --driver-opt env.http_proxy=127.0.0.1:7897 \
        --driver-opt env.https_proxy=127.0.0.1:7897 \
        --use
    
    echo "启动并验证 Buildx 引擎..."
    docker buildx inspect --bootstrap --builder $BUILDER_NAME
else
    echo "✅ 使用现有的 Buildx 实例: $BUILDER_NAME"
    docker buildx use $BUILDER_NAME
fi

echo "📤 正在构建并推送镜像: ${IMAGE_NAME}:${TAG}..."
docker buildx build \
    --platform linux/amd64,linux/arm64 \
    -t $IMAGE_NAME:$TAG \
    --push .

echo "🗑️ 删除临时文件"
rm -rf "$BUILD_CONTEXT"

echo "✅ 所有任务已完成！"