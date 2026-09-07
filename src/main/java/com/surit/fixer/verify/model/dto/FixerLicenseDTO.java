package com.surit.fixer.verify.model.dto;

import java.time.LocalDate;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

/** FIXER_LICENSE 한 행 */
@Getter @Setter @NoArgsConstructor @ToString
public class FixerLicenseDTO {

	private Long      licenseId;    // LICENSE_ID (IDENTITY)

	private Long   userNo;       // USER_NO
	private String    licenseName;  // LICENSE_NAME (NOT NULL)
	private String    uploadUrl;    // UPLOAD_URL (파일 경로, NULL 허용)
	private LocalDate issuedAt;     // ISSUED_AT (DATE)
}
