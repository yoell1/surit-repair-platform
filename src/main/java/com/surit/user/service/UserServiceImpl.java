package com.surit.user.service;

import java.io.IOException;

import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.surit.user.mapper.UserAddressMapper;
import com.surit.user.mapper.UserMapper;
import com.surit.user.model.dto.UserAddressDTO;
import com.surit.user.model.dto.UserDTO;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class UserServiceImpl implements UserService {

	private final UserMapper mapper;
	private final PasswordEncoder passwordencoder;
	private final UserAddressMapper addressMapper;

	@Override
	public void sign(UserDTO user, UserAddressDTO address) throws IOException {

	    if (isUserIdCheck(user.getUserId())) {
	        throw new IllegalStateException("이미 사용중인 아이디입니다.");
	    }

	    // 이메일 중복 검사 (2026-09-01 추가)
	    // USERS.EMAIL 에 UNIQUE 제약이 있어서, 여기서 안 막으면
	    // INSERT 단계에서 오라클이 ORA-00001 을 던지고 500 에러 페이지가 뜬다.
	    if (isEmailCheck(user.getEmail())) {
	        throw new IllegalStateException("이미 사용중인 이메일입니다.");
	    }
	    if (user.getPhone() == null || !user.getPhone().matches("^[0-9]+$")) {
	        throw new IllegalStateException("전화번호는 숫자만 입력해주세요.");
	    }

	    String encodePwd = passwordencoder.encode(user.getPassword());
	    user.setPassword(encodePwd);
	    mapper.insertUser(user);

	    if (address != null && address.getAddress() != null && !address.getAddress().isBlank()) {
	        address.setUserNo(user.getUserNo());
	        address.setIsDefault("Y");
	        addressMapper.insertAddress(address);
	    }
	}

	@Override
	public boolean isUserIdCheck(String userId) {
		return mapper.countByUserId(userId) > 0;
	}

	@Override
	public boolean isEmailCheck(String email) {
		if (email == null || email.isBlank()) {
			return false;   // 빈 값은 중복이 아니라 "미입력". 폼의 required 가 막는다
		}
		return mapper.countByEmail(email.trim()) > 0;
	}

	@Override
	public UserDTO login(String userId, String userPwd) throws IllegalStateException {
		UserDTO user = mapper.selectByUserId(userId);

		if (user == null || !passwordencoder.matches(userPwd, user.getPassword())) {
			throw new IllegalStateException("아이디 또는 비밀번호가 일치하지 않습니다.");
		}
		return user;
	}

	@Override
	public void withdraw(String userId) {
		UserDTO user = mapper.selectByUserId(userId);
		mapper.deleteUser(userId);
		// 프로필 이미지가 있는 경우 서버에서 이미지 파일 삭제 (FileUploadUtil)
	}

	@Override
	public UserDTO getUserInfo(String userId) {
	    return mapper.selectByUserId(userId);
	}
	@Override
	public UserDTO updateUserInfo(UserDTO form) {
	

	    // 비밀번호를 입력한 경우에만 암호화해서 넣고, 비워뒀으면 null 로 둬서
	    // UPDATE 쿼리의 <if> 조건이 스킵되게 한다 (기존 비밀번호 유지)
	    if (form.getPassword() != null && !form.getPassword().isBlank()) {
	        form.setPassword(passwordencoder.encode(form.getPassword()));
	    } else {
	        form.setPassword(null);
	    }
	    if (form.getPhone() == null || !form.getPhone().matches("^[0-9]{9,11}$")) {
	        throw new IllegalStateException("전화번호 형식이 올바르지 않습니다.");
	    }
	    mapper.updateUser(form);
 
	    // 최신 정보 다시 조회해서 반환 (세션 갱신용)
	    return mapper.selectByUserId(form.getUserId());
	}
}