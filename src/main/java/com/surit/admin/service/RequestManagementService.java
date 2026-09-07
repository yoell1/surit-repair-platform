package com.surit.admin.service;

import java.util.List;

import com.surit.admin.model.dto.AdminRequestListDTO;
import com.surit.admin.model.dto.AdminRequestSearchCondition;
import com.surit.admin.model.dto.AdminStatusCountDTO;

public interface RequestManagementService {

	List<AdminStatusCountDTO> getStatusCounts();
	List<AdminRequestListDTO> getRequestList(AdminRequestSearchCondition cond);
	int getRequestCount(AdminRequestSearchCondition cond);
}