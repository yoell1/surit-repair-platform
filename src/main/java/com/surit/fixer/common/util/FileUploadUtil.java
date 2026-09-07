package com.surit.fixer.common.util;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.util.Locale;
import java.util.UUID;

import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;

/**
 * 업로드 파일 저장 / 삭제 담당.
 */
@Component
public class FileUploadUtil {

	/** 허용 확장자. 여기 없는 건 아예 저장하지 않는다 */
	private static final List<String> ALLOWED = List.of("jpg", "jpeg", "png", "pdf");

	/** 10MB */
	private static final long MAX_SIZE = 10L * 1024 * 1024;


	/**
	 * 파일을 저장하고 저장 결과를 돌려준다.
	 *
	 * @param file      업로드된 파일
	 * @param uploadDir 디스크 저장 폴더 (application.properties 의 file.upload-dir.license)
	 * @param webPrefix 브라우저에서 접근할 URL 앞부분 (file.web-prefix.license)
	 */
	public SavedFile save(MultipartFile file, String uploadDir, String webPrefix) throws IOException {

		if (file == null || file.isEmpty()) {
			throw new IllegalStateException("빈 파일입니다.");
		}
		if (file.getSize() > MAX_SIZE) {
			throw new IllegalStateException("파일 크기는 10MB를 넘을 수 없습니다.");
		}

		String originalName = file.getOriginalFilename();
		String ext = extensionOf(originalName);

		if (!ALLOWED.contains(ext)) {
			throw new IllegalStateException("jpg, png, pdf 파일만 올릴 수 있습니다.");
		}

		/*
		 * 사용자가 올린 이름을 그대로 쓰면 안 되는 이유 :
		 *  1) "../../config/application.properties" 같은 이름을 보내면
		 *     엉뚱한 폴더에 덮어쓸 수 있다 (경로 조작 / path traversal)
		 *  2) 같은 이름을 올리면 앞 사람 파일을 덮어쓴다
		 *  3) 한글·공백·특수문자 때문에 OS마다 다르게 깨진다
		 * 그래서 이름은 서버가 UUID 로 새로 짓는다.
		 */
		String storedName = UUID.randomUUID().toString().replace("-", "") + "." + ext;

		Path dir = Paths.get(uploadDir).toAbsolutePath().normalize();
		Files.createDirectories(dir);

		Path target = dir.resolve(storedName).normalize();

		// 혹시라도 폴더 밖으로 나가면 저장하지 않는다 (2중 방어)
		if (!target.startsWith(dir)) {
			throw new IllegalStateException("잘못된 파일 경로입니다.");
		}

		file.transferTo(target.toFile());

		String webPath = trimEndSlash(webPrefix) + "/" + storedName;

		return new SavedFile(webPath, storedName, originalName);
	}


	/**
	 * 저장했던 파일을 지운다.
	 *
	 * 지우다 실패해도 예외를 던지지 않는다.
	 * 이 메소드는 보통 "실패해서 뒷정리하는 중" 이나 "재신청해서 옛 파일 치우는 중" 에
	 * 불리는데, 여기서 예외가 터지면 원래 알려주려던 진짜 원인이 묻혀버린다.
	 *
	 * @param webPath   DB 에 저장돼 있던 웹 경로 (/uploads/license/xxxx.png)
	 * @param uploadDir 디스크 저장 폴더
	 */
	public void delete(String webPath, String uploadDir) {

		if (webPath == null || webPath.isBlank()) {
			return;
		}

		try {
			// 웹 경로에서 파일 이름만 뽑는다
			String fileName = Paths.get(webPath).getFileName().toString();

			Path dir    = Paths.get(uploadDir).toAbsolutePath().normalize();
			Path target = dir.resolve(fileName).normalize();

			if (!target.startsWith(dir)) {
				return;
			}

			Files.deleteIfExists(target);

		} catch (Exception e) {
			// 로그만 남기고 넘어간다
			System.out.println("[FileUploadUtil] 파일 삭제 실패: " + webPath + " / " + e.getMessage());
		}
	}


	/** "사진.PNG" → "png", 확장자가 없으면 "" */
	private String extensionOf(String fileName) {
		if (fileName == null) {
			return "";
		}
		int dot = fileName.lastIndexOf('.');
		if (dot < 0 || dot == fileName.length() - 1) {
			return "";
		}
		return fileName.substring(dot + 1).toLowerCase(Locale.ROOT);
	}

	private String trimEndSlash(String s) {
		String v = (s == null) ? "" : s.trim();
		while (v.endsWith("/")) {
			v = v.substring(0, v.length() - 1);
		}
		return v;
	}
}
