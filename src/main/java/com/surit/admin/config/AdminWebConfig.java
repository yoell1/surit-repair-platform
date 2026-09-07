package com.surit.admin.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import com.surit.admin.interceptor.AdminInterceptor;

import lombok.RequiredArgsConstructor;

/*
 * 관리자 전용 MVC 설정
 *
 *   - AdminInterceptor 등록
 *     : /admin/** 로 들어오는 요청은 컨트롤러에 닿기 전에 가로채서
 *       세션에 관리자가 있는지 확인한다.
 *       없으면 /admin/login?returnUri=원래주소 로 돌려보낸다.
 *
 *   - 로그인 화면 자체는 제외해야 한다.
 *     안 하면 로그인하러 가는데 또 로그인으로 튕기는 무한 루프가 된다.
 *
 *   ※ 나중에 팀 WebConfig와 합칠 때는
 *      addInterceptors 안의 내용만 옮기면 된다.
 */
@Configuration
@RequiredArgsConstructor
public class AdminWebConfig implements WebMvcConfigurer {

	private final AdminInterceptor adminInterceptor;

	@Override
	public void addInterceptors(InterceptorRegistry registry) {

		registry.addInterceptor(adminInterceptor)
				.addPathPatterns("/admin/**")
				.excludePathPatterns("/admin/login",
									 "/admin/logout");
	}
}