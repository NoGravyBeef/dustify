# Use Case List

## 1. 지역 선택
- **Actor**: 사용자
- **Description**: 사용자는 메뉴에서 원하는 지역을 선택할 수 있다.
- **Precondition**: 앱이 실행 중인 상태
- **Postcondition**: 선택된 지역의 미세먼지 정보가 표시됨

## 2. API 데이터 가져오기
- **Actor**: 시스템
- **Description**: 공공 API에서 실시간 미세먼지 데이터를 가져온다.
- **Precondition**: 인터넷 연결 상태
- **Postcondition**: 최신 미세먼지 데이터가 저장됨

## 3. 데이터 저장
- **Actor**: 시스템
- **Description**: API에서 가져온 데이터를 Isar DB에 저장한다.
- **Precondition**: API 데이터 수신 완료
- **Postcondition**: 데이터가 Isar DB에 저장됨

## 4. 미세먼지 상태 조회
- **Actor**: 사용자
- **Description**: 사용자는 선택한 지역의 미세먼지 상태를 확인할 수 있다.
- **Precondition**: 특정 지역이 선택된 상태
- **Postcondition**: 해당 지역의 미세먼지 상태가 표시됨

## 5. 상태 표시
- **Actor**: 사용자
- **Description**: 사용자는 현재 미세먼지 상태에 따른 시각적 피드백을 받는다.
- **Precondition**: 미세먼지 상태가 조회된 상태
- **Postcondition**: 상태에 따른 색상과 메시지가 표시됨

## 6. 상태 레벨 표시
- **Actor**: 사용자
- **Description**: 사용자는 미세먼지 상태에 따른 등급을 확인할 수 있다.
- **Precondition**: 미세먼지 상태가 조회된 상태
- **Postcondition**: 상태 등급(최고, 좋음, 양호 등)이 표시됨
