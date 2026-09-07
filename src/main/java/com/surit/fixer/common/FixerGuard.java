package com.surit.fixer.common;

import org.springframework.stereotype.Component;

import com.surit.fixer.verify.model.dto.FixerProfileDTO;
import com.surit.fixer.verify.model.mapper.FixerMapper;

import lombok.RequiredArgsConstructor;

/**
 * 기사 자격 검사를 한 곳에서 담당한다.
 * F-15 · F-16 · F-17 이 모두 이 검사를 필요로 하는데,
 * 각자 복사해두면 규칙이 바뀔 때 한 곳을 빠뜨리기 쉽다.
 */
@Component
@RequiredArgsConstructor
public class FixerGuard {

	public static final String PENDING  = "PENDING";   // 심사 대기
	public static final String APPROVED = "APPROVED";  // 승인 완료 — 이 값만 통과
	public static final String REJECTED = "REJECTED";  // 거절 (재신청 가능)

	private final FixerMapper fixerMapper;

	/** 승인된 기사가 아니면 예외를 던진다 */
	public void requireApprovedFixer(Long userNo) {


		FixerProfileDTO profile = fixerMapper.selectFixerProfile(userNo);

		if (profile == null) {
			throw new IllegalStateException("기사 인증 신청을 먼저 해주세요.");
		}
		if (!APPROVED.equals(profile.getApprovalStatus())) {
			throw new IllegalStateException(
					"기사 인증이 완료된 후 이용할 수 있습니다. (현재 상태: "
					+ profile.getApprovalStatus() + ")");
		}

		// 정지(SANCTION) 검사 같은 게 생기면 여기 한 줄만 추가하면
		// 세 기능에 동시에 적용된다
	}
}
