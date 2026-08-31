#import "@preview/cetz:0.5.2"

#let navy = rgb("#0f172a")
#let ink = rgb("#1e293b")
#let muted = rgb("#64748b")
#let line-color = rgb("#dbe4ee")
#let paper-blue = rgb("#f2f7ff")
#let blue = rgb("#2563eb")
#let cyan = rgb("#0891b2")
#let green = rgb("#15803d")
#let paper-green = rgb("#edfdf3")
#let amber = rgb("#b45309")
#let paper-amber = rgb("#fff8e8")
#let red = rgb("#b42318")
#let paper-red = rgb("#fff3f2")
#let code-bg = rgb("#111827")
#let code-ink = rgb("#e5edf7")

#set document(
  title: "WarpBuild iOS CI 빌드 및 화면 캡처 사용 설명서",
  author: "kentlee86/ios-build-test",
  keywords: ("WarpBuild", "GitHub Actions", "iOS Simulator", "React Native"),
)

#set page(
  paper: "a4",
  margin: (x: 18mm, top: 17mm, bottom: 17mm),
  fill: white,
  header: context {
    let page-no = counter(page).get().first()
    if page-no > 1 {
      set text(font: "Noto Sans KR", size: 7.8pt, fill: muted)
      grid(
        columns: (1fr, auto),
        align(left)[WARPBUILD iOS CI],
        align(right)[kentlee86/ios-build-test],
      )
      v(4pt)
      line(length: 100%, stroke: 0.5pt + line-color)
    }
  },
  footer: context {
    let page-no = counter(page).get().first()
    if page-no > 1 {
      line(length: 100%, stroke: 0.5pt + line-color)
      v(4pt)
      set text(font: "Noto Sans KR", size: 7.8pt, fill: muted)
      grid(
        columns: (1fr, auto),
        [검증 기준: GitHub Actions run 33364094460],
        [#page-no],
      )
    }
  },
)

#set text(font: "Noto Sans KR", lang: "ko", size: 9.4pt, fill: ink)
#set par(leading: 0.72em, spacing: 0.72em)
#set list(indent: 13pt, body-indent: 5pt, spacing: 4pt)
#set enum(indent: 15pt, body-indent: 6pt, spacing: 5pt)
#show link: it => text(fill: blue, it)
#show emph: it => text(fill: navy, weight: "bold", it.body)

#let pill(body, bg: paper-blue, fg: blue) = box(
  fill: bg,
  radius: 99pt,
  inset: (x: 8pt, y: 4pt),
  text(size: 7.7pt, weight: "bold", fill: fg, body),
)

#let section(no, title, kicker: none) = {
  if kicker != none {
    text(size: 7.5pt, weight: "bold", fill: blue, tracking: 0.12em, kicker)
    v(3pt)
  }
  grid(
    columns: (11mm, 1fr),
    column-gutter: 3mm,
    align: horizon,
    box(
      width: 10mm,
      height: 10mm,
      radius: 3mm,
      fill: navy,
      align(center + horizon, text(size: 12pt, weight: "bold", fill: white, no)),
    ),
    text(size: 21pt, weight: "bold", fill: navy, title),
  )
  v(4pt)
  line(length: 100%, stroke: 1pt + line-color)
  v(9pt)
}

#let subsection(title, body) = block(
  width: 100%,
  breakable: false,
  above: 4pt,
  below: 6pt,
  [
    #text(size: 12.5pt, weight: "bold", fill: navy, title)
    #v(3pt)
    #body
  ],
)

#let note(title, body, accent: blue, bg: paper-blue) = block(
  width: 100%,
  fill: bg,
  stroke: (left: 3pt + accent, rest: 0.6pt + accent),
  radius: 6pt,
  inset: 10pt,
  breakable: false,
  [
    #text(size: 9pt, weight: "bold", fill: accent, title)
    #v(2pt)
    #body
  ],
)

#let stat(label, value, detail) = block(
  width: 100%,
  height: 34mm,
  fill: white,
  stroke: 0.7pt + line-color,
  radius: 7pt,
  inset: 10pt,
  [
    #text(size: 7.3pt, weight: "bold", fill: muted, tracking: 0.06em, label)
    #v(3pt)
    #text(size: 13pt, weight: "bold", fill: navy, value)
    #v(2pt)
    #text(size: 7.7pt, fill: muted, detail)
  ],
)

#let code(body, height: auto) = block(
  width: 100%,
  height: height,
  fill: code-bg,
  stroke: 0.6pt + rgb("#334155"),
  radius: 6pt,
  inset: 10pt,
  breakable: false,
  text(font: "Consolas", size: 7.35pt, fill: code-ink, raw(body, block: true)),
)

#let step-card(no, title, body, accent: blue, bg: paper-blue) = block(
  width: 100%,
  height: 28mm,
  fill: white,
  stroke: 0.7pt + line-color,
  radius: 7pt,
  inset: 10pt,
  breakable: false,
  grid(
    columns: (9mm, 1fr),
    column-gutter: 8pt,
    box(
      width: 8mm,
      height: 8mm,
      radius: 4mm,
      fill: accent,
      align(center + horizon, text(size: 8.5pt, weight: "bold", fill: white, no)),
    ),
    [
      #text(size: 10pt, weight: "bold", fill: navy, title)
      #v(2pt)
      #text(size: 8.3pt, fill: ink, body)
    ],
  ),
)

#let check-row(label, detail) = grid(
  columns: (6mm, 1fr),
  column-gutter: 6pt,
  align: top,
  text(size: 10pt, weight: "bold", fill: green)[✓],
  [
    #text(size: 8.6pt, weight: "bold", fill: navy, label)
    #h(3pt)
    #text(size: 8.2pt, fill: muted, detail)
  ],
)

#let pipeline = cetz.canvas({
  import cetz.draw: *

  let flow-box(x, name, no, title, subtitle, fill-color: white) = {
    rect(
      (x, 0),
      (x + 2.75, 1.45),
      name: name,
      radius: 0.14,
      fill: fill-color,
      stroke: 0.7pt + line-color,
    )
    content(
      (x + 0.22, 1.18),
      anchor: "west",
      text(size: 6.6pt, weight: "bold", fill: blue, no),
    )
    content(
      (x + 1.375, 0.77),
      anchor: "center",
      text(size: 8.1pt, weight: "bold", fill: navy, title),
    )
    content(
      (x + 1.375, 0.34),
      anchor: "center",
      text(size: 6.2pt, fill: muted, subtitle),
    )
  }

  flow-box(0, "a", "01", "실행 요청", "push 또는 수동 실행")
  flow-box(3.35, "b", "02", "의존성·검사", "npm / Jest / ESLint")
  flow-box(6.70, "c", "03", "Release 빌드", "Xcode / Simulator SDK")
  flow-box(10.05, "d", "04", "설치·실행", "simctl / iPhone")
  flow-box(13.40, "e", "05", "증거 업로드", "PNG / 로그 / 환경", fill-color: paper-green)

  for pair in (("a", "b"), ("b", "c"), ("c", "d"), ("d", "e")) {
    line(pair.at(0) + ".east", pair.at(1) + ".west", stroke: 0.9pt + blue, mark: (end: ">"))
  }
})

// Cover
#v(3mm)
#grid(
  columns: (1fr, auto),
  align: horizon,
  [#pill([OPERATIONS GUIDE], bg: navy, fg: white)],
  text(size: 8pt, fill: muted)[2026-08-31 검증판],
)

#v(12mm)
#grid(
  columns: (1fr, 54mm),
  column-gutter: 11mm,
  align: top,
  [
    #v(10mm)
    #set par(leading: 0.95em)
    #text(size: 34pt, weight: "bold", fill: navy)[
      WarpBuild iOS CI
      #linebreak()
      빌드 및 화면 캡처
    ]
    #v(7mm)
    #set par(leading: 1.35em)
    #text(size: 13pt, fill: muted)[
      React Native 앱을 macOS runner에서 빌드한 뒤
      #linebreak()
      iOS Simulator에서 실행하고
      #linebreak()
      화면과 진단 증거를 남기는 표준 절차
    ]
    #v(10mm)
    #note(
      [검증 완료],
      [run #link("https://github.com/kentlee86/ios-build-test/actions/runs/33364094460")[33364094460]에서 빌드, 앱 실행, PNG 캡처, artifact 업로드가 모두 성공했습니다.],
      accent: green,
      bg: paper-green,
    )
    #v(10mm)
    #text(size: 8pt, fill: muted)[대상 저장소]
    #v(2pt)
    #text(size: 11pt, weight: "bold", fill: navy)[kentlee86/ios-build-test]
    #v(5mm)
    #text(size: 8pt, fill: muted)[워크플로]
    #v(2pt)
    #text(size: 9pt, weight: "bold", fill: navy)[.github/workflows/ios-warpbuild.yml]
  ],
  [
    #block(
      fill: navy,
      stroke: 1pt + rgb("#263a5b"),
      radius: 11mm,
      inset: 3mm,
      image("assets/ios-simulator-success.png", width: 48mm),
    )
    #v(3pt)
    #align(center, text(size: 7.2pt, fill: muted)[실제 iPhone 16 Pro Simulator 캡처])
  ],
)

#v(10mm)
#grid(
  columns: (1fr, 1fr, 1fr),
  column-gutter: 4mm,
  stat([RUNNER LABEL], [warp-macos-15-arm64-6x], [할당된 runner 이름은 매 실행마다 달라질 수 있음]),
  stat([ELAPSED], [2분 32초], [성공 job 시작부터 완료까지]),
  stat([EVIDENCE], [3개 파일], [PNG, Simulator 로그, 빌드 환경]),
)

#pagebreak()

// Section 1
#section([1], [목적과 전체 흐름], kicker: [QUICK OVERVIEW])

#note(
  [이 문서가 증명하는 범위],
  [서명 없는 Release 앱이 WarpBuild macOS runner에서 빌드되고 iOS Simulator에 설치·실행되어 화면이 렌더링됐음을 확인합니다. 실제 iPhone 기기, 코드 서명, TestFlight 또는 App Store 배포를 증명하는 절차는 아닙니다.],
  accent: cyan,
  bg: rgb("#effbff"),
)

#v(7mm)
#subsection([처리 흐름], [GitHub Actions가 아래 순서로 한 번의 폐루프 검증을 수행합니다.])
#align(center, pipeline)

#v(7mm)
#grid(
  columns: (1fr, 1fr),
  column-gutter: 5mm,
  [
    #subsection([시작 조건], [
      - `main` 브랜치에 push
      - Actions 화면에서 `workflow_dispatch`
      - GitHub CLI의 `gh workflow run`
    ])
  ],
  [
    #subsection([완료 조건], [
      - job 결론이 `success`
      - 앱 실행 결과에 bundle ID와 PID 표시
      - `ios-simulator.png`가 비어 있지 않음
      - `ios-warpbuild-evidence` artifact 생성
    ])
  ],
)

#v(4mm)
#subsection([검증된 기준값], [
  #table(
    columns: (40mm, 1fr),
    inset: 7pt,
    stroke: 0.5pt + line-color,
    fill: (x, y) => if x == 0 { rgb("#f8fafc") } else { white },
    [*항목*], [*확인값*],
    [Git commit], [`f3f5b5d12d19b17fe6f033bb017d4d7f77d45db8`],
    [Runner], [`warp-6x-arm64-wu7rgcvyncf26ppr` / group `default`],
    [빌드 도구], [Xcode 16.4, Node 22.22.0, Ruby 3.3.12, CocoaPods 1.15.2],
    [Simulator], [iPhone 16 Pro],
    [앱 실행], [`com.kentlee.iosbuildtest: 6110`],
  )
])

#v(5mm)
#note(
  [GitHub 웹 화면에서 실행],
  [Actions → *iOS WarpBuild* → *Run workflow* → branch `main` → *Run workflow* 순서로 실행합니다. 완료 후 run 하단의 *Artifacts*에서 `ios-warpbuild-evidence`를 내려받습니다.],
  accent: blue,
  bg: paper-blue,
)

#pagebreak()

// Section 2
#section([2], [최초 1회 설정], kicker: [PREREQUISITES])

#subsection([2.1 계정과 저장소 준비], [다음 네 항목을 먼저 확인합니다. UI 명칭은 서비스 개편에 따라 달라질 수 있으므로 상태를 기준으로 판단합니다.])

#grid(
  columns: (1fr, 1fr),
  column-gutter: 5mm,
  row-gutter: 4mm,
  step-card([1], [WarpBuild와 GitHub 연결], [WarpBuild에서 GitHub 조직에 접근할 계정으로 로그인합니다.], accent: blue),
  step-card([2], [GitHub App 권한], [`kentlee86/ios-build-test`가 설치 대상에 포함되어 있어야 합니다.], accent: blue),
  step-card([3], [결제 상태], [billing이 활성이고 runner를 실행할 수 있는 credit 또는 balance가 있어야 합니다.], accent: cyan, bg: rgb("#effbff")),
  step-card([4], [Stock runner set], [macOS stock runner가 보이고 workflow label을 사용할 수 있어야 합니다.], accent: green, bg: paper-green),
)

#v(7mm)
#subsection([2.2 저장소의 핵심 설정], [현재 프로젝트에서는 아래 값을 기준으로 합니다. 다른 앱에 재사용할 때 bundle ID, workspace, scheme만 해당 프로젝트 값으로 바꿉니다.])

#table(
  columns: (43mm, 1fr),
  inset: 7pt,
  stroke: 0.5pt + line-color,
  fill: (x, y) => if x == 0 { rgb("#f8fafc") } else { white },
  [*설정*], [*값과 의미*],
  [`runs-on`], [`warp-macos-15-arm64-6x` - WarpBuild macOS 15 ARM64 runner label],
  [`APP_BUNDLE_ID`], [`com.kentlee.iosbuildtest` - Xcode target의 bundle ID와 일치],
  [`DERIVED_DATA`], [`build/DerivedData` - 빌드 산출물 위치를 고정],
  [Xcode workspace], [`ios/IosBuildTest.xcworkspace`],
  [Xcode scheme], [`IosBuildTest`],
  [권한], [`contents: read` - checkout에 필요한 최소 권한],
  [시간 제한], [`timeout-minutes: 30`],
)

#v(6mm)
#note(
  [Workflow 파일이 기준],
  [실행 정의의 SSOT는 `.github/workflows/ios-warpbuild.yml`입니다. 본문은 동작을 설명하고, 실행 명령과 핵심 YAML 발췌는 뒤쪽 *부록 A*에 모았습니다.],
  accent: blue,
  bg: paper-blue,
)

#v(5mm)
#note(
  [Apple 인증서는 필요하지 않음],
  [이 절차는 `iphonesimulator`용 서명 없는 앱을 `CODE_SIGNING_ALLOWED=NO`로 빌드합니다. 실제 기기 설치나 배포용 archive에는 별도의 인증서와 provisioning 설정이 필요합니다.],
  accent: green,
  bg: paper-green,
)

#pagebreak()

// Section 3
#section([3], [빌드와 화면 캡처 동작], kicker: [WORKFLOW DETAILS])

#grid(
  columns: (1fr, 1fr),
  column-gutter: 5mm,
  row-gutter: 4mm,
  step-card([1], [의존성과 정적 검사], [`npm ci` 후 Jest와 ESLint를 실행합니다. Ruby 3.3과 Bundler를 설정하고 CocoaPods 의존성을 설치합니다.], accent: blue),
  step-card([2], [Release Simulator 빌드], [workspace와 scheme을 지정하고 `iphonesimulator` SDK로 서명 없이 빌드합니다.], accent: blue),
  step-card([3], [Simulator 부팅과 앱 실행], [사용 가능한 첫 iPhone을 선택해 부팅하고 `.app`을 설치한 뒤 bundle ID로 실행합니다.], accent: cyan, bg: rgb("#effbff")),
  step-card([4], [증거 수집], [10초 대기 후 PNG를 저장하고 최근 3분의 앱 로그와 도구 버전을 함께 업로드합니다.], accent: green, bg: paper-green),
)

#v(7mm)
#subsection([Workflow 단계와 책임], [])
#table(
  columns: (58mm, 1fr),
  inset: 7pt,
  stroke: 0.5pt + line-color,
  fill: (x, y) => if x == 0 { rgb("#f8fafc") } else { white },
  [*단계 이름*], [*수행 내용*],
  [#raw("Run JavaScript checks")], [Jest와 ESLint를 실행해 빌드 전 정적 검사를 마칩니다.],
  [#raw("Build unsigned Release app for Simulator")], [Release 설정과 Simulator SDK로 서명 없이 앱을 빌드합니다.],
  [#raw("Select and boot an iPhone Simulator")], [사용 가능한 iPhone UDID를 선택하고 부팅 완료까지 기다립니다.],
  [#raw("Install, launch, and capture the app")], [앱 설치와 실행 후 PNG가 생성됐는지 확인합니다.],
  [#raw("Upload iOS evidence")], [화면, 로그, 환경 metadata를 하나의 artifact로 보존합니다.],
)

#v(6mm)
#subsection([Artifact 구성], [])
#table(
  columns: (47mm, 1fr, 27mm),
  inset: 7pt,
  stroke: 0.5pt + line-color,
  fill: (x, y) => if y == 0 { navy } else if calc.rem(y, 2) == 0 { rgb("#f8fafc") } else { white },
  [#text(fill: white, weight: "bold")[파일]], [#text(fill: white, weight: "bold")[판정에 쓰는 내용]], [#text(fill: white, weight: "bold")[보존]],
  [`ios-simulator.png`], [앱이 실제로 표시된 Simulator 화면], [14일],
  [`simulator.log`], [실행 시점 최근 3분의 `IosBuildTest` 프로세스 로그], [14일],
  [`build-metadata.txt`], [Xcode, Node, Ruby, CocoaPods, Simulator 정보], [14일],
)

#v(6mm)
#note(
  [캡처 시점 조정],
  [앱 초기화가 10초보다 오래 걸리면 `sleep 10`을 늘리거나, 화면 준비를 판정할 수 있는 신호로 대체합니다. 고정 대기 시간을 줄일 때는 빈 화면이나 launch screen이 캡처되지 않는지 다시 확인합니다.],
  accent: amber,
  bg: paper-amber,
)

#pagebreak()

// Section 4
#section([4], [실행하고 결과 확인하기], kicker: [RUN AND VERIFY])

#subsection([4.1 실행 순서], [저장소 루트에서 인증, 실행, 추적, 증거 다운로드 순으로 진행합니다. 복사 가능한 PowerShell 명령은 뒤쪽 *부록 A*에 있습니다.])

#grid(
  columns: (1fr, 1fr),
  column-gutter: 5mm,
  row-gutter: 4mm,
  step-card([1], [GitHub 인증 확인], [`gh auth status`로 현재 계정과 repository 접근 권한을 확인합니다.], accent: blue),
  step-card([2], [Workflow 실행], [`main` 브랜치에서 `iOS WarpBuild`를 수동 실행합니다.], accent: blue),
  step-card([3], [Run 완료 추적], [새 run ID를 얻고 job이 끝날 때까지 상태와 종료 코드를 확인합니다.], accent: cyan, bg: rgb("#effbff")),
  step-card([4], [Artifact 회수], [`ios-warpbuild-evidence`를 내려받아 PNG부터 직접 엽니다.], accent: green, bg: paper-green),
)

#v(5mm)
#note(
  [명령과 파일은 뒤쪽에 배치],
  [복사해 실행할 PowerShell 명령과 Workflow 핵심 YAML은 *부록 A*에 있으며, 전체 원본은 `.github/workflows/ios-warpbuild.yml`을 참조합니다.],
  accent: blue,
  bg: paper-blue,
)

#v(6mm)
#grid(
  columns: (48mm, 1fr),
  column-gutter: 6mm,
  align: top,
  [
    #block(
      fill: navy,
      stroke: 0.8pt + rgb("#263a5b"),
      radius: 7mm,
      inset: 2mm,
      image("assets/ios-simulator-success.png", width: 42mm),
    )
    #v(3pt)
    #align(center, text(size: 7pt, fill: muted)[run 33364094460의 실제 캡처])
  ],
  [
    #subsection([4.2 성공 판정 체크리스트], [])
    #check-row([Workflow], [`Build, run, and capture iOS` job이 녹색 `success`])
    #v(4pt)
    #check-row([Xcode], [로그 끝에 `** BUILD SUCCEEDED **`])
    #v(4pt)
    #check-row([앱 실행], [`com.kentlee.iosbuildtest: <PID>`가 출력됨])
    #v(4pt)
    #check-row([화면], [`WarpBuild iOS CI`와 `BUILD & RUN OK`가 PNG에 표시됨])
    #v(4pt)
    #check-row([Artifact], [PNG, 로그, metadata 세 파일이 모두 존재])
    #v(5mm)
    #note(
      [화면을 직접 판정],
      [job 성공만으로 UI가 올바르게 보였다고 단정하지 않습니다. PNG를 열어 문구, 배치, 잘림, 빈 화면 여부를 확인합니다.],
      accent: green,
      bg: paper-green,
    )
  ],
)

#pagebreak()

// Section 5
#section([5], [FVE_008일 때 지원 요청], kicker: [ONLY REQUIRED WHEN ONBOARDING IS BLOCKED])

#note(
  [오류 코드 정정],
  [지원팀에 보낸 핵심 오류는 `FVE_008`입니다. Runner 할당 단계에서 함께 보인 코드는 `RNR_ALLOC_007`입니다. `FVE_007`로 기록하지 않습니다.],
  accent: red,
  bg: paper-red,
)

#v(6mm)
#subsection([언제 메일을 보내는가], [billing과 GitHub App 연결이 정상인데 stock runner가 보이지 않고, runner 생성 또는 onboarding 요청이 `FVE_008`로 거절될 때 한 번 보냅니다. Runner가 이미 job에 할당된다면 이 단계는 건너뜁니다.])

#grid(
  columns: (1fr, 1fr),
  column-gutter: 5mm,
  [
    #subsection([메일에 넣을 증거], [
      - GitHub organization과 repository
      - GitHub App installation ID
      - billing 활성 및 잔액 상태
      - stock runner 목록이 비어 있다는 상태
      - `RNR_ALLOC_007`과 `FVE_008` 원문
      - 영향을 받은 Actions run URL
      - runner 미배정이라 step log가 없다는 설명
    ])
  ],
  [
    #subsection([요청할 조치], [
      - Cloud Runner onboarding suspension 해제
      - stock runner set 복구
      - 조직이 다시 runner를 할당할 수 있는지 확인
      - 조치 완료 회신 요청
    ])
  ],
)

#v(4mm)
#subsection([지원 메일 템플릿], [])
#code("To: support@warpbuild.com\nSubject: FVE_008 - Please unsuspend Cloud Runner onboarding for <organization>\n\nHello WarpBuild Support,\n\nPlease unsuspend Cloud Runner onboarding for our GitHub organization\nand restore the stock runner set.\n\n- Organization: <organization>\n- Repository: <owner/repository>\n- GitHub App installation ID: <installation-id>\n- Billing status: active, with available balance\n- Runner list: empty / stock runners unavailable\n- Allocation error: RNR_ALLOC_007\n- Runner creation error: FVE_008\n- Affected Actions runs: <run-url-1>, <run-url-2>\n\nNo runner is assigned, so there are no job step logs. Please let us know\nwhen the organization is unblocked and the stock runner set is restored.\n\nThanks,\n<name>")

#v(6mm)
#subsection([회신을 받은 뒤], [])
#grid(
  columns: (1fr, 1fr, 1fr),
  column-gutter: 4mm,
  step-card([1], [추가 설정 없이 재실행], [동일한 workflow를 `main`에서 수동 실행합니다.], accent: blue),
  step-card([2], [Runner 배정 확인], [`Set up runner`가 수 초 안에 시작되는지 봅니다.], accent: cyan, bg: rgb("#effbff")),
  step-card([3], [폐루프 확인], [빌드 성공뿐 아니라 다운로드한 PNG까지 직접 확인합니다.], accent: green, bg: paper-green),
)

#v(7mm)
#note(
  [운영 기준],
  [지원 메일은 runner onboarding이 막힌 경우에만 필요합니다. 정상 운영에서는 workflow 실행, run 추적, artifact 다운로드의 세 단계만 반복하면 됩니다.],
  accent: green,
  bg: paper-green,
)

#pagebreak()

// Appendix A
#section([A], [PowerShell 명령 참조], kicker: [REFERENCE])

#note(
  [본문과 분리된 실행 코드],
  [아래 명령은 Windows PowerShell에서 그대로 복사해 사용할 수 있습니다. 저장소 이름이나 workflow 이름을 바꾸면 `--repo`와 `--workflow` 값도 함께 바꿉니다.],
  accent: blue,
  bg: paper-blue,
)

#v(6mm)
#subsection([A.1 Workflow 실행과 완료 추적], [])
#code("gh auth status\n\ngh workflow run \"iOS WarpBuild\" `\n  --repo kentlee86/ios-build-test `\n  --ref main\n\nStart-Sleep -Seconds 3\n$runId = gh run list `\n  --repo kentlee86/ios-build-test `\n  --workflow \"iOS WarpBuild\" `\n  --limit 1 --json databaseId `\n  --jq \".[0].databaseId\"\n\ngh run watch $runId `\n  --repo kentlee86/ios-build-test `\n  --exit-status --interval 10")

#v(6mm)
#subsection([A.2 Artifact 다운로드와 화면 열기], [])
#code("$evidence = Join-Path $PWD \"artifacts\\$runId\"\nNew-Item -ItemType Directory -Force -Path $evidence | Out-Null\n\ngh run download $runId `\n  --repo kentlee86/ios-build-test `\n  --name ios-warpbuild-evidence `\n  --dir $evidence\n\nInvoke-Item (Join-Path $evidence \"ios-simulator.png\")")

#v(7mm)
#note(
  [종료 코드도 확인],
  [`gh run watch --exit-status`는 workflow 실패 시 0이 아닌 종료 코드를 반환합니다. 명령이 끝났다는 사실과 workflow가 성공했다는 사실을 구분합니다.],
  accent: amber,
  bg: paper-amber,
)

#pagebreak()

// Appendix B
#section([B], [Workflow 파일 참조], kicker: [SOURCE REFERENCE])

#note(
  [전체 원본이 SSOT],
  [아래 내용은 핵심 발췌입니다. 실제 실행 기준은 repository의 `.github/workflows/ios-warpbuild.yml`이며, public 원본은 #link("https://github.com/kentlee86/ios-build-test/blob/main/.github/workflows/ios-warpbuild.yml")[GitHub에서 열기]로 확인합니다.],
  accent: blue,
  bg: paper-blue,
)

#v(9mm)
#subsection([B.1 Trigger, runner, 환경값], [])
#code("name: iOS WarpBuild\n\non:\n  push:\n    branches: [main]\n  workflow_dispatch:\n\npermissions:\n  contents: read\n\njobs:\n  build-run-screenshot:\n    name: Build, run, and capture iOS\n    runs-on: warp-macos-15-arm64-6x\n    timeout-minutes: 30\n    env:\n      APP_BUNDLE_ID: com.kentlee.iosbuildtest\n      DERIVED_DATA: build/DerivedData")

#v(6mm)
#grid(
  columns: (1fr, 1fr),
  column-gutter: 5mm,
  [
    #subsection([B.2 Release Simulator 빌드], [])
    #code("- name: Build unsigned Release app for Simulator\n  run: |\n    xcodebuild \\\n      -workspace ios/IosBuildTest.xcworkspace \\\n      -scheme IosBuildTest \\\n      -configuration Release \\\n      -sdk iphonesimulator \\\n      -destination 'generic/platform=iOS Simulator' \\\n      -derivedDataPath \"$DERIVED_DATA\" \\\n      CODE_SIGNING_ALLOWED=NO build", height: 43mm)
  ],
  [
    #subsection([B.3 설치·실행·캡처], [])
    #code("- name: Install, launch, and capture the app\n  shell: bash\n  run: |\n    APP_PATH=\"$DERIVED_DATA/Build/Products/\\\nRelease-iphonesimulator/IosBuildTest.app\"\n    xcrun simctl install \"$SIMULATOR_UDID\" \"$APP_PATH\"\n    xcrun simctl launch \"$SIMULATOR_UDID\" \"$APP_BUNDLE_ID\"\n    sleep 10\n    xcrun simctl io \"$SIMULATOR_UDID\" screenshot \\\n      artifacts/ios-simulator.png\n    test -s artifacts/ios-simulator.png", height: 43mm)
  ],
)

#v(6mm)
#subsection([B.4 증거 업로드], [])
#code("- name: Upload iOS evidence\n  if: always()\n  uses: actions/upload-artifact@v4\n  with:\n    name: ios-warpbuild-evidence\n    path: artifacts/\n    if-no-files-found: warn\n    retention-days: 14")
