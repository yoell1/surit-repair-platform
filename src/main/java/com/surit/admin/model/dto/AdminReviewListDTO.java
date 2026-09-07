package com.surit.admin.model.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@AllArgsConstructor
@Data
public class AdminReviewListDTO {
	private Long reviewId;
	private Long requestId;
	private Long score;
	private String content;      // ★ 원문 — 관리자만 열람
	private String createdAt;    // SQL에서 TO_CHAR로 포맷

	private Long userNo;
	private String userName;     // 작성한 고객
	private Long fixerNo;
	private String fixerName;    // 평가받은 기사
}