package com.surit.chat.dto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ChatMessageDTO {

	private Long   messageId;
	private Long   roomId;
	private Long   senderNo;
	private String messageType;   // TEXT / IMAGE
	private String content;
	private String filePath;

	// ★ 날짜를 String 으로 받는다.
	//   LocalDateTime 으로 두면 JSON이 [2026,8,28,14,30] 배열로 깨진다.
	private String sentAt;
	private String readAt;

	// 화면 표시용 (USERS 조인. CHAT_MESSAGE 컬럼 아님)
	private String senderName;
}