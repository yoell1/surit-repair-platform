package com.surit.admin.model.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/** 경고 누적 대상 (정지 검토 후보) */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class AdminWarnTargetDTO {
	private Long    userNo;
	private String  userId;
	private String  name;
	private String  userRole;    // USER / FIXER
	private String  status;      // ACTIVE / SUSPEND / LEAVED
	private Integer warnCount;
	private String  lastWarnAt;
}