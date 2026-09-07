package com.surit.admin.interceptor;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/*
 * 관리자 로그인 확인 인터셉터
 *
 *   preHandle : 컨트롤러가 실행되기 "전"에 호출된다.
 *               return true  -> 컨트롤러로 진행
 *               return false -> 여기서 끝 (컨트롤러 실행 안 됨)
 */
@Component
public class AdminInterceptor implements HandlerInterceptor {

	@Override
	public boolean preHandle(HttpServletRequest request,
							 HttpServletResponse response,
							 Object handler) throws Exception {

		// getSession(false) : 세션이 없으면 새로 만들지 않고 null 반환
		HttpSession session = request.getSession(false);

		if (session == null || session.getAttribute("admin") == null) {

			// 원래 가려던 주소를 기억해뒀다가 로그인 후 복귀시킨다
			String uri = request.getRequestURI();
			String query = request.getQueryString();

			if (query != null) {
				uri = uri + "?" + query;
			}

			response.sendRedirect("/admin/login?returnUri="
					+ URLEncoder.encode(uri, StandardCharsets.UTF_8));

			return false;
		}

		return true;
	}
}