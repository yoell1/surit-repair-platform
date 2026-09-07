# 수릿(Surit) — 출장 수리 중개 플랫폼

고객이 수리를 접수하면 주변 기사가 직접 예상 견적을 제시하고,
고객이 견적을 골라 매칭되는 중개 플랫폼입니다.

부트캠프 팀 프로젝트 (6인) · 2026.08 ~ 09

## 담당 — 기사 기능 4종 (F-14 ~ F-17)

| 기능 | 내용 |
|---|---|
| F-14 기사 인증 신청 | 자격증·사진 업로드와 4개 테이블 저장을 한 트랜잭션으로 |
| F-15 내 주변 접수 조회 | 기사의 분야·지역에 맞는 접수만 노출 |
| F-16 예상 견적 제시 | 중복 제출을 SQL 조건으로 차단 |
| F-17 내 작업 관리 | 상태 전환을 조회 없이 UPDATE 한 번으로 |

**담당 코드**

- `src/main/java/com/surit/fixer/**`
- `src/main/java/com/surit/common/request/**`
- `src/main/resources/mappers/FixerMapper.xml` · `EstimateMapper.xml` · `JobMapper.xml` · `RequestMapper.xml`
- `src/main/webapp/WEB-INF/views/fixer/**`

설계 의도와 문제 해결 과정은 별도 문서에 정리했습니다 →
**[포트폴리오 (Notion)](https://app.notion.com/p/Surit-4-F-14-F-17-3d499fb7397c813da5d6d06e6638b603)**

## 기술 스택

Java 17 · Spring Boot 3 · MyBatis · Oracle · JSP/JSTL · Spring Security(BCrypt) · Maven

## 실행 방법

1. `src/main/resources/application.properties.example` 을 복사해
   `application.properties` 로 이름을 바꾸고 DB 접속 정보를 채웁니다.
2. Oracle 스키마를 생성합니다.
3. `SuritApplication.java` 를 Spring Boot App 으로 실행 → `http://localhost:8989`

## 테스트

팀 전체 테스트케이스 시트입니다 → [수릿 스프레드 시트.xlsx](<수릿 스프레드 시트.xlsx>)

제 담당분은 **「수리기사」 시트 71건**이고, 맨 오른쪽 「이우진 결과」 열이 재검증 후 최종 결과입니다 (Pass 71 · 미실시 0).

## 참고

`uploads/` 폴더와 `application.properties` 는 저장소에 포함하지 않습니다.
