package com.surit.admin.model.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.surit.admin.model.dto.AdminRequestListDTO;
import com.surit.admin.model.dto.AdminRequestSearchCondition;
import com.surit.admin.model.dto.AdminStatusCountDTO;

@Mapper
public interface RequestManagementMapper {

	/** 상태별 건수 (KPI 카드) */
	List<AdminStatusCountDTO> selectStatusCounts();

	/** 접수 목록 (검색 + 페이징) */
	List<AdminRequestListDTO> selectRequestList(AdminRequestSearchCondition cond);

	/** 검색 조건에 맞는 전체 건수 */
	int selectRequestCount(AdminRequestSearchCondition cond);
}