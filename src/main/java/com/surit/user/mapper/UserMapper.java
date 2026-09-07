package com.surit.user.mapper;

import org.apache.ibatis.annotations.Mapper;

import com.surit.user.model.dto.UserDTO;
@Mapper
public interface UserMapper {

	//회원가입 -> 데이터 추가
	int insertUser(UserDTO user);
	
	// 아이디 중복확인 -> 데이터 조회
	int countByUserId(String userId);

	/**
	 * 이메일 중복확인.  2026-09-01 추가
	 *
	 * USERS.EMAIL 에 UNIQUE 제약이 걸려 있어서, 중복된 이메일로 INSERT 하면
	 * 오라클이 ORA-00001 을 던지고 스프링이 500 에러 페이지를 띄운다.
	 * 저장하기 전에 미리 세어보고 막는다.
	 */
	int countByEmail(String email);
	
	// 아이디를 통한 회원 조회
	UserDTO selectByUserId(String userId);
	
	//아이디 기준을 회원 삭제 -> 데이터 삭제
	int deleteUser(String userId);
	/** 내 정보 수정 (이름/전화번호/이메일, 비밀번호는 값이 있을 때만) */
	int updateUser(UserDTO user);
}
