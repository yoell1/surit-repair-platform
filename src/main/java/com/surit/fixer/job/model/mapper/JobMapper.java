package com.surit.fixer.job.model.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.surit.fixer.job.model.dto.JobDTO;

@Mapper
public interface JobMapper {

	/**
	 * 내 작업 목록.
	 *
	 * @param statusCode 상태 필터 (없으면 null → 전체)
	 */

	List<JobDTO> selectMyJobs(@Param("fixerNo") Long fixerNo,
	                          @Param("statusCode") String statusCode);

	/** 내 작업 상세 (내 작업이 아니면 null) */
	JobDTO selectMyJob(@Param("fixerNo") Long fixerNo,
	                   @Param("requestId") Long requestId);


	/**
	 * 수리 완료 처리 (REQ_03 → REQ_04).
	 *
	 * "내 작업이 맞는가", "아직 REQ_03 인가" 를 자바에서 검사하고 UPDATE 하면
	 * 그 사이에 상태가 바뀔 수 있다. 조건을 전부 WHERE 에 넣고
	 * 반환값이 0인지로 판단한다.
	 *
	 * @return 1 이면 성공, 0 이면 조건 불일치
	 */

	Long completeJob(@Param("fixerNo") Long fixerNo,
	                @Param("requestId") Long requestId);

}
