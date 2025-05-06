# dustify 🌬️

[![Flutter](https://img.shields.io/badge/Flutter-3.7.0+-blue)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.7.0+-blueviolet)](https://dart.dev)

대기질 정보를 제공하는 Flutter 애플리케이션입니다.

## 📋 프로젝트 요구사항

### 🎯 Flutter SDK 버전
- Flutter SDK 3.7.0 이상이 필요합니다.
- Dart SDK 3.7.0 이상이 필요합니다.

### 📦 의존성 패키지
- `dio: 5.8.0+1` - HTTP 통신
- `isar: 3.1.0+1` - 로컬 데이터베이스
- `isar_flutter_libs: 3.1.0+1` - Flutter용 Isar
- `path_provider: 2.1.5` - 파일 경로 제공

### 💻 개발 환경 설정

1. Flutter SDK 설치
   ```bash
   # Flutter SDK 다운로드
   git clone https://github.com/flutter/flutter.git
   
   # 환경 변수 설정
   export PATH=$PATH:`pwd`/flutter/bin
   ```

2. 의존성 설치
   ```bash
   flutter pub get
   ```

3. 앱 실행
   ```bash
   # Android 에뮬레이터 실행
   flutter run
   
   # iOS 시뮬레이터 실행
   flutter run -d ios
   ```

### 📱 플랫폼 지원
- Android (API 21 이상)
- iOS (iOS 11.0 이상)

## 📁 프로젝트 구조

```
lib/
├── main.dart          # 애플리케이션 진입점
├── screen/            # 화면 컴포넌트
├── component/         # 재사용 가능한 위젯
├── widget/           # 위젯 컴포넌트
├── utils/            # 유틸리티 함수
├── const/            # 상수 정의
├── model/            # 데이터 모델
└── repository/       # 데이터 저장소
```

## 📝 라이선스

MIT License
