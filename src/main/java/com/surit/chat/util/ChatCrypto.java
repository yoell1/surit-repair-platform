package com.surit.chat.util;

import java.nio.charset.StandardCharsets;
import java.security.SecureRandom;
import java.util.Arrays;
import java.util.Base64;

import javax.crypto.Cipher;
import javax.crypto.SecretKey;
import javax.crypto.spec.GCMParameterSpec;
import javax.crypto.spec.SecretKeySpec;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import jakarta.annotation.PostConstruct;
import lombok.extern.slf4j.Slf4j;

/**
 * 채팅 메시지 암호화 (AES-256-GCM).
 *
 * ── 왜 GCM 인가 ──
 *   CBC 같은 방식은 "몰래 값을 바꿔치기" 하는 걸 못 막는다.
 *   GCM 은 암호화와 동시에 검증용 태그(16바이트)를 붙여서,
 *   DB에서 누가 한 글자라도 고치면 복호화 자체가 실패한다.
 *
 * ── 저장 형태 ──
 *   enc:v1:BASE64( IV(12바이트) + 암호문 + 검증태그(16바이트) )
 *
 *   앞에 "enc:v1:" 표시를 붙이는 이유 2가지
 *     1) 아직 암호화 안 된 예전 메시지를 구분할 수 있다 (그건 그대로 보여준다)
 *     2) 실수로 두 번 암호화하는 사고를 막는다
 *
 * ── IV 를 매번 새로 만드는 이유 ──
 *   같은 키 + 같은 IV 로 두 번 암호화하면 GCM 은 보안이 완전히 깨진다.
 *   그래서 메시지마다 난수 IV 를 만들어 암호문 앞에 같이 저장한다.
 *   (IV 는 비밀이 아니라서 같이 저장해도 된다)
 */
@Slf4j
@Component
public class ChatCrypto {

	/** 암호문임을 알리는 표시. 버전을 붙여둬서 나중에 알고리즘을 바꿔도 구분된다. */
	public static final String PREFIX = "enc:v1:";

	private static final int IV_LENGTH  = 12;   // GCM 권장 12바이트
	private static final int TAG_BITS   = 128;  // 검증 태그 16바이트
	private static final int MAX_STORED = 4000; // CHAT_MESSAGE.CONTENT VARCHAR2(4000)

	/** MyBatis TypeHandler 는 스프링 빈이 아니라서, 여기서 꺼내 쓰도록 해둔다. */
	private static ChatCrypto instance;

	private final SecretKey    key;
	private final SecureRandom random = new SecureRandom();

	public ChatCrypto(@Value("${surit.chat.crypto.key:}") String base64Key) {

		if (base64Key == null || base64Key.isBlank()) {
			throw new IllegalStateException(
					"application.properties 에 surit.chat.crypto.key 가 없습니다.\n"
					+ "PowerShell 에서 아래를 실행해 나온 44글자를 넣으세요.\n"
					+ "  $b=New-Object byte[] 32; "
					+ "[Security.Cryptography.RandomNumberGenerator]::Create().GetBytes($b); "
					+ "[Convert]::ToBase64String($b)");
		}

		byte[] raw;
		try {
			raw = Base64.getDecoder().decode(base64Key.trim());
		} catch (IllegalArgumentException e) {
			throw new IllegalStateException("surit.chat.crypto.key 가 Base64 형식이 아닙니다.", e);
		}
		if (raw.length != 32) {
			throw new IllegalStateException(
					"surit.chat.crypto.key 는 32바이트여야 합니다 (Base64 44글자). 현재 " + raw.length + "바이트");
		}
		this.key = new SecretKeySpec(raw, "AES");
	}

	@PostConstruct
	void register() {
		instance = this;
		log.info("[ChatCrypto] 채팅 메시지 암호화 준비 완료 (AES-256-GCM)");
	}

	public static ChatCrypto get() {
		if (instance == null) {
			throw new IllegalStateException("ChatCrypto 가 아직 준비되지 않았습니다.");
		}
		return instance;
	}

	/** 평문 -> 암호문. 이미 암호문이면 그대로 돌려준다. */
	public String encrypt(String plain) {

		if (plain == null || plain.isEmpty())  return plain;
		if (plain.startsWith(PREFIX))          return plain;   // 이중 암호화 방지

		try {
			byte[] iv = new byte[IV_LENGTH];
			random.nextBytes(iv);

			Cipher cipher = Cipher.getInstance("AES/GCM/NoPadding");
			cipher.init(Cipher.ENCRYPT_MODE, key, new GCMParameterSpec(TAG_BITS, iv));
			byte[] sealed = cipher.doFinal(plain.getBytes(StandardCharsets.UTF_8));

			byte[] packed = new byte[iv.length + sealed.length];
			System.arraycopy(iv,     0, packed, 0,          iv.length);
			System.arraycopy(sealed, 0, packed, iv.length,  sealed.length);

			String result = PREFIX + Base64.getEncoder().encodeToString(packed);

			if (result.length() > MAX_STORED) {
				throw new IllegalArgumentException(
						"메시지가 너무 깁니다. 암호화하면 " + result.length()
						+ "자가 되어 저장 한도(" + MAX_STORED + ")를 넘습니다.");
			}
			return result;

		} catch (IllegalArgumentException e) {
			throw e;
		} catch (Exception e) {
			throw new IllegalStateException("채팅 메시지 암호화 실패", e);
		}
	}

	/** 암호문 -> 평문. 표시가 없으면 예전 평문이므로 그대로 돌려준다. */
	public String decrypt(String stored) {

		if (stored == null || !stored.startsWith(PREFIX)) return stored;

		try {
			byte[] packed = Base64.getDecoder().decode(stored.substring(PREFIX.length()));
			byte[] iv     = Arrays.copyOfRange(packed, 0, IV_LENGTH);
			byte[] sealed = Arrays.copyOfRange(packed, IV_LENGTH, packed.length);

			Cipher cipher = Cipher.getInstance("AES/GCM/NoPadding");
			cipher.init(Cipher.DECRYPT_MODE, key, new GCMParameterSpec(TAG_BITS, iv));
			return new String(cipher.doFinal(sealed), StandardCharsets.UTF_8);

		} catch (Exception e) {
			// 키가 바뀌었거나 DB 값이 변조된 경우.
			// 여기서 예외를 던지면 채팅방 전체가 안 열리므로, 그 줄만 표시를 바꾼다.
			log.warn("[ChatCrypto] 복호화 실패 - 키가 바뀌었거나 값이 손상되었습니다");
			return "[복호화할 수 없는 메시지]";
		}
	}

	/** 저장했을 때 4000자를 넘지 않는지 미리 확인 (Service 검증용) */
	public boolean fitsInColumn(String plain) {
		if (plain == null) return true;
		int bytes = plain.getBytes(StandardCharsets.UTF_8).length;
		int encodedLen = PREFIX.length() + (((IV_LENGTH + bytes + 16) + 2) / 3) * 4;
		return encodedLen <= MAX_STORED;
	}
}
