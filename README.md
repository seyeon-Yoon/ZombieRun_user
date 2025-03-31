# ZombieRun User App

좀비런 사용자용 앱입니다.

## 주요 기능

- 로그인: 사용자 인증
- 테마 코드: 4자리 숫자 코드 입력으로 게임 시작
- 타이머: 게임 진행 시간 표시 및 관리
- 부가 기능: 메모, 카메라, 지도 기능 제공

## 개발 환경

- Flutter 3.6.1
- Dart 3.6.1
- Android Studio / VS Code

## 실행 방법

### 사전 준비

1. [Flutter SDK](https://flutter.dev/docs/get-started/install) 설치
2. [Android Studio](https://developer.android.com/studio) 또는 [VS Code](https://code.visualstudio.com/) 설치
3. Flutter 및 Dart 플러그인 설치

### Android에서 실행하기

1. Android Studio나 VS Code에서 프로젝트 열기
2. Android 기기를 USB 디버깅 모드로 연결하거나 에뮬레이터 실행
3. 터미널에서 다음 명령어 실행:
   ```bash
   flutter pub get
   flutter run
   ```

### iOS에서 실행하기

1. Mac OS가 설치된 컴퓨터 필요
2. [Xcode](https://apps.apple.com/us/app/xcode/id497799835) 설치
3. iOS 기기 또는 시뮬레이터 준비
4. 터미널에서 다음 명령어 실행:
   ```bash
   flutter pub get
   cd ios
   pod install
   cd ..
   flutter run
   ```

## 테스트 계정

- ID: admin
- Password: 1234

## 라이선스

이 프로젝트는 MIT 라이선스를 따릅니다. 자세한 내용은 [LICENSE](LICENSE) 파일을 참조하세요.
