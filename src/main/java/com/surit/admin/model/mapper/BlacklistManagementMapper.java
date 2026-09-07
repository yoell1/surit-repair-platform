package com.surit.admin.model.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.surit.admin.model.dto.AdminSanctionListDTO;
import com.surit.admin.model.dto.AdminWarnTargetDTO;

@Mapper
public interface BlacklistManagementMapper {

	/** 경고 minCount 회 이상 받은 사람 (정지 검토 후보) */
	List<AdminWarnTargetDTO> selectWarnTargets(@Param("minCount") int minCount);

	/** 지금 유효한 정지 목록 */
	List<AdminSanctionListDTO> selectActiveSuspensions();

	/** 제재 이력 전체 (최근 100건) */
	List<AdminSanctionListDTO> selectSanctionHistory();

	/** 특정 회원의 경고 횟수 */
	int countWarnings(@Param("targetNo") Long targetNo);

	/** 제재 등록. days 가 null 이면 END_AT = NULL (영구) */
	int insertSanction(@Param("targetNo") Long targetNo,
	                   @Param("sanctionType") String sanctionType,
	                   @Param("reason") String reason,
	                   @Param("days") Integer days,
	                   @Param("adminId") String adminId);

	/** 수동 해제 */
	int releaseSanction(@Param("sanctionId") Long sanctionId);

	int updateUserStatus(@Param("userNo") Long userNo, @Param("status") String status);

	/**
	 * ★ 핵심 규칙 하나로 자동 만료 + 수동 해제를 모두 처리한다.
	 *   "정지 상태인데 지금 유효한 정지가 하나도 없는 사람은 ACTIVE 로 되돌린다"
	 */
	int syncExpiredSuspensions();
}