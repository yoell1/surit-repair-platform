package com.surit.chat.service;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.surit.chat.dto.ChatMessageDTO;
import com.surit.chat.dto.ChatRoomDTO;
import com.surit.chat.dto.CodeDTO;
import com.surit.chat.mapper.ChatMapper;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class ChatServiceImpl implements ChatService {

	private final ChatMapper chatMapper;

	private static final DateTimeFormatter FMT =
			DateTimeFormatter.ofPattern("MM-dd HH:mm");
	private static final int RECENT_LIMIT = 30;

	/* ══════════ 고객 ↔ 기사 ══════════ */

	@Override
	@Transactional
	public ChatRoomDTO getOrCreateRoomByRequest(Long requestId) {

		ChatRoomDTO room = chatMapper.selectRoomByRequestId(requestId);
		if (room != null) {
			return room;
		}

		ChatRoomDTO seed = chatMapper.selectRoomSeedByRequest(requestId);
		if (seed == null || seed.getFixerNo() == null) {
			return null;                       // 접수건이 없거나 아직 기사 미배정
		}

		chatMapper.insertRoom(seed);
		return chatMapper.selectRoomByRequestId(requestId);
	}

	@Override
	public ChatRoomDTO getRoom(Long roomId) {
		return chatMapper.selectRoomById(roomId);
	}

	@Override
	public boolean canAccess(Long roomId, Long userNo) {
		if (roomId == null || userNo == null) {
			return false;
		}
		ChatRoomDTO room = chatMapper.selectRoomById(roomId);
		if (room == null) {
			return false;
		}
		// 방의 당사자 두 명
		if (userNo.equals(room.getUserNo()) || userNo.equals(room.getFixerNo())) {
			return true;
		}
		// 문의(SUPPORT) 방이면 고객센터 계정도 참여할 수 있다
		if (room.getRequestId() == null) {
			Long supportNo = chatMapper.selectSupportUserNo();
			return supportNo != null && supportNo.equals(userNo);
		}
		return false;
	}

	@Override
	public List<ChatRoomDTO> getMyRooms(Long userNo) {
		return chatMapper.selectRoomsByUserNo(userNo);
	}

	/* ══════════ 문의 (F-26) ══════════ */

	@Override
	public Long getSupportUserNo() {
		return chatMapper.selectSupportUserNo();
	}

	@Override
	public List<CodeDTO> getInquiryTypes() {
		return chatMapper.selectInquiryTypes();
	}

	@Override
	public List<ChatRoomDTO> getMySupportRooms(Long userNo) {
		return chatMapper.selectMySupportRooms(userNo);
	}

	@Override
	public List<ChatRoomDTO> getSupportRooms(String filter, Long supportNo) {
		return chatMapper.selectAllSupportRooms(supportNo, filter);
	}

	@Override
	@Transactional
	public Long createSupportRoom(Long userNo, String categoryCode) {
		ChatRoomDTO room = new ChatRoomDTO();
		room.setRequestId(null);        // ★ NULL 이 곧 "문의방" 표시
		room.setUserNo(userNo);
		room.setFixerNo(null);
		room.setCategoryCode(categoryCode);

		chatMapper.insertRoom(room);
		return chatMapper.selectLatestSupportRoomId(userNo);
	}

	/**
	 * 마이페이지 > 고객센터 > [1:1 문의하기] 가 부르는 메서드.
	 *
	 * selectLatestSupportRoomId 는 내 문의방 중 가장 최근 것(MAX(ROOM_ID))을 준다.
	 * 없으면 NULL 이 오므로, 그때만 새로 만든다.
	 */
	@Override
	@Transactional
	public Long getOrCreateSupportRoom(Long userNo) {

		Long roomId = chatMapper.selectLatestSupportRoomId(userNo);
		if (roomId != null) {
			return roomId;                       // 진행중인 문의가 있으면 이어서
		}
		return createSupportRoom(userNo, null);  // 유형은 아직 안 정함 → NULL
	}

	/* ══════════ 메시지 공통 ══════════ */

	@Override
	public List<ChatMessageDTO> getHistory(Long roomId) {
		return chatMapper.selectRecentMessages(roomId, RECENT_LIMIT);
	}

	@Override
	@Transactional
	public void saveMessage(ChatMessageDTO message) {
		if (message.getMessageType() == null) {
			message.setMessageType("TEXT");
		}
		chatMapper.insertMessage(message);
		message.setSenderName(chatMapper.selectUserName(message.getSenderNo()));
		message.setSentAt(LocalDateTime.now().format(FMT));
	}

	@Override
	@Transactional
	public void markAsRead(Long roomId, Long readerNo) {
		chatMapper.markAsRead(roomId, readerNo);
	}
}