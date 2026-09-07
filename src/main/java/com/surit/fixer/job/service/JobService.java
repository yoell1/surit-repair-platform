package com.surit.fixer.job.service;

import java.util.List;

import com.surit.fixer.job.model.dto.JobDTO;

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

public interface JobService {

	JobDTO getMyJob(Long fixerNo, Long requestId);

	/** 수리 완료 처리 */
	void complete(Long fixerNo, Long requestId);


	List<JobDTO> getMyJobs(Long fixerNo, String statusCode);



}
