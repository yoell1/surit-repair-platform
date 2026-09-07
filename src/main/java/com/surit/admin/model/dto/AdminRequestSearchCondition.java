package com.surit.admin.model.dto;

import lombok.Getter;
import lombok.Setter;

/** 접수 현황 검색 조건 + 페이징 (AdminReviewSearchCondition 과 같은 구조) */
@Getter
@Setter
public class AdminRequestSearchCondition {

	private String statusCode;   // REQ_01 ... (비어있으면 전체)
	private String keyword;      // 제목 또는 고객명
	private String fromDate;     // 2026-08-01
	private String toDate;       // 2026-08-27

	private int page = 1;
	private int size = 10;
	private int offset;          // service 에서 계산해서 넣는다
}