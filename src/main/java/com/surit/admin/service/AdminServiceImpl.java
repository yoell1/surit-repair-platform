package com.surit.admin.service;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.surit.admin.model.dto.AdminDTO;
import com.surit.admin.model.dto.AdminLoginRequest;
import com.surit.admin.model.dto.AdminResponse;
import com.surit.admin.model.mapper.AdminMapper;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class AdminServiceImpl implements AdminService {

	private final AdminMapper adminMapper;
	private final BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();

	@Override
	@Transactional(readOnly = true)
	public AdminResponse login(AdminLoginRequest request) {

		// 1) 꺼낸다
		AdminDTO admin = adminMapper.selectByAdminId(request.getAdminId());

		// 2) 확인한다
		if (admin == null) {
			throw new IllegalArgumentException("아이디 또는 비밀번호가 올바르지 않습니다");
		}
		
		if (!passwordEncoder.matches(request.getAdminPwd(), admin.getAdminPwd())) {
			throw new IllegalArgumentException("아이디 또는 비밀번호가 올바르지 않습니다");
		}

		// 3) 비밀번호 없는 응답으로 변환해서 반환
		return new AdminResponse(admin.getAdminId(), admin.getAdminName());
	}
}