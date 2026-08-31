#!/bin/sh
set -eu

host_arch=$(uname -m)
case "$host_arch" in
    aarch64|arm64) ;;
    *)
        echo "Native ARM64 host required; got $host_arch" >&2
        exit 1
        ;;
esac

docker_arch=$(docker info --format '{{.Architecture}}')
case "$docker_arch" in
    aarch64|arm64) ;;
    *)
        echo "Native ARM64 Docker daemon required; got $docker_arch" >&2
        exit 1
        ;;
esac

image_tag=${IMAGE_TAG:-arm64-nativeaot-demo:local}
mkdir -p artifacts

docker build --platform linux/arm64 --tag "$image_tag" .
docker run --rm \
    --volume "$(pwd)/artifacts:/evidence" \
    "$image_tag"

sh scripts/verify-evidence.sh artifacts
