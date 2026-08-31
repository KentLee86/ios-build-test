# Avalonia ARM64 NativeAOT build lab

This sample builds a .NET 10/Avalonia 12 GUI as a native `linux-arm64` ELF on an
ARM64 Linux host. The same image runs under Xvfb for cloud validation and can use
DRM/KMS directly on a 64-bit Raspberry Pi.

## What the smoke test proves

- the build host and Docker daemon are native ARM64, not x64 emulation;
- `dotnet publish -r linux-arm64` completes with NativeAOT enabled;
- the output is an AArch64 ELF and runs without a separately installed .NET runtime;
- Avalonia opens an actual X11 window and produces a 1280x720 PNG;
- the running process reports `RuntimeFeature.IsDynamicCodeSupported=false`.

The cloud run does not prove Raspberry Pi GPIO, DRM, touch, GPU acceleration, or
electrical behavior. Those remain physical-device checks.

## Run on an ARM64 Docker host

```sh
cd samples/avalonia-nativeaot-arm64
sh scripts/build-and-smoke.sh
```

Evidence is written to `artifacts/`:

- `avalonia-nativeaot.png`
- `build-metadata.txt`
- `avalonia.log`

## Create a temporary Namespace ARM64 host

Install and log in to the Namespace CLI, then create one native ARM64 instance
with a Docker-enabled helper container:

```powershell
nsc login
nsc run `
  --image docker:28-cli `
  --machine_type linux/arm64:4x8 `
  --name arm64-builder `
  --enable_docker `
  --wait `
  --duration 45m `
  --documented_purpose "Avalonia Raspberry Pi NativeAOT build" `
  -- sh -lc "sleep infinity"
```

Upload this sample to the `arm64-builder` container, open its web terminal, and
run `sh scripts/build-and-smoke.sh`. Destroy the instance after downloading the
evidence:

```powershell
nsc destroy <instance-id> --force
```

## Run on a Raspberry Pi

Use Raspberry Pi OS 64-bit and install the DRM dependencies:

```sh
sudo apt-get install libgbm1 libgl1-mesa-dri libegl1 libinput10
```

For a containerized kiosk, expose the display and input devices and start the
DRM path. Device/group names vary by image and Pi configuration, so confirm them
on the target first.

```sh
docker run --rm -it \
  --device /dev/dri \
  --device /dev/input \
  --group-add video \
  --group-add input \
  arm64-nativeaot-demo:local --drm
```

The Docker image intentionally supports only native ARM64 builds. An x64 host or
x64 Docker daemon fails before compilation instead of silently using QEMU.
