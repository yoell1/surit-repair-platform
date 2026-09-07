package com.surit.common.request.model.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

/**
 * 견적 수락(고객이 기사를 고르는 순간) 전용 Mapper.  2026-08-31
 *
 * ── 왜 RequestMapper 에 안 넣고 따로 뺐나 ──
 *   이 3문장은 반드시 세트로, 한 트랜잭션 안에서만 쓰인다.
 *   따로 모아두면 "이 3개는 같이 움직인다" 가 파일만 봐도 드러나고,
 *   나중에 누가 하나만 딴 데서 호출하는 사고를 줄일 수 있다.
 *
 * ── WHERE 절이 방어막이다 ──
 *   자바에서 "확인 후 UPDATE" 를 하면 그 사이에 값이 바뀔 수 있다.
 *   조건을 SQL 안에 넣으면 확인과 수정이 한 번에 일어나서 그 틈이 없다.
 *   조건에 안 맞으면 예외가 아니라 0건이 되므로,
 *   서비스에서 반환값이 1인지 확인해야 한다.
 */
@Mapper
public interface EstimateSelectMapper {

	/** 고른 견적을 SELECTED 로. 남의 접수 견적이거나 이미 처리됐으면 0 */
	int markEstimateSelected(@Param("requestId")  Long requestId,
	                         @Param("estimateId") Long estimateId);

	/** 같은 접수의 나머지 견적을 REJECTED 로. 견적이 하나뿐이면 0 (정상) */
	int rejectOtherEstimates(@Param("requestId")  Long requestId,
	                         @Param("estimateId") Long estimateId);

	/** 접수를 매칭완료(REQ_03)로. 이미 기사가 정해졌으면 0 */
	int updateRequestToMatched(@Param("userNo")    Long userNo,
	                           @Param("requestId") Long requestId);
}
