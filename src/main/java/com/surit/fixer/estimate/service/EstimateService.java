package com.surit.fixer.estimate.service;

import java.util.List;

import com.surit.common.request.model.dto.RequestDTO;
import com.surit.fixer.estimate.model.dto.EstimateDTO;
import com.surit.fixer.estimate.model.dto.EstimateForm;

/*
 * ─── 숫자 타입 규칙 ──────────────────────────────────────────
 *  · DTO 필드 : Long (참조형)
 *      DB 의 NULL 을 null 로 받아야 "값 없음" 과 "0" 이 구분된다.
 *
 *  · 메서드 파라미터 : long (원시형)
 *      여기 들어오는 번호는 세션이나 URL 에서 오는 값이라 null 일 수 없다.
 *      원시형으로 두면 그 사실이 타입으로 보장되고, 서비스 안에서
 *      실수로 null 검사를 빠뜨릴 여지가 사라진다.
 *      호출부에서 UserDTO.getUserNo() (Long) 가 언박싱되어 전달된다.
 * ────────────────────────────────────────────────────────────
 */
public interface EstimateService {

	/** 견적 작성 화면에 띄울 접수 정보 (볼 수 없는 접수면 예외) */
	RequestDTO getTargetRequest(long fixerNo, long requestId);

	/** 견적 제출 */
	void submit(long fixerNo, EstimateForm form);

	/** 내가 낸 견적 목록 */
	List<EstimateDTO> getMyEstimates(long fixerNo);
}