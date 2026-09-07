package com.surit.chat.service;

import java.util.List;

import com.surit.chat.dto.ChatMessageDTO;
import com.surit.chat.dto.ChatRoomDTO;
import com.surit.chat.dto.CodeDTO;

public interface ChatService {

	/* 고객 ↔ 기사 */
	ChatRoomDTO getOrCreateRoomByRequest(Long requestId);
	ChatRoomDTO getRoom(Long roomId);
	boolean canAccess(Long roomId, Long userNo);
	List<ChatRoomDTO> getMyRooms(Long userNo);

	/* 고객 ↔ 고객센터 (F-26 문의) */
	Long getSupportUserNo();
	List<CodeDTO> getInquiryTypes();
	List<ChatRoomDTO> getMySupportRooms(Long userNo);
	List<ChatRoomDTO> getSupportRooms(String filter, Long supportNo);
	Long createSupportRoom(Long userNo, String categoryCode);

	/**
	 * [1:1 문의하기] 버튼용.
	 * 이미 열어둔 문의방이 있으면 그 방 번호를, 없으면 새로 만들어서 돌려준다.
	 * → 버튼을 여러 번 눌러도 방이 무한정 늘어나지 않는다.
	 */
	Long getOrCreateSupportRoom(Long userNo);

	/* 메시지 공통 */
	List<ChatMessageDTO> getHistory(Long roomId);
	void saveMessage(ChatMessageDTO message);
	void markAsRead(Long roomId, Long readerNo);
}