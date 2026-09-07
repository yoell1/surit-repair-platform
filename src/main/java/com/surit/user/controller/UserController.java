package com.surit.user.controller;

import java.io.IOException;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.surit.common.ApiResponse;
import com.surit.common.model.mapper.CommonCodeMapper;
import com.surit.common.request.service.RequestService;
import com.surit.user.model.dto.UserAddressDTO;
import com.surit.user.model.dto.UserDTO;
import com.surit.user.service.UserService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/user")
public class UserController {

	private final UserService service;
	private final RequestService requestService;
	private final CommonCodeMapper codeMapper;   // ← 추가

	public UserController(UserService service, RequestService requestService, CommonCodeMapper codeMapper) {
		this.service = service;
		this.requestService = requestService;
		this.codeMapper = codeMapper;
	}

	@GetMapping("/sign")
	public String signForm(Model model) {

		// 회원가입 주소 선택용 지역 목록 (fixer/verify.jsp 와 같은 COMMON_CODE REGION 그룹 재사용)
		model.addAttribute("regionList", codeMapper.selectByGroup("REGION"));

		return "user/sign";
	}

	@GetMapping("/login")
	public String loginForm() {
		return "user/login";
	}


	@PostMapping("/sign")
	public String sign(@ModelAttribute UserDTO user,
	                    @ModelAttribute UserAddressDTO address,
	                    RedirectAttributes redirectAttr) {

	    try {
	        service.sign(user, address);

	    } catch (IllegalStateException e) {
	        /*
	         * 아이디·이메일 중복처럼 "사용자가 고칠 수 있는" 문제.
	         *
	         * ★ 2026-09-01 이전에는 이 catch 가 없어서 500 에러 페이지가 떴다.
	         *   서비스가 던지는 IllegalStateException 이 그대로 위로 올라갔기 때문이다.
	         *   메시지만 꺼내 화면으로 돌려주면 sign.jsp 의 ${error} 자리에 표시된다.
	         */
	        redirectAttr.addFlashAttribute("error", e.getMessage());
	        return "redirect:/user/sign";

	    } catch (IOException e) {
	        // 파일 저장 실패 같은 시스템 문제. 사용자에게 자세히 알릴 게 없다
	        e.printStackTrace();
	        redirectAttr.addFlashAttribute("error", "회원 가입에 실패했습니다. 잠시 후 다시 시도해 주세요.");
	        return "redirect:/user/sign";
	    }

	    redirectAttr.addFlashAttribute("signSuccess", true);
	    return "redirect:/user/login";
	}

	//@ResponseBody : 응답 본문에 데이터를 담아 처리
	/*
	 * URL : [GET} /member/checkId?memberId=XXX
	 */
	@GetMapping("/checkId")
	@ResponseBody
	public ApiResponse<Boolean> checkId(String userId) {

		boolean isDuplicate = service.isUserIdCheck(userId);

		String message = isDuplicate ? "이미 사용중인 아이디입니다." : "사용 가능한 아이디입니다.";

		return ApiResponse.success(message, isDuplicate);
	}

	/**
	 * 이메일 중복확인 (2026-09-01 추가)
	 * URL : [GET] /user/checkEmail?email=XXX
	 *
	 * 가입 버튼을 누른 뒤에 알려주면 입력했던 내용이 다 날아간다.
	 * 이메일 칸에서 커서가 빠져나가는 순간 미리 알려주는 편이 낫다.
	 */
	@GetMapping("/checkEmail")
	@ResponseBody
	public ApiResponse<Boolean> checkEmail(String email) {

		boolean isDuplicate = service.isEmailCheck(email);

		String message = isDuplicate ? "이미 사용중인 이메일입니다." : "사용 가능한 이메일입니다.";

		return ApiResponse.success(message, isDuplicate);
	}

	@PostMapping("/login")
	public String login(String userId, String userPwd
			,@RequestParam(required=false) String redirectURL
			, HttpSession session, RedirectAttributes redirectAttr) {
		try {
		UserDTO user = service.login(userId, userPwd);

		//로그인 성공 --> 세션에 로그인 정보 저장
		session.setAttribute("loginMember", user);
		}catch(IllegalStateException e) {
			redirectAttr.addFlashAttribute("error", e.getMessage());
			return "redirect:/user/login";
		}

		if(redirectURL != null && !redirectURL.isBlank()) {
			return "redirect:" + redirectURL;
		}
		return "redirect:/";


	}

	@GetMapping("/logout")
	public String logout(HttpServletRequest request) {
		HttpSession session = request.getSession(false);
		if(session != null) {
			session.invalidate(); //세션 자체 만료
		}
	return "redirect:/user/login";
	}

	@PostMapping("/withdraw")
	public String withdraw(HttpSession session) {

	UserDTO loginMember = (UserDTO)session.getAttribute("loginMember");
	//서비스에서 비즈니스 로직 요청
	service.withdraw(loginMember.getUserId());
	//세션 영역 모든 데이터 삭제(세션 만료)
	session.invalidate();
	//메인 페이지 리다이렉트
	return "redirect:/";
	}


}