package com.surit.common.model.dto;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

/**
 * COMMON_CODE 한 행.
 * 카테고리 · 지역 · 진행상태가 전부 이 테이블에 CODE_GROUP 으로 구분되어 들어있다.
 */
@Getter @Setter @NoArgsConstructor @ToString
public class CommonCodeDTO {

	private String codeId;     // CAT_01, R_SEOUL_GANGNAM, REQ_01
	private String codeGroup;  // CATEGORY, REGION, STATUS
	private String codeName;   // 컴퓨터/노트북, 서울시 강남구, 접수대기
	private String useYn;      // Y / N
}
