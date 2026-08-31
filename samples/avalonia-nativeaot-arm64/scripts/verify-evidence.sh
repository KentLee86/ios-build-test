#!/bin/sh
set -eu

evidence_dir=${1:-artifacts}
expected_arch=${EXPECTED_ARCH:-aarch64}
metadata="$evidence_dir/build-metadata.txt"
screenshot="$evidence_dir/avalonia-nativeaot.png"

test -s "$metadata"
test -s "$screenshot"

grep -Fx "machine_arch=$expected_arch" "$metadata"
grep -Eq '^binary_file=.*ELF 64-bit.*ARM aarch64' "$metadata"
grep -Fx 'process_architecture=Arm64' "$metadata"
grep -Fx 'os_architecture=Arm64' "$metadata"
grep -Fx 'runtime_identifier=linux-arm64' "$metadata"
grep -Fx 'dynamic_code_supported=false' "$metadata"
grep -Fx 'dynamic_code_compiled=false' "$metadata"
png_header=$(od -An -v -tx1 -N24 "$screenshot" | tr -d ' \n')
expected_png_header=89504e470d0a1a0a0000000d4948445200000500000002d0
if [ "$png_header" != "$expected_png_header" ]; then
    echo "Unexpected PNG header or dimensions: $png_header" >&2
    exit 1
fi

echo "$screenshot: PNG image data, 1280 x 720"

echo "ARM64 NativeAOT evidence verified."
