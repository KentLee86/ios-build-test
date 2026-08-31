# syntax=docker/dockerfile:1.7

FROM mcr.microsoft.com/dotnet/sdk:10.0.400-noble-aot AS build

ARG TARGETARCH

RUN test "$TARGETARCH" = "arm64" \
    && test "$(uname -m)" = "aarch64"

RUN apt-get update \
    && apt-get install -y --no-install-recommends file \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /src
COPY global.json ./
COPY Arm64NativeAotDemo/Arm64NativeAotDemo.csproj ./Arm64NativeAotDemo/
RUN dotnet restore Arm64NativeAotDemo/Arm64NativeAotDemo.csproj \
    --runtime linux-arm64

COPY Arm64NativeAotDemo/ ./Arm64NativeAotDemo/
RUN dotnet publish Arm64NativeAotDemo/Arm64NativeAotDemo.csproj \
    --configuration Release \
    --runtime linux-arm64 \
    --self-contained true \
    --no-restore \
    --output /app/publish \
    && file /app/publish/Arm64NativeAotDemo \
    | grep -E 'ELF 64-bit.*ARM aarch64'

FROM mcr.microsoft.com/dotnet/runtime-deps:10.0.10-noble AS runtime

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        file \
        fonts-dejavu-core \
        libegl1 \
        libfontconfig1 \
        libfreetype6 \
        libgbm1 \
        libgl1 \
        libgl1-mesa-dri \
        libice6 \
        libinput10 \
        libsm6 \
        libx11-6 \
        libxcb1 \
        libxext6 \
        libxkbcommon0 \
        libxrender1 \
        scrot \
        x11-utils \
        xvfb \
    && rm -rf /var/lib/apt/lists/*

ENV DISPLAY=:99 \
    LIBGL_ALWAYS_SOFTWARE=1

WORKDIR /app
COPY --from=build /app/publish/ ./
COPY scripts/container-entrypoint.sh /usr/local/bin/run-arm64-demo
RUN chmod +x /usr/local/bin/run-arm64-demo

ENTRYPOINT ["/usr/local/bin/run-arm64-demo"]
CMD ["--smoke-test"]
