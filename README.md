# iOS Build Test

React Native 앱을 GitHub Actions의 macOS 러너에서 빌드하고, iOS Simulator에
설치·실행한 뒤 화면을 캡처하는 최소 검증 프로젝트입니다.

## 로컬 검증

```sh
npm ci
npx jest --runInBand
npm run lint
```

Windows에서는 네이티브 iOS 빌드를 실행할 수 없습니다. 실제 iOS 검증은 다음
workflow 중 하나에서 수행하며 동일한 증거를 artifact로 남깁니다.

- `.github/workflows/ios-namespace.yml`: Namespace macOS Apple Silicon profile에서
  수동 실행
- `.github/workflows/ios-warpbuild.yml`: WarpBuild macOS runner에서 push 또는 수동 실행

- `ios-simulator.png`: 실행된 앱 화면
- `simulator.log`: 실행 시점의 Simulator 로그
- `build-metadata.txt`: Xcode, Node, Ruby, CocoaPods 버전과 선택한 Simulator

## CI 동작

1. npm 및 Ruby/CocoaPods 의존성 설치
2. Jest와 ESLint 실행
3. CocoaPods 설치 후 Release Simulator 앱 빌드
4. 사용 가능한 iPhone Simulator 부팅
5. 앱 설치 및 `com.kentlee.iosbuildtest` 실행
6. 화면 캡처와 진단 로그 업로드

Namespace workflow는 `namespace-profile-ios-macos`를 사용하며 GitHub Actions의
`workflow_dispatch`로만 실행됩니다. CI는 서명 없는 Simulator 빌드이므로 Apple
Developer 인증서는 필요하지 않습니다.
