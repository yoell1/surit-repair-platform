package com.surit.admin.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;

import com.surit.admin.model.dto.AdminRequestSearchCondition;
import com.surit.admin.service.RequestManagementService;

import lombok.RequiredArgsConstructor;

/**
 * 접수 현황 (F-22) — 헤더의 "접수 현황" 메뉴가 여기로 온다.
 *
 * AdminController 도 @RequestMapping("/admin") 을 쓰지만
 * 거기엔 /login, /logout 뿐이라 "/admin" 자체는 비어 있다. 충돌 없음.
 */
@Controller
@RequestMapping("/admin")
@RequiredArgsConstructor
public class AdminRequestController {

	private final RequestManagementService requestService;

	@GetMapping
	public String requestList(@ModelAttribute AdminRequestSearchCondition condition,
	                          Model model) {

		int totalCount = requestService.getRequestCount(condition);
		int totalPage  = (int) Math.ceil((double) totalCount / condition.getSize());

		model.addAttribute("requestList",  requestService.getRequestList(condition));
		model.addAttribute("statusCounts", requestService.getStatusCounts());
		model.addAttribute("totalCount",   totalCount);
		model.addAttribute("totalPage",    totalPage);
		model.addAttribute("condition",    condition);

		return "admin/admin-requests";
	}
}