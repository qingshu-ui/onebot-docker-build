FROM dengwanlin/sdkman

ARG TARGETARCH

LABEL maintainer="dengwanlin"
LABEL description="OneBot Service based on Kotlin Multiplatform"

RUN apt-get update && \
    apt-get install -y \
    tzdata \
    libsqlite3-0 && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /root/bot

COPY ./docker-build/${TARGETARCH}/app-*.kexe ./app.kexe

RUN chmod +x app.kexe

VOLUME /root/bot/logs
VOLUME /root/bot/cache
VOLUME /root/bot/config

CMD ["./app.kexe"]

