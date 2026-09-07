package com.surit.fixer.job.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.surit.fixer.job.service.JobService;
import com.surit.fixer.payment.service.FixerPaymentService; // 결제 서비스 추가
import com.surit.user.SessionConst;
import com.surit.user.model.dto.UserDTO;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/fixer/jobs")
@RequiredArgsConstructor
public class JobController {

	private final JobService service;
	private final FixerPaymentService paymentService; // 의존성 주입

	@GetMapping
	public String list(@RequestParam(value = "statusCode", required = false) String statusCode,
	                   HttpSession session, Model model, RedirectAttributes ra) {

		UserDTO loginMember = (UserDTO) session.getAttribute(SessionConst.LOGIN_MEMBER);
		if (loginMember == null) return "redirect:/user/login?redirectURL=/fixer/jobs";

		try {
			model.addAttribute("user", loginMember); // JSP 사이드바용 유저 정보 추가
			model.addAttribute("jobList", service.getMyJobs(loginMember.getUserNo(), statusCode));
			model.addAttribute("statusCode", statusCode);
		} catch (IllegalStateException e) {
			ra.addFlashAttribute("message", e.getMessage());
			return "redirect:/fixer/verify";
		}
		return "fixer/jobs";
	}

	@GetMapping("/{requestId}")
	public String detail(@PathVariable("requestId") Long requestId,
	                     HttpSession session, Model model, RedirectAttributes ra) {

		UserDTO loginMember = (UserDTO) session.getAttribute(SessionConst.LOGIN_MEMBER);
		if (loginMember == null) return "redirect:/user/login?redirectURL=/fixer/jobs/" + requestId;

		try {
			model.addAttribute("user", loginMember); // JSP 사이드바용 유저 정보 추가
			
			// 💡 작업 정보를 변수에 담아두고 상태 분기 등에 활용
			var job = service.getMyJob(loginMember.getUserNo(), requestId);
			model.addAttribute("job", job);
			
			// 💡 수리 완료 상태일 경우 결제 데이터 조회 및 모델 추가
			if ("REQ_04".equals(job.getStatusCode())) {
				model.addAttribute("payment", paymentService.getPaymentByEstimateId(job.getEstimateId()));
			}

		} catch (IllegalStateException e) {
			ra.addFlashAttribute("message", e.getMessage());
			return "redirect:/fixer/jobs";
		}
		return "fixer/jobDetail"; // 파일명 jobDetail.jsp (대소문자 주의!)
	}

	@PostMapping("/{requestId}/complete")
	public String complete(@PathVariable("requestId") Long requestId,
	                       HttpSession session, RedirectAttributes ra) {

		UserDTO loginMember = (UserDTO) session.getAttribute(SessionConst.LOGIN_MEMBER);
		if (loginMember == null) return "redirect:/user/login";

		try {
			service.complete(loginMember.getUserNo(), requestId);
			ra.addFlashAttribute("message", "수리 완료로 변경했습니다.");
		} catch (IllegalStateException e) {
			ra.addFlashAttribute("message", e.getMessage());
		}
		return "redirect:/fixer/jobs/" + requestId;
	}
}