package com.surit.admin.service;

import com.surit.admin.model.dto.AdminLoginRequest;
import com.surit.admin.model.dto.AdminResponse;

public interface AdminService {

	AdminResponse login(AdminLoginRequest request);
}