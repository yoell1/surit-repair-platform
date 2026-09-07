package com.surit.admin.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.surit.admin.service.BlacklistManagementService;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/admin/blacklist")
@RequiredArgsConstructor
public class AdminBlacklistController {

	private final BlacklistManagementService blacklistService;

	/** 경고 몇 회부터 정지 검토 대상으로 볼 것인가 */
	private static final int WARN_THRESHOLD = 3;

	@GetMapping
	public String page(Model model) {
		model.addAttribute("threshold",   WARN_THRESHOLD);
		model.addAttribute("warnTargets", blacklistService.getWarnTargets(WARN_THRESHOLD));
		model.addAttribute("actives",     blacklistService.getActiveSuspensions());
		model.addAttribute("history",     blacklistService.getHistory());
		return "admin/admin-blacklist";
	}

	@PostMapping("/suspend")
	public String suspend(@RequestParam Long targetNo,
	                      @RequestParam(defaultValue = "7") int days,
	                      @RequestParam(required = false) String reason,
	                      HttpSession session,
	                      RedirectAttributes ra) {

		// ★ adminId 는 String 이다. Long 으로 캐스팅하면 터진다.
		String adminId = (String) session.getAttribute("adminId");
		if (adminId == null) {
			return "redirect:/admin/login?returnUri=/admin/blacklist";
		}

		if (reason == null || reason.trim().isEmpty()) {
			ra.addFlashAttribute("msg", "정지 사유는 반드시 입력해야 합니다.");
			return "redirect:/admin/blacklist";
		}

		blacklistService.suspend(targetNo, days, reason.trim(), adminId);
		ra.addFlashAttribute("msg",
				days <= 0 ? "영구 정지 처리했습니다." : days + "일 정지 처리했습니다.");
		return "redirect:/admin/blacklist";
	}

	@PostMapping("/release")
	public String release(@RequestParam Long sanctionId,
	                      HttpSession session,
	                      RedirectAttributes ra) {

		String adminId = (String) session.getAttribute("adminId");
		if (adminId == null) {
			return "redirect:/admin/login?returnUri=/admin/blacklist";
		}

		blacklistService.release(sanctionId);
		ra.addFlashAttribute("msg", "제재를 해제했습니다.");
		return "redirect:/admin/blacklist";
	}
}