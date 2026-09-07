package com.surit.chat.util;

import java.lang.reflect.Method;

import jakarta.servlet.http.HttpSession;

/**
 * 세션에서 "지금 로그인한 사람의 USER_NO" 를 꺼낸다.
 * 로그인 담당 코드가 세션에 뭘 담는지 확인되면 두 줄로 줄일 수 있다.
 */
public class ChatLoginResolver {

	private static final String[] CANDIDATE_KEYS = {
		"loginUser", "loginMember", "sessionUser", "user", "member",
		"userNo", "loginUserNo"
	};

	public static Long resolveUserNo(HttpSession session) {
		if (session == null) {
			return null;
		}

		for (String key : CANDIDATE_KEYS) {
			Object value = session.getAttribute(key);
			if (value == null) {
				continue;
			}

			// 1) 숫자를 바로 담아둔 경우
			if (value instanceof Number) {
				return ((Number) value).longValue();
			}

			// 2) 문자열로 담아둔 경우
			if (value instanceof String) {
				try {
					return Long.parseLong(((String) value).trim());
				} catch (NumberFormatException ignore) {
					continue;
				}
			}

			// 3) DTO 객체를 담아둔 경우
			Long fromGetter = callGetter(value, "getUserNo");
			if (fromGetter != null) {
				return fromGetter;
			}
			fromGetter = callGetter(value, "getUserId");
			if (fromGetter != null) {
				return fromGetter;
			}
		}

		return null;
	}

	private static Long callGetter(Object target, String methodName) {
		try {
			Method m = target.getClass().getMethod(methodName);
			Object r = m.invoke(target);
			if (r instanceof Number) {
				return ((Number) r).longValue();
			}
			if (r instanceof String) {
				return Long.parseLong(((String) r).trim());
			}
		} catch (Exception ignore) {
			// 해당 메서드가 없으면 그냥 넘어간다
		}
		return null;
	}
}