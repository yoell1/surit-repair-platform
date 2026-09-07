package com.surit.fixer.estimate.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.surit.common.request.model.dto.RequestDTO;
import com.surit.fixer.estimate.model.dto.EstimateForm;
import com.surit.fixer.estimate.service.EstimateService;
import com.surit.user.SessionConst;
import com.surit.user.model.dto.UserDTO;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/fixer/estimates")
@RequiredArgsConstructor
public class EstimateController {

	private final EstimateService service;

	/** F-16 견적 작성 화면 */
	@GetMapping("/new")
	public String form(@RequestParam("requestId") long requestId,
	                   HttpSession session,
	                   Model model,
	                   RedirectAttributes ra) {

		UserDTO loginMember = (UserDTO) session.getAttribute(SessionConst.LOGIN_MEMBER);
		if (loginMember == null) {
			return "redirect:/user/login?redirectURL=/fixer/estimates/new?requestId=" + requestId;
		}

		try {
			RequestDTO repair = service.getTargetRequest(loginMember.getUserNo(), requestId);

			/*
			 * 이미 견적을 낸 접수면 폼을 열지 않는다. (2026-09-02 추가)
			 *
			 * getTargetRequest 는 접수 상세와 같은 조회(selectRequestDetail)를 쓴다.
			 * 그 쿼리에는 "내가 이미 견적을 낸 접수는 통과" 라는 조건이 들어 있다.
			 * 매칭완료·수리완료로 넘어간 뒤에도 '내 견적' 목록에서 눌러
			 * 들어갈 수 있어야 하기 때문이고, 상세 화면 입장에서는 옳은 조건이다.
			 *
			 * 문제는 견적 폼이 그 조회를 그대로 재사용하면서
			 * 그 예외를 다시 걸러내지 않은 것이었다.
			 * 그래서 주소창에 /fixer/estimates/new?requestId=… 를 직접 치면
			 * 이미 견적을 낸 접수에도 빈 폼이 열렸다.
			 *
			 * 열어줘도 제출하는 순간 서버가 거절하므로 데이터가 잘못될 일은 없었다.
			 * 다만 사용자는 금액·소요시간·설명을 다 입력하고 제출한 뒤에야
			 * 안 된다는 걸 알게 되고, 그 입력이 전부 사라진다.
			 * 안 되는 일은 들어오는 입구에서 막는 게 맞다.
			 *
			 * 접수 상세 화면(requestDetail.jsp)은 이미 같은 값으로 막고 있었다.
			 * 이 화면만 빠져 있었다.
			 *
			 * myEstimateId 는 selectRequestDetail 이 이미 함께 가져오는 값이라
			 * 이 검사 때문에 쿼리가 늘어나지는 않는다.
			 * (접수 목록의 "견적 제출함" 배지가 쓰는 바로 그 값이다)
			 *
			 * 마감된 접수도 이 조건 하나로 같이 걸린다.
			 * 마감(REQ_03·REQ_04)까지 간 접수가 이 화면에 도달하려면
			 * 위 쿼리의 "내 견적" 예외를 타야 하고, 그러면 myEstimateId 가 있다.
			 * 내가 견적을 내지 않은 마감 접수는 애초에 조회를 통과하지 못해
			 * 아래 catch 로 떨어진다.
			 */
			if (repair.getMyEstimateId() != null) {
				ra.addFlashAttribute("message", "이미 이 접수에 견적을 제출했습니다.");
				return "redirect:/fixer/estimates";
			}

			model.addAttribute("repair", repair);

		} catch (IllegalStateException e) {
			ra.addFlashAttribute("message", e.getMessage());
			return "redirect:/fixer/requests";
		}

		return "fixer/estimateForm";
	}

	/**
	 * 견적 제출.
	 *
	 * 성공하든 실패하든 redirect 로 끝낸다(PRG 패턴).
	 * 그냥 forward 하면 사용자가 새로고침했을 때 POST 가 다시 날아가서
	 * 견적이 두 번 등록될 수 있다.
	 */
	@PostMapping
	public String submit(@ModelAttribute EstimateForm form,
	                     HttpSession session,
	                     RedirectAttributes ra) {

		UserDTO loginMember = (UserDTO) session.getAttribute(SessionConst.LOGIN_MEMBER);
		if (loginMember == null) {
			return "redirect:/user/login?redirectURL=/fixer/requests";
		}

		try {
			service.submit(loginMember.getUserNo(), form);
			ra.addFlashAttribute("message", "견적을 제출했습니다.");
			return "redirect:/fixer/estimates";

		} catch (IllegalStateException e) {
			ra.addFlashAttribute("message", e.getMessage());

			/*
			 * requestId 가 없으면(폼이 조작됐거나 값이 안 넘어온 경우)
			 * "...new?requestId=null" 로 리다이렉트하게 되고,
			 * 그 다음 화면은 long 타입으로 못 받아서 또 에러 화면이 뜬다.
			 * requestId 가 있을 때만 견적 작성 화면으로 돌려보내고,
			 * 없으면 안전하게 목록으로 보낸다.
			 *
			 * 여기로 돌아오면 입력값은 남지 않는다. redirect 라 폼이 새로 뜨기 때문이다.
			 * 그래서 값이 아까운 오류(금액 상한·필수값 누락 등)는
			 * estimateForm.jsp 에서 제출 전에 먼저 막아 여기까지 오지 않게 했다.
			 * 여기까지 오는 건 자바스크립트를 우회했거나,
			 * 폼을 열어둔 사이에 접수가 마감된 경우처럼
			 * 어차피 값을 되살려줘도 다시 제출할 수 없는 상황이다.
			 */
			if (form.getRequestId() != null) {
				return "redirect:/fixer/estimates/new?requestId=" + form.getRequestId();
			}
			return "redirect:/fixer/requests";
		}
	}

	/** 내가 낸 견적 목록 */
	@GetMapping
	public String list(HttpSession session, Model model, RedirectAttributes ra) {

		UserDTO loginMember = (UserDTO) session.getAttribute(SessionConst.LOGIN_MEMBER);
		if (loginMember == null) {
			return "redirect:/user/login?redirectURL=/fixer/estimates";
		}

		try {
			model.addAttribute("estimateList", service.getMyEstimates(loginMember.getUserNo()));

		} catch (IllegalStateException e) {
			ra.addFlashAttribute("message", e.getMessage());
			return "redirect:/fixer/verify";
		}

		return "fixer/estimates";
	}
}