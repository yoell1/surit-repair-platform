package com.surit.fixer.verify.service;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.LinkedHashSet;
import java.util.List;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.surit.common.model.dto.CommonCodeDTO;
import com.surit.common.model.mapper.CommonCodeMapper;
import com.surit.fixer.common.FixerGuard;
import com.surit.fixer.common.util.FileUploadUtil;
import com.surit.fixer.common.util.SavedFile;
import com.surit.fixer.verify.model.dto.FixerLicenseDTO;
import com.surit.fixer.verify.model.dto.FixerProfileDTO;
import com.surit.fixer.verify.model.dto.FixerVerifyRequest;
import com.surit.fixer.verify.model.mapper.FixerMapper;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class FixerServiceImpl implements FixerService {

	// 승인 상태 문자열은 FixerGuard 한 곳에만 둔다.
	// 여러 클래스에 복사해두면 규칙이 바뀔 때 한 곳을 빠뜨리기 쉽다.

	/*
	 * FIXER_PROFILE.INTRO 컬럼이 VARCHAR2(4000) 이다.
	 * 오라클의 기본 길이 단위는 "글자"가 아니라 "바이트"이고,
	 * UTF-8 에서 한글 1자는 3바이트다. 그래서 실제 한도는 한글 약 1,333자다.
	 * verify.jsp 의 INTRO_MAX_BYTES 와 반드시 같은 값이어야 한다.
	 */
	private static final int INTRO_MAX_BYTES = 4000;

	private final FixerMapper      mapper;
	private final CommonCodeMapper codeMapper;
	private final FileUploadUtil   fileUploadUtil;

	@Value("${file.upload-dir.license}")
	private String licenseUploadDir;

	@Value("${file.web-prefix.license}")
	private String licenseWebPrefix;

	@Value("${file.upload-dir.photo}")
	private String photoUploadDir;

	@Value("${file.web-prefix.photo}")
	private String photoWebPrefix;


	@Override
	public List<CommonCodeDTO> getCategoryList() {
		return codeMapper.selectByGroup("CATEGORY");
	}

	@Override
	public List<CommonCodeDTO> getRegionList() {
		return codeMapper.selectByGroup("REGION");
	}

	@Override
	public FixerProfileDTO getMyProfile(Long userNo) {
		return mapper.selectFixerProfile(userNo);
	}

	/*
	 * 접수 목록 화면(F-15)에서 "내가 등록한 지역·분야"를 보여주기 위한 조회.
	 * 매칭이 안 될 때 사용자가 자기 조건을 기억에 의존해 떠올려야 했던 문제(REQ-05·06) 대응.
	 * MyBatis 는 결과가 없으면 null 이 아니라 빈 List 를 돌려주므로 화면에서 empty 검사만 하면 된다.
	 */
	/*
	 * 기사 공개 프로필 화면이 쓰는 조회와 내용이 같아서, 쿼리를 두 벌 두지 않고
	 * selectFixerRegionNames / selectFixerCategoryNames 하나로 합쳤다.
	 * 조건이 바뀔 때 한쪽만 고쳐져서 화면끼리 어긋나는 일을 막기 위함이다.
	 */
	@Override
	public List<String> getMyRegionNames(Long userNo) {
		return mapper.selectFixerRegionNames(userNo);
	}

	@Override
	public List<String> getMyCategoryNames(Long userNo) {
		return mapper.selectFixerCategoryNames(userNo);
	}


	@Override
	@Transactional(rollbackFor = Exception.class)
	public void applyVerify(Long userNo, FixerVerifyRequest request) throws IOException {

		// ---------- 0) 입력값 검증 ----------
		validate(request);

		// ---------- 1) 신규인가 재신청인가 ----------
		FixerProfileDTO profile = mapper.selectFixerProfile(userNo);
		boolean isNew;

		if (profile == null) {
			isNew = true;
		} else if (FixerGuard.PENDING.equals(profile.getApprovalStatus())) {
			throw new IllegalStateException("이미 심사 중인 신청이 있습니다.");
		} else if (FixerGuard.APPROVED.equals(profile.getApprovalStatus())) {
			throw new IllegalStateException("이미 인증된 기사입니다.");
		} else {
			isNew = false;   // REJECTED → 재신청
		}

		// ---------- 2) 재신청이면 기존 데이터 정리 ----------
		// DB 행을 지우기 전에 파일 경로를 미리 확보해둔다.
		// 지우고 나면 어떤 파일을 삭제해야 할지 알 수 없게 되니까.
		List<FixerLicenseDTO> oldLicenses = new ArrayList<>();
		String oldPhotoUrl = (profile != null) ? profile.getPhotoUrl() : null;

		if (!isNew) {
			oldLicenses = mapper.selectLicensesByUserNo(userNo);
			mapper.deleteLicensesByUserNo(userNo);
			mapper.deleteRegionsByUserNo(userNo);
			mapper.deleteCategoriesByUserNo(userNo);
		}

		// 이번 요청에서 디스크에 새로 만든 파일들. 아래에서 실패하면 이것만 치운다.
		String       newPhotoPath    = null;
		List<String> newLicensePaths = new ArrayList<>();

		try {
			// ---------- 3) 인증 사진 ----------
			// validate() 에서 이미 필수값인지 확인했으므로 여기서는 저장만 한다.
			// INSERT/UPDATE 보다 먼저 저장해야 photoUrl 을 프로필에 채울 수 있다.
			SavedFile savedPhoto = fileUploadUtil.save(request.getPhotoFile(), photoUploadDir, photoWebPrefix);
			newPhotoPath = savedPhoto.getPath();

			// ---------- 4) 프로필 저장 ----------
			FixerProfileDTO save = new FixerProfileDTO();
			save.setUserNo(userNo);
			save.setIntro(request.getIntro());
			save.setCareerYears(request.getCareerYears());
			save.setPhotoUrl(newPhotoPath);

			if (isNew) {
				mapper.insertFixerProfile(save);

			} else {
				// UPDATE 의 WHERE 에 APPROVAL_STATUS='REJECTED' 조건이 있어서,
				// 조회한 뒤 여기까지 오는 사이에 관리자가 승인했다면 0건이 된다.
				int updated = mapper.updateFixerProfile(save);
				if (updated == 0) {
					throw new IllegalStateException("신청 상태가 이미 변경되었습니다. 새로고침 후 다시 시도해주세요.");
				}
			}

			// ---------- 5) 활동 지역 ----------
			for (String regionCode : new LinkedHashSet<>(request.getRegionCodes())) {
				mapper.insertFixerRegion(userNo, regionCode);
			}

			// ---------- 6) 수리 분야 ----------
			for (String categoryCode : new LinkedHashSet<>(request.getCategoryCodes())) {
				mapper.insertFixerCategory(userNo, categoryCode);
			}

			// ---------- 7) 자격증 ----------
			int savedCount = saveLicenses(userNo, request, newLicensePaths);

			if (savedCount == 0) {
				// 자격증 없는 인증 신청은 심사할 근거가 없다.
				// 여기서 던지면 @Transactional 이 위의 INSERT 들을 전부 되돌린다.
				throw new IllegalStateException("자격증을 최소 1개 입력해주세요.");
			}

		} catch (RuntimeException | IOException e) {
			// @Transactional 이 DB 는 되돌려주지만 파일은 안 되돌린다.
			// 이번 요청에서 새로 만든 파일만 직접 치우고, 예외는 그대로 위로 던진다.
			if (newPhotoPath != null) {
				fileUploadUtil.delete(newPhotoPath, photoUploadDir);
			}
			for (String path : newLicensePaths) {
				fileUploadUtil.delete(path, licenseUploadDir);
			}
			throw e;
		}

		// ---------- 8) 옛 파일 삭제 (반드시 맨 마지막) ----------
		// DB 작업이 전부 끝난 뒤에 지운다. 중간에 예외가 나면 DB는 롤백되지만
		// 이미 지워버린 파일은 되살릴 방법이 없기 때문.
		fileUploadUtil.delete(oldPhotoUrl, photoUploadDir);
		for (FixerLicenseDTO old : oldLicenses) {
			fileUploadUtil.delete(old.getUploadUrl(), licenseUploadDir);
		}
	}


	/**
	 * 자격증 목록을 저장하고, 실제로 저장된 건수를 돌려준다.
	 * 새로 저장에 성공한 파일 경로는 savedPaths 에 계속 쌓아준다 —
	 * 실패 시 치우는 책임은 이제 applyVerify() 의 바깥 try/catch 가 진다
	 * (사진 파일과 함께 한 곳에서 정리하기 위함).
	 */
	private int saveLicenses(Long userNo, FixerVerifyRequest request, List<String> savedPaths) throws IOException {

		List<String>        names = request.getLicenseNames();
		List<String>        dates = request.getLicenseIssuedAts();
		List<MultipartFile> files = request.getLicenseFiles();

		if (names == null) {
			return 0;
		}

		int count = 0;

		for (int i = 0; i < names.size(); i++) {

			String name = names.get(i);

			// 이름이 빈 칸은 아예 입력을 안 한 것으로 본다
			if (name == null || name.isBlank()) {
				continue;
			}

			// ---- 검증을 파일 저장보다 먼저 끝낸다 ----
			// 저장한 뒤에 예외를 던지면 @Transactional 이 DB 는 되돌려도
			// 이미 디스크에 쓴 파일은 못 되돌려서 고아 파일이 남는다.
			LocalDate issuedAt = toDate(pick(dates, i));

			// ---- 검증 통과 후 저장 ----
			String uploadUrl = null;
			MultipartFile file = pickFile(files, i);

			if (file != null && !file.isEmpty()) {
				SavedFile saved = fileUploadUtil.save(file, licenseUploadDir, licenseWebPrefix);
				savedPaths.add(saved.getPath());
				uploadUrl = saved.getPath();
			}

			FixerLicenseDTO license = new FixerLicenseDTO();
			license.setUserNo(userNo);
			license.setLicenseName(name.trim());
			license.setUploadUrl(uploadUrl);
			license.setIssuedAt(issuedAt);

			mapper.insertFixerLicense(license);
			count++;
		}

		return count;
	}


	// ---------- 작은 도우미들 ----------

	private String pick(List<String> list, int i) {
		return (list != null && i < list.size()) ? list.get(i) : null;
	}

	private MultipartFile pickFile(List<MultipartFile> list, int i) {
		return (list != null && i < list.size()) ? list.get(i) : null;
	}

	/** "2023-05-10" → LocalDate, 비었으면 null (발급일은 선택 항목) */
	private LocalDate toDate(String s) {
		if (s == null || s.isBlank()) {
			return null;
		}

		LocalDate date;
		try {
			date = LocalDate.parse(s.trim());
		} catch (Exception e) {
			// DateTimeParseException 을 그대로 올리면 사용자에게 스택트레이스 같은 말이 나간다.
			// 컨트롤러가 잡아서 보여줄 수 있는 IllegalStateException 으로 바꾼다.
			throw new IllegalStateException("발급일 형식이 올바르지 않습니다: " + s);
		}

		// 형식은 맞지만 말이 안 되는 값 — 아직 오지 않은 날짜에 자격증이 발급될 수는 없다.
		// 화면에서도 막지만, 개발자도구로 지우면 그만이라 여기서 한 번 더 본다.
		if (date.isAfter(LocalDate.now())) {
			throw new IllegalStateException("발급일이 오늘 이후일 수 없습니다: " + s);
		}

		return date;
	}

	private void validate(FixerVerifyRequest r) {

		// 사진은 필수 — DB 컬럼은 nullable 이라 여기서 막지 않으면 사진 없이도 신청이 된다.
		if (r.getPhotoFile() == null || r.getPhotoFile().isEmpty()) {
			throw new IllegalStateException("본인 확인용 사진을 첨부해주세요.");
		}
		if (r.getRegionCodes() == null || r.getRegionCodes().isEmpty()) {
			throw new IllegalStateException("활동 지역을 최소 1개 선택해주세요.");
		}
		if (r.getCategoryCodes() == null || r.getCategoryCodes().isEmpty()) {
			throw new IllegalStateException("수리 가능 분야를 최소 1개 선택해주세요.");
		}
		// Long 은 null 이 될 수 있으므로 반드시 null 검사를 먼저 한다.
		// 순서를 바꾸면 자동 언박싱에서 NullPointerException 이 난다.
		if (r.getCareerYears() == null || r.getCareerYears() < 0) {
			throw new IllegalStateException("경력(년)을 올바르게 입력해주세요.");
		}
		if (r.getCareerYears() > 70) {
			throw new IllegalStateException("경력이 너무 큽니다. 다시 확인해주세요.");
		}
		/*
		 * 자기소개 길이 — 반드시 "바이트"로 세야 한다.
		 *
		 * String.length() 는 글자 수를 센다. 그런데 저장 대상인 VARCHAR2(4000) 은
		 * 바이트를 센다. 한글은 UTF-8 에서 1자당 3바이트라, 한글 1,334자만 넘어도
		 *   length()  = 1334   → 검증 통과
		 *   실제 크기 = 4002 byte → INSERT 에서 ORA-12899
		 * 가 되어, 사용자는 "알 수 없는 오류" 화면을 보게 된다.
		 * (영문만으로 테스트하면 1바이트라 4000자까지 안 터져서 놓치기 쉽다)
		 *
		 * 그래서 DB 와 같은 기준으로 세고, 몇 바이트인지도 함께 알려준다.
		 */
		if (r.getIntro() != null) {
			int bytes = r.getIntro().getBytes(StandardCharsets.UTF_8).length;
			if (bytes > INTRO_MAX_BYTES) {
				throw new IllegalStateException(
						"자기소개가 너무 깁니다. 한글 기준 약 1,300자까지 입력할 수 있습니다. (현재 "
						+ bytes + "바이트 / 최대 " + INTRO_MAX_BYTES + "바이트)");
			}
		}
	}
}
