package com.surit.admin.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.surit.admin.model.dto.AdminSanctionListDTO;
import com.surit.admin.model.dto.AdminWarnTargetDTO;
import com.surit.admin.model.mapper.BlacklistManagementMapper;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class BlacklistManagementServiceImpl implements BlacklistManagementService {

	private final BlacklistManagementMapper blacklistMapper;

	@Override
	public List<AdminWarnTargetDTO> getWarnTargets(int minCount) {
		return blacklistMapper.selectWarnTargets(minCount);
	}

	@Override
	public List<AdminSanctionListDTO> getActiveSuspensions() {
		return blacklistMapper.selectActiveSuspensions();
	}

	@Override
	public List<AdminSanctionListDTO> getHistory() {
		return blacklistMapper.selectSanctionHistory();
	}

	@Override
	@Transactional
	public void suspend(Long targetNo, int days, String reason, String adminId) {

		boolean permanent = (days <= 0);

		// 1) 제재 이력 남기기 (이 테이블이 곧 감사로그다 — 누가·언제·왜)
		blacklistMapper.insertSanction(
				targetNo,
				permanent ? "PERMANENT" : "SUSPEND",
				reason,
				permanent ? null : Integer.valueOf(days),
				adminId);

		// 2) 계정 상태 바꾸기
		blacklistMapper.updateUserStatus(targetNo, "SUSPEND");
	}

	@Override
	@Transactional
	public void release(Long sanctionId) {
		// 1) 해당 제재를 해제 표시
		blacklistMapper.releaseSanction(sanctionId);
		// 2) 남아있는 다른 정지가 없으면 계정도 ACTIVE 로
		blacklistMapper.syncExpiredSuspensions();
	}

	@Override
	@Transactional
	public int syncExpired() {
		return blacklistMapper.syncExpiredSuspensions();
	}
}