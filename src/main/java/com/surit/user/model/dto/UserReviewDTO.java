package com.surit.user.model.dto;

import java.sql.Timestamp;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * REVIEW(또는 REVIEWS) 한 줄 + 마이페이지 목록에서 같이 보여줄 조인 결과.
 *
 * REVIEW_ID 는 IDENTITY 라 INSERT 할 때 넣지 않는다.
 *
 * 관리자용 com.surit.admin.model.dto.AdminReviewListDTO 와는 별개 클래스.
 * createdAt 타입이 다르고(여긴 Timestamp, 관리자쪽은 TO_CHAR한 String),
 * 여긴 requestTitle(무슨 접수였는지)이 필요하고 관리자쪽은 userName(누가 썼는지)이
 * 필요해서 - 보는 사람 관점이 달라 일부러 나눈다.
 */
@Getter
@Setter
@NoArgsConstructor
public class UserReviewDTO {

    // ---- REVIEW 컬럼 ----
    private Long      reviewId;
    private Long      requestId;
    private Long      userNo;       // 리뷰를 쓴 고객 (로그인한 본인)
    private Long      fixerNo;      // 평가받은 기사
    private Long   		score;        // SCORE NUMBER(1,0) -> 1~5
    private String    content;
    private Timestamp createdAt;

    // ---- 조인해서 가져오는 값 (마이페이지 목록 표시용) ----
    private String requestTitle;    // REPAIR_REQUESTS.TITLE
    private String fixerName;       // USERS.NAME (fixerNo 기준)
}