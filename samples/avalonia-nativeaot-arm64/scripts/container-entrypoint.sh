#!/bin/sh
set -eu

app=/app/Arm64NativeAotDemo

if [ "${1:-}" = "--drm" ]; then
    exec "$app" "$@"
fi

smoke_test=false
if [ "${1:-}" = "--smoke-test" ]; then
    smoke_test=true
    shift
fi

evidence_dir=${EVIDENCE_DIR:-/evidence}
ready_file=/tmp/avalonia-nativeaot-ready
runtime_evidence=/tmp/avalonia-nativeaot-runtime.txt
xvfb_pid=
app_pid=

cleanup() {
    if [ -n "$app_pid" ]; then
        kill "$app_pid" 2>/dev/null || true
        wait "$app_pid" 2>/dev/null || true
    fi
    if [ -n "$xvfb_pid" ]; then
        kill "$xvfb_pid" 2>/dev/null || true
        wait "$xvfb_pid" 2>/dev/null || true
    fi
}
trap cleanup EXIT INT TERM

rm -f "$ready_file" "$runtime_evidence"
Xvfb "$DISPLAY" -screen 0 1280x720x24 -nolisten tcp -ac >/tmp/xvfb.log 2>&1 &
xvfb_pid=$!

x_ready=false
for _ in $(seq 1 50); do
    if xdpyinfo -display "$DISPLAY" >/dev/null 2>&1; then
        x_ready=true
        break
    fi
    sleep 0.1
done
if [ "$x_ready" != true ]; then
    echo "Xvfb did not become ready" >&2
    exit 1
fi

AVALONIA_READY_FILE="$ready_file" \
AVALONIA_EVIDENCE_FILE="$runtime_evidence" \
    "$app" "$@" >/tmp/avalonia.log 2>&1 &
app_pid=$!

app_ready=false
for _ in $(seq 1 100); do
    if [ -s "$ready_file" ] && [ -s "$runtime_evidence" ]; then
        app_ready=true
        break
    fi
    if ! kill -0 "$app_pid" 2>/dev/null; then
        cat /tmp/avalonia.log >&2
        wait "$app_pid"
    fi
    sleep 0.1
done
if [ "$app_ready" != true ]; then
    cat /tmp/avalonia.log >&2
    echo "Avalonia window did not become ready" >&2
    exit 1
fi

if [ "$smoke_test" = true ]; then
    mkdir -p "$evidence_dir"
    sleep 0.5
    rm -f "$evidence_dir/avalonia-nativeaot.png"
    scrot "$evidence_dir/avalonia-nativeaot.png"
    {
        echo "machine_arch=$(uname -m)"
        echo "binary_file=$(file -b "$app")"
        cat "$runtime_evidence"
    } >"$evidence_dir/build-metadata.txt"
    cp /tmp/avalonia.log "$evidence_dir/avalonia.log"
    test -s "$evidence_dir/avalonia-nativeaot.png"
    test -s "$evidence_dir/build-metadata.txt"
    exit 0
fi

wait "$app_pid"
