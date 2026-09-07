package com.surit.admin.model.dto;

import java.time.LocalDateTime;
import java.util.List;

import com.surit.fixer.verify.model.dto.FixerLicenseDTO;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@AllArgsConstructor
@Data
public class AdminFixerDetailDTO {

	// USERS
	private Long userNo;
	private String userId;
	private String name;
	private String phone;
	private String email;
	private String userRole;
	private String status;
	private LocalDateTime createdAt;
	
	// FIXER_PROFILE
	private String intro;
	private Long careerYears;
	private String approvalStatus;
	private LocalDateTime approvedAt;
	private String rejectReason;
	
	// 1:N - 별도조회
	private List<FixerLicenseDTO> licenses;
	private List<String> categories;
	private List<String> regions;
	
}
