# Create the builder
docker buildx create --name multi-builder \
    --driver docker-container \
    --driver-opt network=host \
    --driver-opt env.http_proxy=127.0.0.1:7897 \
    --driver-opt env.https_proxy=127.0.0.1:7897 \
    --use

# booting builder
docker buildx inspect --bootstrap --builder multi-builder

# Build image with multi-builder and push to aliyuncs
docker buildx build \
    --platform linux/amd64,linux/arm64 \
    -t crpi-g1rseduejfv59izj.cn-chengdu.personal.cr.aliyuncs.com/dengwanlin/onebot:latest \
    --push .

# Build image with multi-builder and push to docker.io
docker buildx build \
    --platform linux/amd64,linux/arm64 \
    -t dengwanlin/onebot:latest \
    --push .


