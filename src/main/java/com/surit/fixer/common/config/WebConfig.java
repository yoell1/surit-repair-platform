package com.surit.fixer.common.config;

import com.surit.interceptor.FixerInterceptor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

/**
 * 업로드한 파일(자격증 증빙 · 기사 본인확인 사진)을 브라우저에서 볼 수 있게 해준다.
 *
 * 파일은 프로젝트 밖(예: uploads/license, uploads/photo)에 저장되기 때문에
 * 그냥 두면 /uploads/license/xxx.png 로 접근해도 404 가 난다.
 * "이 URL 로 오면 이 디스크 폴더를 뒤져라" 를 알려주는 게 이 클래스다.
 */
@Configuration
public class WebConfig implements WebMvcConfigurer {

	@Value("${file.upload-dir.license}")
	private String licenseUploadDir;

	@Value("${file.web-prefix.license}")
	private String licenseWebPrefix;

	@Value("${file.upload-dir.photo}")
	private String photoUploadDir;

	@Value("${file.web-prefix.photo}")
	private String photoWebPrefix;

	@Override
	public void addResourceHandlers(ResourceHandlerRegistry registry) {

		// 자격증 증빙 파일
		registry.addResourceHandler(urlPatternOf(licenseWebPrefix))
		        .addResourceLocations(locationOf(licenseUploadDir));

		// 기사 본인확인 사진 (고객에게 노출되는 사진)
		// 이 등록이 없으면 파일은 저장돼도 <img src="/uploads/photo/xxx.jpg"> 가 404 가 난다.
		registry.addResourceHandler(urlPatternOf(photoWebPrefix))
		        .addResourceLocations(locationOf(photoUploadDir));
	}

	@Override
	public void addInterceptors(InterceptorRegistry registry) {
		// 기존에 등록된 다른 인터셉터 코드가 있다면 지우지 말고 그 아래에 추가하세요!

		// [추가] 기사 권한 제어 인터셉터
		registry.addInterceptor(new FixerInterceptor())
				.addPathPatterns("/fixer/**")
				.excludePathPatterns("/fixer/verify");
	}


	/** "/uploads/photo" → "/uploads/photo/**" */
	private String urlPatternOf(String webPrefix) {
		return trimEndSlash(webPrefix) + "/**";
	}

	/** "uploads/photo" → "file:uploads/photo/" */
	private String locationOf(String uploadDir) {
		return "file:" + trimEndSlash(uploadDir.replace("\\", "/")) + "/";
	}

	// 설정값에 끝 슬래시가 있든 없든 똑같이 동작하도록 맞춰준다
	private String trimEndSlash(String s) {
		String v = (s == null) ? "" : s.trim();
		while (v.endsWith("/")) {
			v = v.substring(0, v.length() - 1);
		}
		return v;
	}
}
