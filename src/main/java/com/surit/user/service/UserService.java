package com.surit.user.service;

import java.io.IOException;

import com.surit.user.model.dto.UserAddressDTO;
import com.surit.user.model.dto.UserDTO;

public interface UserService {

	// 회원 가입 (기본 주소도 같이 받음)
	void sign(UserDTO user, UserAddressDTO address) throws IOException;

	// 아이디 중복체크
	boolean isUserIdCheck(String userId);

	// 이메일 중복체크 (2026-09-01 추가)
	boolean isEmailCheck(String email);

	// 로그인
	UserDTO login(String userId, String password);

	// 회원 탈퇴
	void withdraw(String userId);

	// 마이페이지 등에서 쓸 회원 정보 단건 조회
	UserDTO getUserInfo(String userId);
	/**
	 * 내 정보 수정 (이름/전화번호/이메일).
	 * 비밀번호는 form.getPassword() 가 비어있지 않을 때만 변경한다.

	 */
	UserDTO updateUserInfo(UserDTO form);
}