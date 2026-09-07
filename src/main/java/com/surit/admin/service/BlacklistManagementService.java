package com.surit.admin.service;

import java.util.List;

import com.surit.admin.model.dto.AdminSanctionListDTO;
import com.surit.admin.model.dto.AdminWarnTargetDTO;

public interface BlacklistManagementService {

	List<AdminWarnTargetDTO> getWarnTargets(int minCount);
	List<AdminSanctionListDTO> getActiveSuspensions();
	List<AdminSanctionListDTO> getHistory();

	/** days 가 0 이하이면 영구 정지 */
	void suspend(Long targetNo, int days, String reason, String adminId);

	void release(Long sanctionId);

	/** 기간 만료된 정지를 ACTIVE 로 되돌린다. 처리된 인원 수 반환 */
	int syncExpired();
}