package com.surit.fixer.common;

import org.springframework.validation.BindException;
import org.springframework.web.bind.MissingServletRequestParameterException;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.method.annotation.MethodArgumentTypeMismatchException;
import org.springframework.web.multipart.MaxUploadSizeExceededException;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import jakarta.servlet.http.HttpServletRequest;

/**
 * 기사(fixer) 기능에서 자주 나올 수 있는 "사용자 입력이 이상한" 상황을
 * 흰 에러 화면(Whitelabel Error Page) 대신 원래 화면으로 돌려보내며
 * 안내 메시지를 보여주기 위한 핸들러.
 *
 * basePackages 로 적용 대상을 좁혀서, 이 프로젝트의 다른 팀원이
 * 만든 컨트롤러(로그인, 회원가입 등)에는 영향을 주지 않는다.
 *
 * 접수(request)는 고객도 쓰는 공통 기능이라 com.surit.common.request 에 있지만,
 * 화면은 여전히 기사용(/fixer/requests)이므로 함께 포함한다.
 * 나중에 팀 공통 예외 처리가 생기면 그때 빼면 된다.
 */
@ControllerAdvice(basePackages = {
		"com.surit.fixer",
		"com.surit.common.request"
})
public class FixerExceptionHandler {

	/**
	 * 업로드 파일이 너무 클 때.
	 *
	 * application.properties 의 spring.servlet.multipart.max-file-size 를 넘으면
	 * 컨트롤러에 들어오기도 전에 이 예외가 던져진다.
	 * FileUploadUtil 안의 10MB 체크는 사실상 이 예외보다 늦게 걸리기 때문에
	 * 이 핸들러가 없으면 항상 흰 에러 화면만 보게 된다.
	 */
	@ExceptionHandler(MaxUploadSizeExceededException.class)
	public String handleMaxUploadSize(HttpServletRequest request, RedirectAttributes ra) {

		ra.addFlashAttribute("message", "첨부파일 용량이 너무 큽니다. 파일당 10MB 이하로 올려주세요.");
		return "redirect:" + fallbackUrl(request);
	}

	/**
	 * URL 이나 폼 값이 원하는 타입으로 안 바뀔 때.
	 *
	 * 예) /fixer/requests/abc (숫자가 와야 하는 자리에 문자),
	 *     견적 금액 칸에 숫자가 아닌 값이 들어간 경우 등.
	 * 이런 건 대부분 사용자가 URL을 직접 손대거나 폼을 조작했을 때 생긴다.
	 */
	@ExceptionHandler(MethodArgumentTypeMismatchException.class)
	public String handleTypeMismatch(HttpServletRequest request, RedirectAttributes ra) {

		ra.addFlashAttribute("message", "입력값이 올바르지 않습니다. 다시 확인해주세요.");
		return "redirect:" + fallbackUrl(request);
	}

	/** 필수로 있어야 할 파라미터(예: requestId)가 아예 안 왔을 때 */
	@ExceptionHandler(MissingServletRequestParameterException.class)
	public String handleMissingParameter(HttpServletRequest request, RedirectAttributes ra) {

		ra.addFlashAttribute("message", "필요한 정보가 없습니다. 목록에서 다시 시도해주세요.");
		return "redirect:" + fallbackUrl(request);
	}

	/**
	 * @ModelAttribute 로 폼을 통째로 받을 때(EstimateForm 등) 값이 안 맞으면 이 예외가 뜬다.
	 * 위의 MethodArgumentTypeMismatchException 과는 별개다.
	 * 그건 @PathVariable/@RequestParam 하나가 틀렸을 때, 이건 폼 전체 바인딩이
	 * 실패했을 때(예: 견적 금액 칸에 숫자가 아닌 값) 발생한다.
	 */
	@ExceptionHandler(BindException.class)
	public String handleBindException(HttpServletRequest request, RedirectAttributes ra) {

		ra.addFlashAttribute("message", "입력값이 올바르지 않습니다. 숫자 칸에는 숫자만 입력해주세요.");
		return "redirect:" + fallbackUrl(request);
	}

	/**
	 * 어디로 돌려보낼지는 이전 화면(Referer)을 기준으로 정한다.
	 * 이 기능들이 앞으로 늘어나도 여기 손댈 필요가 없도록 하기 위함.
	 * Referer 를 못 구하면(직접 주소를 친 경우 등) 접수 목록으로 보낸다.
	 */
	private String fallbackUrl(HttpServletRequest request) {
		String referer = request.getHeader("Referer");
		if (referer != null && !referer.isBlank()) {
			return referer;
		}
		return "/fixer/requests";
	}
}