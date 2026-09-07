package com.surit.common.request.service;

import java.io.IOException;
import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import com.surit.common.model.dto.CommonCodeDTO;
import com.surit.common.request.model.dto.RequestDTO;
import com.surit.fixer.estimate.model.dto.EstimateDTO;

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

public interface RequestService {

	/** 검색 화면의 분야 셀렉트 박스 */
	List<CommonCodeDTO> getCategoryList();
	List<CommonCodeDTO> getVisitTimeList();

	/** 내 주변 새 접수 목록 */
	List<RequestDTO> getNearbyRequests(Long userNo, String categoryCode, String keyword);

	/** 접수 상세 (볼 수 없는 접수면 예외) */

	RequestDTO getRequestDetail(Long userNo, Long requestId);
	List<RequestDTO> getRequestsByUserId(Long userNo);

	 

	/**
	 * 매칭 화면용 접수 정보 조회 (내 접수가 맞는지 확인 포함)
	*/
	RequestDTO getRequestForMatching(Long userNo, Long requestId);
	 
	/** 특정 접수에 들어온 견적 목록 */
	List<EstimateDTO> getEstimatesForMatching(Long requestId);
	 
	/**
	 * 견적(기사) 선택 확정.
	 * 접수 상태를 매칭완료(REQ_03)로 바꾸고, 선택된 견적을 표시한다.
	 */
	void selectEstimate(Long userNo, Long requestId, Long estimateId);
	



/**
 * 접수 상세 조회 (고객용, 매칭완료 이후 단계).
 * 내 접수가 아니면 예외.
 */
RequestDTO getRequestDetailForCustomer(Long userNo, Long requestId);
 
/** 이 접수에서 선택 확정된 견적 (없으면 null) */
EstimateDTO getSelectedEstimate(Long requestId);

	
	/** 고객 기능 — 접수 수정 */
	void updateRequest(Long userNo, RequestDTO request);

	/** 고객 기능 — 접수 취소 */
	void cancelRequest(Long userNo, Long requestId);

	/** 고객 기능 — 접수 등록 */
void createRequest(RequestDTO request, List<MultipartFile> photoFiles) throws IOException;

}

