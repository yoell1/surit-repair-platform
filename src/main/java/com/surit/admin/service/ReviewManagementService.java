package com.surit.admin.service;

import java.util.List;

import com.surit.admin.model.dto.AdminLowRatedFixerDTO;
import com.surit.admin.model.dto.AdminReviewListDTO;
import com.surit.admin.model.dto.AdminReviewSearchCondition;

public interface ReviewManagementService {

	List<AdminReviewListDTO> getReviewList(AdminReviewSearchCondition cond);
	int getReviewCount(AdminReviewSearchCondition cond);
	AdminReviewListDTO getReviewDetail(Long reviewId);
	List<AdminLowRatedFixerDTO> getLowRatedFixers();

	void warnFixer(Long fixerNo, String reason, String adminId);
}