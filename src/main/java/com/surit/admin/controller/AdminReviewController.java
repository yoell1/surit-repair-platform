package com.surit.admin.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.surit.admin.model.dto.AdminReviewSearchCondition;
import com.surit.admin.service.ReviewManagementService;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/admin/reviews")
@RequiredArgsConstructor
public class AdminReviewController {

	private final ReviewManagementService reviewService;

	@GetMapping
	public String reviewList(@ModelAttribute AdminReviewSearchCondition condition,
	                         Model model) {
		int totalCount = reviewService.getReviewCount(condition);
		int totalPage = (int) Math.ceil((double) totalCount / condition.getSize());

		model.addAttribute("reviewList",     reviewService.getReviewList(condition));
		model.addAttribute("lowRatedFixers", reviewService.getLowRatedFixers());
		model.addAttribute("totalCount",     totalCount);
		model.addAttribute("totalPage",      totalPage);
		model.addAttribute("condition",      condition);
		return "admin/admin-reviews";
	}

	@PostMapping("/{fixerNo}/warn")
	public String warn(@PathVariable Long fixerNo,
	                   @RequestParam String reason,
	                   HttpSession session, RedirectAttributes ra) {
		String adminId = (String) session.getAttribute("adminId");

		reviewService.warnFixer(fixerNo, reason, adminId);
		ra.addFlashAttribute("msg", "경고를 등록했습니다");
		return "redirect:/admin/reviews";
	}
}