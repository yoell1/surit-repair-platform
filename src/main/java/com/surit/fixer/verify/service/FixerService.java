package com.surit.fixer.verify.service;

import java.io.IOException;
import java.util.List;

import com.surit.common.model.dto.CommonCodeDTO;
import com.surit.fixer.verify.model.dto.FixerProfileDTO;
import com.surit.fixer.verify.model.dto.FixerVerifyRequest;

/*
 * ─── 숫자 타입 규칙 ──────────────────────────────────────────
 *  · DTO 필드 : Long (참조형)
 *      DB 의 NULL 을 null 로 받아야 "값 없음" 과 "0" 이 구분된다.
 *
 *  · 메서드 파라미터 : Long
 *      UserDTO.getUserNo() 가 Long 이라 그대로 넘긴다.
 *      호출 지점에서 세션 null 검사를 먼저 하므로 여기선 null 이 아니다.
 * ────────────────────────────────────────────────────────────
 */
public interface FixerService {

	/** 신청 화면의 '수리 분야' 체크박스 목록 */
	List<CommonCodeDTO> getCategoryList();

	/** 신청 화면의 '활동 지역' 체크박스 목록 */
	List<CommonCodeDTO> getRegionList();

	/** 내 신청 상태 (없으면 null) */
	FixerProfileDTO getMyProfile(Long userNo);

	/** 기사 인증 신청 (신규 / 재신청) */
	void applyVerify(Long userNo, FixerVerifyRequest request) throws IOException;

	/** 내가 등록한 활동 지역 이름 (없으면 빈 목록) */
	List<String> getMyRegionNames(Long userNo);

	/** 내가 등록한 수리 분야 이름 (없으면 빈 목록) */
	List<String> getMyCategoryNames(Long userNo);
}
