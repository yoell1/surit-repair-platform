package com.surit.fixer.verify.model.dto;

import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

/**
 * 기사 인증 신청 화면 → 서버.
 * 대응하는 테이블이 없다. 서비스가 4개 테이블로 쪼개서 나눠 담는다.
 */
@Getter @Setter @NoArgsConstructor @ToString 
public class FixerVerifyRequest {

	// → FIXER_PROFILE
	private String  intro;

	private Long careerYears;


	// → FIXER_PROFILE.FIXER_PHOTO_URL (고객 확인용 사진, 필수 1장)
	private MultipartFile photoFile;

	// → FIXER_REGION   (COMMON_CODE 의 REGION 코드)
	private List<String> regionCodes;

	// → FIXER_CATEGORY (COMMON_CODE 의 CATEGORY 코드)
	private List<String> categoryCodes;

	// → FIXER_LICENSE  (아래 3개가 같은 index 끼리 한 세트)
	private List<String>        licenseNames;
	private List<String>        licenseIssuedAts;  // "2023-05-10" 문자열로 받는다
	private List<MultipartFile> licenseFiles;
}
