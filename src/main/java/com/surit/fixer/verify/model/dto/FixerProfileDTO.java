package com.surit.fixer.verify.model.dto;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

/**
 * FIXER_PROFILE 한 행. PK 가 USER_NO 라서 USERS 와 1:1 이다. (한 사람당 기사 프로필 하나)
 */
@Getter
@Setter
@NoArgsConstructor
@ToString
public class FixerProfileDTO {

	private Long   userNo;          // USER_NO (PK, USERS 참조)
	private String intro;           // INTRO
	private Long   careerYears;     // CAREER_YEARS (숫자! 예전엔 문자열이었음)
	private String approvalStatus;  // PENDING / APPROVED / REJECTED
	private String photoUrl;        // FIXER_PHOTO_URL (고객 확인용 사진, 파일 경로)

	/*
	 * REJECT_REASON — 관리자가 거절할 때 남기는 사유.
	 *
	 * 관리자 기능에서 채우고 기사 화면(verify.jsp)에서 읽기만 한다.
	 * 내 쪽에서 값을 쓰는 곳은 재신청 시 NULL 로 비우는 것 하나뿐인데,
	 * 그건 updateFixerProfile 의 SQL 에 리터럴로 박혀 있어서 이 필드를 안 쓴다.
	 *
	 * 거절된 적이 없거나 관리자가 사유를 안 적었으면 null 이다.
	 * 그래서 화면에서 반드시 empty 검사를 하고 출력한다.
	 */
	private String rejectReason;    // REJECT_REASON
	// ---- 조인해서 가져오는 값 (고객이 보는 프로필 화면 전용) ----
	private String fixerName;   // USERS.NAME
	private Double avgScore;    // REVIEW 평균 점수 (리뷰 없으면 null)
	private Long   reviewCount; // REVIEW 건수
	 
}