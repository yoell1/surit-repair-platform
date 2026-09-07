package com.surit.admin.scheduler;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.surit.admin.service.BlacklistManagementService;

import lombok.RequiredArgsConstructor;

/**
 * 정지 기간이 끝난 계정을 자동으로 되살린다.
 * 서버가 꺼져 있던 동안 만료된 건도 다음 기동 때 한 번에 처리된다.
 */
@Component
@RequiredArgsConstructor
public class SanctionScheduler {

	private static final Logger log = LoggerFactory.getLogger(SanctionScheduler.class);

	private final BlacklistManagementService blacklistService;

	// 서버 시작 10초 후 1회, 그다음부터 1시간마다
	@Scheduled(initialDelay = 10_000, fixedDelay = 3_600_000)
	public void releaseExpired() {
		int count = blacklistService.syncExpired();
		if (count > 0) {
			log.info("[제재] 기간 만료로 {}명 정지 해제", count);
		}
	}
}