package com.surit.admin.model.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.surit.admin.model.dto.AdminLowRatedFixerDTO;
import com.surit.admin.model.dto.AdminReviewListDTO;
import com.surit.admin.model.dto.AdminReviewSearchCondition;

@Mapper
public interface ReviewManagementMapper {

	// --- 조회 ---
	List<AdminReviewListDTO> selectReviewList(AdminReviewSearchCondition cond);
	int selectReviewCount(AdminReviewSearchCondition cond);
	AdminReviewListDTO selectReviewDetail(Long reviewId);
	List<AdminLowRatedFixerDTO> selectLowRatedFixers();

	// --- 변경 ---
	int insertWarning(@Param("targetNo") Long targetNo,
	                  @Param("reason") String reason,
	                  @Param("adminId") String adminId);
}