package com.surit.fixer.estimate.model.dto;

import java.sql.Timestamp;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * ESTIMATES 한 줄 + 목록에서 같이 보여줄 조인 결과.
 *
 * 새 DB 에는 ESTIMATES_OPTION 테이블이 없어서 옵션(추가 항목) 기능은 빠졌다.
 * 금액은 ESTIMATED_PRICE 하나로 끝난다.
 */
@Getter
@Setter
@NoArgsConstructor
public class EstimateDTO {

	// ---- ESTIMATES 컬럼 ----
	private Long estimateId;
	private Long       requestId;
	private Long    fixerNo;            // 견적을 낸 기사의 USER_NO
	private String fixerName;      
	/**
	 * 돈은 double 로 다루지 않는다.
	 * double 은 0.1 같은 값을 정확히 못 담아서 더할수록 오차가 쌓인다.
	 */
	private Long    estimatedPrice;     // 원 단위 정수 (소수점 없음)
	private Long    estimatedDuration;  // 예상 소요 시간(분)
	private String     content;
	private String     status;             // PENDING / SELECTED
	private Timestamp  createdAt;

	// ---- 조인해서 가져오는 값 ----
	private String requestTitle;
	private String requestStatusCode;      // REPAIR_REQUESTS.STATUS_CODE
	private String requestStatusName;
	private String categoryName;
	private String customerName;
	private String serviceAddress;
}