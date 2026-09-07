package com.surit.chat.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

/**
 * 옛날 주소 정리용.
 *
 * 고객센터가 /support → /user/mypage/support 로 옮겨졌다.
 * 예전 주소를 즐겨찾기 해뒀거나 다른 JSP 에 링크가 남아 있어도
 * 404 가 아니라 새 주소로 넘어가게 해준다.
 *
 * 나중에 예전 링크가 전부 정리되면 이 파일은 지워도 된다.
 */
@Controller
public class SupportLegacyController {

	@GetMapping("/support")
	public String legacySupport() {
		return "redirect:/user/mypage/support";
	}

	/*
	 * /chat 은 여기서 뺐다. (2026-08-31)
	 *
	 * 헤더의 [채팅] 메뉴가 이 주소를 쓰는데, 고객센터 FAQ 로 보내면
	 * "채팅 눌렀는데 왜 FAQ 가 뜨지" 가 된다.
	 * 지금은 ChatController#chatHome 이 맡아서 내 최근 채팅방으로 보낸다.
	 */
}
