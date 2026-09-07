package com.surit.chat.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

import com.surit.chat.dto.ChatRoomDTO;
import com.surit.chat.service.ChatService;
import com.surit.chat.util.ChatLoginResolver;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class ChatController {

	private final ChatService chatService;

	/** 이 키로 세션에 담아두면 WebSocket 핸드셰이크 때 그대로 넘어간다 */
	public static final String CHAT_USER_NO = "CHAT_USER_NO";


	/**
	 * 헤더의 [채팅] 메뉴가 오는 곳.
	 * GET /chat
	 *
	 * 채팅은 "방"이 있어야 열리는데 이 주소에는 방 번호가 없다.
	 * 그래서 내 채팅방 중 가장 최근 것으로 돌려보낸다.
	 *
	 * ★ 직접 화면을 그리지 않고 redirect 하는 이유
	 *   각 방의 진짜 주소(/orders/{id}/chat, /user/mypage/support/{id})로 보내면
	 *   거기서 하는 권한 검사와 session.setAttribute(CHAT_USER_NO, ...) 가
	 *   그대로 실행된다. 여기서 화면을 직접 그리면 그 두 가지를 또 짜야 하고,
	 *   특히 세션 심는 걸 빠뜨리면 화면은 뜨는데 메시지가 안 나간다.
	 *   주소창에도 지금 보고 있는 방이 남아서 새로고침·즐겨찾기가 정상 동작한다.
	 */
	@GetMapping("/chat")
	public String chatHome(HttpSession session, Model model) {

		Long myNo = ChatLoginResolver.resolveUserNo(session);

		if (myNo == null) {
			return "redirect:/user/login?redirectURL=/chat";
		}

		List<ChatRoomDTO> rooms = chatService.getMyRooms(myNo);

		// 목록은 ROOM_ID 내림차순이라 첫 번째가 가장 최근 방이다
		if (!rooms.isEmpty()) {
			ChatRoomDTO recent = rooms.get(0);

			// REQUEST_ID 가 있으면 기사와의 접수 채팅, 없으면 고객센터 문의방
			if (recent.getRequestId() != null) {
				return "redirect:/orders/" + recent.getRequestId() + "/chat";
			}
			return "redirect:/user/mypage/support/" + recent.getRoomId();
		}

		// 방이 하나도 없을 때 : 빈 화면 + 왼쪽 목록(수릿 문의하기 카드)만 보여준다
		model.addAttribute("myNo",      myNo);
		model.addAttribute("showSide",  true);
		model.addAttribute("sideRooms", rooms);
		model.addAttribute("backUrl",   "/user/mypage");
		model.addAttribute("backText",  "마이페이지로 돌아가기");
		model.addAttribute("msg",
				"아직 대화 중인 채팅이 없습니다. "
				+ "기사님이 배정되면 채팅이 열리고, "
				+ "왼쪽 [수릿 문의하기] 로 고객센터에 바로 물어볼 수 있습니다.");

		return "chat/chat";
	}

	/** 고객이 보는 채팅 주소 */
	@GetMapping("/orders/{requestId}/chat")
	public String chatPage(@PathVariable Long requestId,
	                       HttpSession session,
	                       Model model) {
		return renderChat(requestId, session, model, false);
	}

	/**
	 * 기사가 보는 채팅 주소. 2026-09-02 추가
	 *
	 * ★ redirect 를 안 쓰는 이유
	 *   redirect 하면 주소창이 /orders/13/chat 으로 바뀐다.
	 *   여기서 화면을 직접 그려야 /fixer/chat/13 이 그대로 남는다.
	 */
	@GetMapping("/fixer/chat/{requestId}")
	public String fixerChatPage(@PathVariable Long requestId,
	                            HttpSession session,
	                            Model model) {
		return renderChat(requestId, session, model, true);
	}

	/**
	 * 채팅 화면 본체. 위 두 주소가 같이 쓴다.
	 * 화면과 권한 검사가 똑같으니 코드를 두 벌 만들지 않는다.
	 *
	 * @param fixerView true 면 헤더와 돌아가기 버튼이 기사용
	 */
	private String renderChat(Long requestId, HttpSession session,
	                          Model model, boolean fixerView) {

		// 로그인 후 되돌아올 주소도 들어온 입구에 맞춘다
		String myUrl = fixerView
				? "/fixer/chat/" + requestId
				: "/orders/" + requestId + "/chat";

		model.addAttribute("requestId", requestId);

		Long myNo = ChatLoginResolver.resolveUserNo(session);

		if (myNo == null) {
			return "redirect:/user/login?redirectURL=" + myUrl;
		}

		// ★ 헤더를 기사용으로 고정하는 신호. header.jsp 가 이 값을 같이 본다.
		//   세션의 USER_ROLE 값이 꼬여 있어도 기사 화면은 기사로 유지된다.
		model.addAttribute("fixerView", fixerView);

		model.addAttribute("showSide",  true);
		model.addAttribute("sideRooms", chatService.getMyRooms(myNo));

		// 방을 읽기 전 기본값. 방을 읽고 나면 아래에서 다시 덮어쓴다.
		model.addAttribute("backUrl",  fixerView ? "/fixer/jobs" : "/user/mypage");
		model.addAttribute("backText", fixerView ? "내 작업으로 돌아가기"
		                                         : "마이페이지로 돌아가기");

		ChatRoomDTO room = chatService.getOrCreateRoomByRequest(requestId);

		if (room == null) {
			model.addAttribute("msg",
					"채팅방이 없습니다. 접수번호 " + requestId
					+ " 에 배정된 기사가 있는지 확인하세요. (ESTIMATES.STATUS='SELECTED')");
			model.addAttribute("myNo", myNo);
			return "chat/chat";
		}

		// ★ 남의 방 훔쳐보기 차단
		if (!chatService.canAccess(room.getRoomId(), myNo)) {
			model.addAttribute("msg",
					"이 채팅방에 참여할 권한이 없습니다. (내 번호 " + myNo
					+ " / 방 고객 " + room.getUserNo()
					+ " / 방 기사 " + room.getFixerNo() + ")");
			model.addAttribute("myNo", myNo);
			return "chat/chat";
		}

		// 이 방에서 내가 기사인지는 USER_ROLE 이 아니라 방이 알고 있다
		boolean iAmFixer = myNo.equals(room.getFixerNo());

		model.addAttribute("iAmFixer", iAmFixer);
		model.addAttribute("backUrl",  iAmFixer
				? "/fixer/jobs/" + requestId : "/user/mypage");
		model.addAttribute("backText", iAmFixer
				? "작업 상세로 돌아가기" : "마이페이지로 돌아가기");

		// WebSocket 이 "누가 보냈는지" 판단할 근거
		session.setAttribute(CHAT_USER_NO, myNo);

		chatService.markAsRead(room.getRoomId(), myNo);

		model.addAttribute("room",    room);
		model.addAttribute("myNo",    myNo);
		model.addAttribute("history", chatService.getHistory(room.getRoomId()));

		return "chat/chat";
	}
	
	/**
	 * 고객센터 [1:1 문의하기] 버튼이 오는 곳.
	 * GET /support/chat
	 *
	 * 열려있는 문의방이 있으면 그 방으로, 없으면 새로 만들어서 이동시킨다.
	 */
	@GetMapping("/support/chat")
	public String supportChat(HttpSession session) {

	    Long myNo = ChatLoginResolver.resolveUserNo(session);

	    if (myNo == null) {
	        return "redirect:/user/login?redirectURL=/support/chat";
	    }

	    Long roomId = chatService.getOrCreateSupportRoom(myNo);

	    return "redirect:/user/mypage/support/" + roomId;
	}
}
