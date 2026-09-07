package com.surit.admin.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.surit.admin.model.dto.MemberSearchCondition;
import com.surit.admin.service.MemberManagementService;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/admin/members")
@RequiredArgsConstructor
public class AdminMemberController {

	private final MemberManagementService memberService;


	
	@GetMapping("/{userNo}")
	public String memberDetail(@PathVariable Long userNo, Model model) {
		model.addAttribute("fixer", memberService.getFixerDetail(userNo));
		return "admin/admin-member-detail";
	}

	/*
	 * ── 왜 try-catch 로 감싸나 ──
	 *   서비스는 "자격증이 없다" 같은 상황에서 IllegalStateException 을 던진다.
	 *   그냥 두면 스프링이 500 에러 페이지(Whitelabel)를 띄워버려서,
	 *   관리자는 시커먼 스택트레이스만 보고 무슨 일인지 알 수 없다.
	 *
	 *   여기서 잡아서 메시지만 꺼내 flash 로 넘기면
	 *   admin-footer.jsp 의 토스트가 화면 위에 띄워준다.
	 *   (msg / msgType 은 이미 만들어져 있는 공통 토스트가 읽는 이름이다)
	 *
	 *   ★ Exception 전체를 잡지는 않는다.
	 *     진짜 버그(NPE, DB 끊김 등)까지 "알림 한 줄" 로 덮어버리면
	 *     문제가 있는지조차 모르게 된다. 의도적으로 던진 것만 잡는다.
	 */
	@PostMapping("/{userNo}/approve")
	public String approve(@PathVariable Long userNo,
	                      HttpSession session, RedirectAttributes ra) {

		Long adminNo = (Long) session.getAttribute("adminNo");

		try {
			memberService.approveFixer(userNo, adminNo);
		} catch (IllegalStateException e) {
			ra.addFlashAttribute("msg",     e.getMessage());
			ra.addFlashAttribute("msgType", "error");
			// 실패했으니 목록이 아니라 방금 보던 상세 화면으로 되돌린다
			return "redirect:/admin/members/" + userNo;
		}

		ra.addFlashAttribute("msg", "승인 처리되었습니다");
		return "redirect:/admin/members";
	}

	@PostMapping("/{userNo}/reject")
	public String reject(@PathVariable Long userNo,
	                     @RequestParam String reason,
	                     HttpSession session, RedirectAttributes ra) {

		Long adminNo = (Long) session.getAttribute("adminNo");

		try {
			memberService.rejectFixer(userNo, adminNo, reason);
		} catch (IllegalStateException e) {
			ra.addFlashAttribute("msg",     e.getMessage());
			ra.addFlashAttribute("msgType", "error");
			return "redirect:/admin/members/" + userNo;
		}

		ra.addFlashAttribute("msg", "반려 처리되었습니다");
		return "redirect:/admin/members";
	}
	
	@GetMapping
	public String memberList(@ModelAttribute MemberSearchCondition condition, Model model) {
		int totalCount = memberService.getMemberCount(condition);
		int totalPage = (int) Math.ceil((double) totalCount / condition.getSize());

		model.addAttribute("pendingFixers", memberService.getPendingFixers());
		model.addAttribute("memberList",    memberService.getMemberList(condition));
		model.addAttribute("totalCount",    totalCount);
		model.addAttribute("totalPage",     totalPage);   // ← 추가
		model.addAttribute("condition",     condition);
		return "admin/admin-members";
	}
	
}