package com.surit.fixer.common.util;

import lombok.AllArgsConstructor;
import lombok.Getter;

/**
 * 파일을 저장하고 나서 돌려주는 정보.
 *
 * path      : DB 에 넣고 화면에서 <img src> 로 쓸 웹 경로 (예: /uploads/license/xxxx.png)
 * storedName: 디스크에 실제로 저장된 파일 이름 (UUID)
 * originalName : 사용자가 올린 원래 이름 (화면에 보여줄 때만 씀)
 */
@Getter
@AllArgsConstructor
public class SavedFile {

	private final String path;
	private final String storedName;
	private final String originalName;
}
