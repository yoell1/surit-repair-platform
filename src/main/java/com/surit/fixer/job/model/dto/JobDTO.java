package com.surit.fixer.job.model.dto;

import java.sql.Timestamp;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * 내 작업 한 건.
 *
 * "작업" = 내가 낸 견적이 선택(SELECTED)된 접수.
 * 그래서 ESTIMATES + REPAIR_REQUESTS + USERS 를 조인한 결과를 담는다.
 */
@Getter
@Setter
@NoArgsConstructor
public class JobDTO {

	// ---- 접수 ----
	private Long      requestId;
	private String    title;
	private String    content;
	private String    serviceAddress;
	private String    statusCode;
	private String    statusName;
	private String    categoryName;
	private Timestamp createdAt;

	// ---- 고객 ----
	private String customerName;
	private String customerPhone;

	// ---- 내 견적 ----
	private Long estimateId;
	private Long estimatedPrice;      // 원 단위 정수 (소수점 없음)
	private Long estimatedDuration;
	private String     estimateContent;
}
