package com.surit.fixer.estimate.model.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.surit.fixer.estimate.model.dto.EstimateDTO;

@Mapper
public interface EstimateMapper {

	/**
	 * 견적 등록.
	 *
	 * "접수가 아직 열려 있는가", "내가 이미 냈는가" 를 자바에서 if 로 검사하고
	 * INSERT 하면, 검사와 INSERT 사이에 다른 요청이 끼어들 수 있다(TOCTOU).
	 * 그래서 조건을 SQL 의 WHERE 에 넣고, 결과가 0건인지로 판단한다.
	 *
	 * @return 1 이면 성공, 0 이면 조건에 안 맞아서 안 들어감
	 */
	int insertEstimate(EstimateDTO estimate);

	/** 내가 이 접수에 이미 견적을 냈는지 */

	int countMyEstimate(@Param("requestId") Long requestId,
	                    @Param("fixerNo") Long fixerNo);


	/** 접수 상태를 '접수대기(REQ_01)' → '견적중(REQ_02)' 로 */
	int updateRequestToEstimating(@Param("requestId") Long requestId);

	/** 내가 낸 견적 목록 */

	List<EstimateDTO> selectMyEstimates(@Param("fixerNo") Long fixerNo);

}
