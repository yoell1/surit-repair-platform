package com.surit.interceptor;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.web.servlet.HandlerInterceptor;
import com.surit.user.SessionConst;
import com.surit.user.model.dto.UserDTO;

public class FixerInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        HttpSession session = request.getSession(false);

        // 1. 미로그인 시 로그인 페이지로
        if (session == null || session.getAttribute(SessionConst.LOGIN_MEMBER) == null) {
            response.sendRedirect("/user/login?redirectURL=" + request.getRequestURI());
            return false;
        }

        UserDTO loginMember = (UserDTO) session.getAttribute(SessionConst.LOGIN_MEMBER);

        // 2. 기사(FIXER) 권한이 아닐 경우 메인으로 강제 이동
        if (!"FIXER".equals(loginMember.getUserRole())) {
            response.sendRedirect("/");
            return false;
        }

        return true; // 기사 권한 확인 완료
    }
}