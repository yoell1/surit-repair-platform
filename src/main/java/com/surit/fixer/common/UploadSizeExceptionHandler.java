package com.surit.fixer.common;

import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.multipart.MaxUploadSizeExceededException;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import jakarta.servlet.http.HttpServletRequest;

/**
 * 업로드 용량 초과 전용 예외 핸들러.
 *
 * ── 왜 FixerExceptionHandler 에 같이 못 넣나 ──
 *   FixerExceptionHandler 는 basePackages 로 적용 범위를 좁혀두었다.
 *   그런데 멀티파트 파싱은 "이 요청을 어느 컨트롤러가 처리할지" 정해지기 *전에* 일어난다.
 *   그 시점에는 대상 컨트롤러가 없으므로(handler == null),
 *   범위를 좁힌 Advice 는 "내 담당인지" 판단할 수 없어 그냥 건너뛴다.
 *   그 결과 아무도 안 잡아서 본문 없는 413 응답이 그대로 나간다.
 *
 * ── 이 클래스가 동작하는 이유 ──
 *   @ControllerAdvice 에 basePackages 같은 선택자를 하나도 두지 않으면
 *   스프링은 "대상 컨트롤러가 무엇이든(없더라도) 적용"으로 판단한다.
 *   선택자가 붙는 순간 컨트롤러 타입을 확인해야 하는데 그게 null 이라 걸러진다.
 *   그래서 이 예외 하나만 범위 제한 없는 Advice 로 따로 받는다.
 *
 * ── 범위를 안 좁혔는데 괜찮은가 ──
 *   @ExceptionHandler 가 MaxUploadSizeExceededException 하나만 잡으므로
 *   다른 팀원 컨트롤러의 예외에는 영향을 주지 않는다.
 *   오히려 어느 화면에서 올리든 같은 안내가 나가는 편이 낫다.
 */
@ControllerAdvice
public class UploadSizeExceptionHandler {

	/** application.properties 의 spring.servlet.multipart.max-file-size 와 같은 값 */
	private static final String MAX_SIZE_TEXT = "10MB";

	@ExceptionHandler(MaxUploadSizeExceededException.class)
	public String handleMaxUploadSize(RedirectAttributes ra, HttpServletRequest request) {

		ra.addFlashAttribute("message",
				"파일 1개당 " + MAX_SIZE_TEXT + "까지 올릴 수 있습니다. 용량을 줄여서 다시 시도해주세요.");
		ra.addFlashAttribute("messageType", "error");

		/*
		 * 어느 화면에서 올렸는지 모르므로 Referer 로 되돌린다.
		 * 다만 Referer 는 브라우저가 보내는 값이라 조작될 수 있다.
		 * 외부 주소를 그대로 쓰면 오픈 리다이렉트가 되므로,
		 * 호스트를 떼고 우리 서비스 내부 경로일 때만 사용한다.
		 */
		String referer = request.getHeader("Referer");
		String target = "/fixer/verify";

		if (referer != null) {
			int idx = referer.indexOf("://");
			if (idx > -1) {
				int slash = referer.indexOf('/', idx + 3);
				referer = (slash > -1) ? referer.substring(slash) : "/";
			}
			if (referer.startsWith("/") && !referer.startsWith("//")) {
				target = referer;
			}
		}

		return "redirect:" + target;
	}
}