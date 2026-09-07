package com.surit.common.request.model.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.surit.common.request.model.dto.RequestDTO;
import com.surit.common.request.model.dto.RequestPhotoDTO;
import com.surit.fixer.estimate.model.dto.EstimateDTO;

@Mapper
public interface RequestMapper {

	/**
	 * 내 주변 새 접수 목록.
	 *
	 * 파라미터가 2개 이상이면 MyBatis 가 이름을 못 알아내서
	 * XML 에서 #{param1} 같은 이름밖에 못 쓴다. 그래서 @Param 을 붙인다.
	 *
	 * @param userNo       로그인한 기사의 USER_NO
	 * @param categoryCode 분야 필터 (없으면 null)
	 * @param keyword      제목/내용 검색어 (없으면 null)
	 */
	List<RequestDTO> selectNearbyRequests(@Param("userNo") Long userNo,
	                                      @Param("categoryCode") String categoryCode,
	                                      @Param("keyword") String keyword);

	/**
	 * 접수 상세.
	 *
	 * userNo 를 같이 넘기는 이유 :
	 * 목록에서 안 보이는 접수라도 주소창에 /fixer/requests/999 라고 치면
	 * 남의 접수 내용이 다 보일 수 있다. 그래서 상세 SQL 에도 목록과 똑같은
	 * "볼 수 있는 조건" 을 붙이고, 조건에 안 맞으면 null 이 돌아오게 한다.
	 */
	RequestDTO selectRequestDetail(@Param("userNo") Long userNo,
	                               @Param("requestId") Long requestId);

	/** 접수에 딸린 사진 목록 */
	List<RequestPhotoDTO> selectPhotos(@Param("requestId") Long requestId);

	/** 고객 기능 — 내가 올린 접수 목록 */
	List<RequestDTO> findByUserId(@Param("userId") Long userNo);

	/** 고객 기능 — 접수 등록 */
	Long insertRequest(RequestDTO request);

	/** 고객 기준 접수 단건 조회 (내 접수가 아니면 null) */
	RequestDTO selectRequestForCustomer(@Param("userNo") Long userNo,
	                                     @Param("requestId") Long requestId);

	/** 특정 접수에 들어온 견적 목록 (기사 정보 포함) */
	List<EstimateDTO> selectEstimatesByRequestId(@Param("requestId") Long requestId);

	/** 접수 상태 코드 변경 */
	Long updateRequestStatus(@Param("requestId") Long requestId,
	                         @Param("statusCode") String statusCode);

	/**
	 * 견적 상태 변경.
	 * 선택된 견적은 STATUS = 'SELECTED' 로 바꾼다.
	 * (EstimateDTO.status 는 PENDING / SELECTED 두 값만 존재)
	 */
	Long updateSelectedEstimate(@Param("requestId") Long requestId,
	                            @Param("estimateId") Long estimateId);


    /** 고객 접수 수정 */
    Long updateCustomerRequest(RequestDTO request);

    /** 고객 접수 취소 */
    Long cancelCustomerRequest(
        @Param("requestId") Long requestId,
        @Param("userNo") Long userNo,
        @Param("statusCode") String statusCode
);

	EstimateDTO selectSelectedEstimateByRequestId(@Param("requestId") Long requestId);
	/** 접수 사진 한 장 저장 */
	int insertPhoto(RequestPhotoDTO photo);

}