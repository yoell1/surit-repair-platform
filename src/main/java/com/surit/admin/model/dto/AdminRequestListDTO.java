package com.surit.admin.model.dto;

import lombok.Getter;
import lombok.Setter;

/** 접수 현황 목록 한 줄 */
@Getter
@Setter
public class AdminRequestListDTO {

	private Long   requestId;
	private String title;
	private String categoryCode;
	private String categoryName;
	private String statusCode;
	private String statusName;
	private String serviceAddress;
	private String createdAt;      // TO_CHAR 로 문자열로 받는다

	private Long   userNo;
	private String customerName;
	private String customerPhone;

	private int    estimateCount;  // 받은 견적 수
	private Long   fixerNo;        // 채택된 기사 (없으면 null)
	private String fixerName;
	private Long   estimatedPrice; // 채택된 견적 금액
}