package com.surit.chat.dto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ChatRoomDTO {

	private Long   roomId;
	private Long   requestId;      // NULL 이면 문의(SUPPORT) 방
	private Long   userNo;
	private Long   fixerNo;        // 문의 방은 NULL
	private String categoryCode;
	private String createdAt;

	/* 화면 표시용 (조인·서브쿼리) */
	private String  userName;
	private String  fixerName;
	private String  requestTitle;
	private String  categoryName;   // COMMON_CODE.CODE_NAME
	private String  lastMessage;
	private Long    lastSenderNo;   // 마지막 메시지를 보낸 사람 (답변 대기 판단용)
	private String  lastSentAt;
	private Integer unreadCount;
	private Integer msgCount;
}