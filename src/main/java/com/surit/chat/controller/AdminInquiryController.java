package com.surit.chat.controller;

import java.util.Collections;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import com.surit.chat.dto.ChatRoomDTO;
import com.surit.chat.service.ChatService;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;

/**
 * F-26 문의 응대 (관리자)
 * /admin/** 은 AdminInterceptor 가 로그인을 검사하므로 여기서 또 안 한다.
 */
@Controller
@RequestMapping("/admin/inquiries")
@RequiredArgsConstructor
public class AdminInquiryController {

	private final ChatService chatService;

	@GetMapping
	public String list(@RequestParam(required = false, defaultValue = "ALL") String filter,
	                   Model model) {

		Long supportNo = chatService.getSupportUserNo();

		model.addAttribute("filter",    filter);
		model.addAttribute("supportNo", supportNo);
		model.addAttribute("rooms", supportNo == null
				? Collections.emptyList()
				: chatService.getSupportRooms(filter, supportNo));

		return "admin/admin-inquiries";
	}

	@GetMapping("/{roomId}")
	public String detail(@PathVariable Long roomId, HttpSession session, Model model) {

		// ★ 관리자 화면에서는 고객용 헤더·푸터와 왼쪽 채팅목록을 빼고 대화창만 보여준다.
		//   대신 나갈 길이 없어지므로 돌아가기 버튼을 항상 달아준다.
		//   (아래 어느 경로로 빠지든 버튼이 보이도록 맨 위에서 담는다)
		model.addAttribute("adminView", true);
		model.addAttribute("backUrl",   "/admin/inquiries");
		model.addAttribute("backText",  "문의 목록으로 돌아가기");

		Long supportNo = chatService.getSupportUserNo();
		if (supportNo == null) {
			model.addAttribute("msg",
					"고객센터 계정이 없습니다. USERS 에 USER_ID='surit_support' 를 만들어 주세요.");
			return "chat/chat";
		}

		ChatRoomDTO room = chatService.getRoom(roomId);
		if (room == null || room.getRequestId() != null) {
			model.addAttribute("msg", "문의방을 찾을 수 없습니다.");
			return "chat/chat";
		}

		// ★ 관리자는 '고객센터' 자격으로 대화에 참여한다
		session.setAttribute(ChatController.CHAT_USER_NO, supportNo);
		chatService.markAsRead(roomId, supportNo);

		model.addAttribute("room",      room);
		model.addAttribute("myNo",      supportNo);
		model.addAttribute("history",   chatService.getHistory(roomId));
		model.addAttribute("roomTitle", room.getUserName() + " 고객님");
		model.addAttribute("roomSub",   "1:1 문의 · "
				+ (room.getCategoryName() == null ? "" : room.getCategoryName()));
		model.addAttribute("backUrl",   "/admin/inquiries");
		return "chat/chat";
	}
}