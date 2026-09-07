package com.surit.chat.util;

import java.util.List;

import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.beans.factory.annotation.Value;

import com.surit.chat.dto.ChatMessageDTO;
import com.surit.chat.mapper.ChatCryptoMigrationMapper;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

/**
 * 이미 쌓여 있는 평문 채팅을 암호문으로 바꾸는 1회용 작업.
 *
 * 사용법
 *   1) application.properties 에서  surit.chat.crypto.migrate-on-start=true
 *   2) 서버 한 번 실행 -> 콘솔에서 변환 건수 확인
 *   3) 다시 false 로 되돌린다  ← 이거 꼭!
 *
 * 이미 암호화된 건 건드리지 않으므로, 실수로 두 번 돌려도 안전하다.
 */
@Slf4j
@Component
@RequiredArgsConstructor
public class ChatCryptoMigrationRunner implements ApplicationRunner {

	private final ChatCryptoMigrationMapper migrationMapper;
	private final ChatCrypto crypto;

	@Value("${surit.chat.crypto.migrate-on-start:false}")
	private boolean enabled;

	@Override
	@Transactional
	public void run(ApplicationArguments args) {

		if (!enabled) {
			return;
		}

		List<ChatMessageDTO> targets = migrationMapper.selectPlainMessages();

		log.info("════════════════════════════════════════════");
		log.info("[채팅 암호화] 평문 메시지 {}건을 변환합니다", targets.size());

		int done = 0, skipped = 0;

		for (ChatMessageDTO m : targets) {
			try {
				String encrypted = crypto.encrypt(m.getContent());
				migrationMapper.updateContent(m.getMessageId(), encrypted);
				done++;
			} catch (Exception e) {
				skipped++;
				log.warn("[채팅 암호화] MESSAGE_ID={} 변환 실패 : {}", m.getMessageId(), e.getMessage());
			}
		}

		log.info("[채팅 암호화] 완료 - 변환 {}건 / 실패 {}건", done, skipped);
		log.info("[채팅 암호화] ★ application.properties 의 migrate-on-start 를 false 로 되돌리세요");
		log.info("════════════════════════════════════════════");
	}
}
