package com.surit.chat.controller;

import java.util.Map;

import org.springframework.messaging.handler.annotation.DestinationVariable;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.simp.SimpMessageHeaderAccessor;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;

import com.surit.chat.dto.ChatMessageDTO;
import com.surit.chat.service.ChatService;

import lombok.RequiredArgsConstructor;

/**
 * 브라우저가 /pub/chat/12 로 보내면 → 여기서 받고 → /sub/chat/room/12 로 뿌린다.
 *
 * ★ @DestinationVariable 은 @MessageMapping 경로에서만 값을 뽑는다.
 *   @SendTo 쪽에 {roomId} 를 두고 꺼내려 하면 실행 중 예외가 난다.
 */
@Controller
@RequiredArgsConstructor
public class ChatStompController {

	private final ChatService chatService;
	private final SimpMessagingTemplate messagingTemplate;

	private static final int MAX_LENGTH = 1000;

	@MessageMapping("/chat/{roomId}")
	public void send(@DestinationVariable Long roomId,
	                 @Payload ChatMessageDTO payload,
	                 SimpMessageHeaderAccessor accessor) {

		// 1) 보낸 사람은 세션에서 꺼낸다 (브라우저가 보낸 값은 믿지 않는다)
		Map<String, Object> attrs = accessor.getSessionAttributes();
		if (attrs == null) {
			return;
		}
		Object raw = attrs.get(ChatController.CHAT_USER_NO);
		if (!(raw instanceof Number)) {
			return;                                // 비로그인 → 무시
		}
		Long senderNo = ((Number) raw).longValue();

		// 2) 이 방 사람이 맞는지 확인
		if (!chatService.canAccess(roomId, senderNo)) {
			return;
		}

		// 3) 내용 검증
		String content = payload.getContent();
		if (content == null || content.trim().isEmpty()) {
			return;
		}
		content = content.trim();
		if (content.length() > MAX_LENGTH) {
			content = content.substring(0, MAX_LENGTH);
		}

		// 4) 저장
		ChatMessageDTO message = new ChatMessageDTO();
		message.setRoomId(roomId);
		message.setSenderNo(senderNo);
		message.setMessageType("TEXT");
		message.setContent(content);

		chatService.saveMessage(message);           // senderName / sentAt 채워짐

		// 5) 같은 방 구독자 전원에게 전달
		messagingTemplate.convertAndSend("/sub/chat/room/" + roomId, message);
	}
}