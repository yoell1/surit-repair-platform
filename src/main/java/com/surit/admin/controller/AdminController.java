package com.surit.admin.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.surit.admin.model.dto.AdminLoginRequest;
import com.surit.admin.model.dto.AdminResponse;
import com.surit.admin.service.AdminService;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/admin")
@RequiredArgsConstructor
public class AdminController {

	private final AdminService adminService;

	@GetMapping("/login")
	public String loginPage(@RequestParam(required = false) String returnUri,
	                        Model model) {
		model.addAttribute("returnUri", returnUri);
		return "admin/admin-login";
	}

	@PostMapping("/login")
	public String login(@ModelAttribute AdminLoginRequest request,
	                    HttpSession session,
	                    Model model) {
		try {
			AdminResponse admin = adminService.login(request);

			session.setAttribute("admin", admin);
			session.setAttribute("adminId", admin.getAdminId());
			session.setMaxInactiveInterval(30 * 60);   // 30분

			return "redirect:" + safeReturnUri(request.getReturnUri());

		} catch (RuntimeException e) {
			model.addAttribute("error", e.getMessage());
			model.addAttribute("returnUri", request.getReturnUri());
			return "admin/admin-login";
		}
	}

	@GetMapping("/logout")
	public String logout(HttpSession session) {
		session.invalidate();
		return "redirect:/admin/login";
	}

	/** 오픈 리다이렉트 방지 — 내부 /admin 경로만 허용 */ //TODO: 메인 페이지 만들면 변경해야됨
	private String safeReturnUri(String uri) {
		if (uri == null || uri.isBlank())   return "/admin/members";   // ← 변경
		if (!uri.startsWith("/admin"))      return "/admin/members";   // ← 변경
		if (uri.startsWith("//"))           return "/admin/members";   // ← 변경
		if (uri.contains("\\") || uri.contains("\r") || uri.contains("\n")) return "/admin/members";
		return uri;
	}

}


