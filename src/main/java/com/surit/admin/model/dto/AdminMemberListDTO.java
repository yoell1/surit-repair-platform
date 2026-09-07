package com.surit.admin.model.dto;

import java.time.LocalDateTime;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@AllArgsConstructor
@Data
public class AdminMemberListDTO {
	
	// MemberManagement 에서 사용
	// 기사 정보
	
	private Long userNo;
	private String userId;
	private String name;
	private String userRole;
	private String status;
	private LocalDateTime createdAt;
	
	private String approvalStatus;
	private Double avgScore;	//review 계산값 1
	private Long reviewCount; // review 계산값 2
}
