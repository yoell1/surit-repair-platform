package com.surit.admin.model.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/** 세션·화면에 담는 관리자 정보 (비밀번호 제외) */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class AdminResponse {
	private String adminId;
	private String adminName;
}