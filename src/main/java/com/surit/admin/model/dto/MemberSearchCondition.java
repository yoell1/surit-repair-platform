package com.surit.admin.model.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@AllArgsConstructor
@Data
// 검색 조건
public class MemberSearchCondition {

	// 검색 파라미터 : 카테고리, 검색 종류, 키워드
	private String userRole; // 고객인지, 기사인지 구분
	private String status; 	 // 계정 상태값
	private String keyword;  // 검색어
	
	// 페이징 관련
	private int size = 10;
	private int page = 1;
	
	// 쿼리문 실행 시 사용할 
	private int offset;   // 건너뛸 행수
}
