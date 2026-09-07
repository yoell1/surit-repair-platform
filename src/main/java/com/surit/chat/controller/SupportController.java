package com.surit.chat.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.surit.chat.dto.ChatRoomDTO;
import com.surit.chat.service.ChatService;
import com.surit.user.model.dto.UserDTO;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;

/**
 * F-26 고객센터 1:1 문의 (고객 쪽 화면)
 *
 * 마이페이지 안에 들어가는 메뉴라서 주소를 /user/mypage/support 로 맞췄다.
 *
 *   GET  /user/mypage/support           FAQ + 내 문의 내역
 *   POST /user/mypage/support/new       [1:1 문의하기] → 방 찾거나 만들고 채팅방으로
 *   GET  /user/mypage/support/{roomId}  문의 채팅방
 *
 * ★ 예전의 testUserNo 뒷문은 없앴다. 로그인 세션(loginMember)만 본다.
 */
@Controller
@RequestMapping("/user/mypage/support")
@RequiredArgsConstructor
public class SupportController {

	private final ChatService chatService;

	/** UserController 가 로그인 성공 시 세션에 담는 키 */
	private static final String LOGIN_KEY = "loginMember";

	/** 로그인한 사람의 USER_NO. 로그인 안 했으면 null */
	private Long loginUserNo(HttpSession session) {
		Object value = session.getAttribute(LOGIN_KEY);
		if (value instanceof UserDTO) {
			return ((UserDTO) value).getUserNo();
		}
		return null;
	}

	/**
	 * 고객센터 화면 (FAQ + 내 문의 내역)
	 * GET /user/mypage/support
	 */
	@GetMapping
	public String support(HttpSession session, Model model) {

		Long myNo = loginUserNo(session);
		if (myNo == null) {
			return "redirect:/user/login?redirectURL=/user/mypage/support";
		}

		model.addAttribute("user",  session.getAttribute(LOGIN_KEY));
		model.addAttribute("rooms", chatService.getMySupportRooms(myNo));

		return "user/support";
	}

	/**
	 * [1:1 문의하기] 버튼
	 * POST /user/mypage/support/new
	 *
	 * 진행중인 문의가 있으면 그 방으로, 없으면 새로 만들어서 들어간다.
	 * GET 이 아니라 POST 인 이유 : 방을 "만드는" 동작이라
	 * 새로고침·뒤로가기로 중복 실행되면 안 되기 때문.
	 */
	@PostMapping("/new")
	public String startInquiry(HttpSession session) {

		Long myNo = loginUserNo(session);
		if (myNo == null) {
			return "redirect:/user/login?redirectURL=/user/mypage/support";
		}

		Long roomId = chatService.getOrCreateSupportRoom(myNo);

		return "redirect:/user/mypage/support/" + roomId;
	}

	/**
	 * 문의 채팅방
	 * GET /user/mypage/support/{roomId}
	 *
	 * {roomId:[0-9]+} 로 숫자만 받는다.
	 * 안 그러면 /support/new 같은 글자 주소까지 여기로 들어와서 400 에러가 난다.
	 */
	@GetMapping("/{roomId:[0-9]+}")
	public String room(@PathVariable Long roomId, HttpSession session, Model model) {

		Long myNo = loginUserNo(session);
		if (myNo == null) {
			return "redirect:/user/login?redirectURL=/user/mypage/support";
		}

		model.addAttribute("backUrl",  "/user/mypage/support");
		model.addAttribute("backText", "고객센터로 돌아가기");

		// ★ 화면 왼쪽 채팅방 목록 (고객센터 문의방 + 기사와의 접수 채팅이 같이 나온다)
		model.addAttribute("showSide",  true);
		model.addAttribute("sideRooms", chatService.getMyRooms(myNo));

		ChatRoomDTO room = chatService.getRoom(roomId);

		// REQUEST_ID 가 있으면 접수 채팅방이다. 문의방이 아니므로 막는다.
		if (room == null || room.getRequestId() != null) {
			model.addAttribute("msg", "문의방을 찾을 수 없습니다.");
			return "chat/chat";
		}

		if (!chatService.canAccess(roomId, myNo)) {
			model.addAttribute("msg", "이 문의에 접근할 권한이 없습니다.");
			return "chat/chat";
		}

		// ★ WebSocket 이 "누가 보냈는지" 판단할 근거. 이게 없으면 메시지가 안 나간다.
		session.setAttribute(ChatController.CHAT_USER_NO, myNo);

		chatService.markAsRead(roomId, myNo);

		model.addAttribute("room",      room);
		model.addAttribute("myNo",      myNo);
		model.addAttribute("history",   chatService.getHistory(roomId));
		model.addAttribute("roomTitle", "수릿 고객센터");
		model.addAttribute("roomSub",   "1:1 문의"
				+ (room.getCategoryName() == null ? "" : " · " + room.getCategoryName()));

		return "chat/chat";
	}
}
