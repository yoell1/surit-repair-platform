package com.surit.chat.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.surit.chat.dto.ChatMessageDTO;
import com.surit.chat.dto.ChatRoomDTO;
import com.surit.chat.dto.CodeDTO;

@Mapper
public interface ChatMapper {

	/* ── 채팅방 (고객 ↔ 기사) ───────────── */
	ChatRoomDTO selectRoomById(Long roomId);
	ChatRoomDTO selectRoomByRequestId(Long requestId);
	ChatRoomDTO selectRoomSeedByRequest(Long requestId);
	int insertRoom(ChatRoomDTO room);
	List<ChatRoomDTO> selectRoomsByUserNo(Long userNo);

	/* ── 문의방 (고객 ↔ 고객센터) ────────── */
	/** USER_ID='surit_support' 계정의 USER_NO. 없으면 null */
	Long selectSupportUserNo();
	List<CodeDTO> selectInquiryTypes();
	List<ChatRoomDTO> selectMySupportRooms(Long userNo);
	List<ChatRoomDTO> selectAllSupportRooms(@Param("supportNo") Long supportNo,
	                                        @Param("filter") String filter);
	Long selectLatestSupportRoomId(Long userNo);

	/* ── 메시지 ─────────────────────────── */
	List<ChatMessageDTO> selectMessages(Long roomId);
	/*최근 메세지 N개만 방에*/
	List<ChatMessageDTO> selectRecentMessages(@Param("roomId") Long roomId, @Param("limit")  int limit);
	int insertMessage(ChatMessageDTO message);
	int markAsRead(@Param("roomId") Long roomId, @Param("readerNo") Long readerNo);
	int countUnread(@Param("roomId") Long roomId, @Param("readerNo") Long readerNo);

	/* ── 보조 ───────────────────────────── */
	String selectUserName(Long userNo);
}