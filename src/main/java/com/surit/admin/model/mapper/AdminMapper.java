package com.surit.admin.model.mapper;

import org.apache.ibatis.annotations.Mapper;

import com.surit.admin.model.dto.AdminDTO;

@Mapper
public interface AdminMapper {

	AdminDTO selectByAdminId(String adminId);
}


