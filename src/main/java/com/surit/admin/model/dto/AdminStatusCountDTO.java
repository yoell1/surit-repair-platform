package com.surit.admin.model.dto;

import lombok.Getter;
import lombok.Setter;

/** 상단 KPI 카드 한 장 (상태 / 건수) */
@Getter
@Setter
public class AdminStatusCountDTO {

	private String statusCode;   // REQ_01
	private String statusName;   // 접수대기
	private int    cnt;          // 건수
}