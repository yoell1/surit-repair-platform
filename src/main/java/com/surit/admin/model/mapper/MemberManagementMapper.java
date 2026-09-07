package com.surit.admin.model.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.surit.admin.model.dto.AdminFixerDetailDTO;
import com.surit.admin.model.dto.AdminMemberListDTO;
import com.surit.admin.model.dto.MemberSearchCondition;
import com.surit.fixer.verify.model.dto.FixerLicenseDTO;

@Mapper
public interface MemberManagementMapper {

	// --- 조회 ---
	List<AdminMemberListDTO> selectPendingFixers();  // 대기 기사 명단
	List<AdminMemberListDTO> selectMemberList(MemberSearchCondition cond); // 전체 회원 조회 
	int selectMemberCount(MemberSearchCondition cond); // 페이지 개수 
	AdminFixerDetailDTO selectFixerDetail(Long userNo); // 기사 상세
	List<FixerLicenseDTO> selectLicenses(Long userNo); // 자격증
	List<String> selectCategories(Long userNo); // 수리 카테고리
	List<String> selectRegions(Long userNo); // 활동 지역

	// 계정 승인/반려 (변경 되는 것들)
	int updateApprove(@Param("userNo") Long userNo); // 승인
	int updateReject(@Param("userNo") Long userNo, 	// 반려
	                 @Param("reason") String reason);
}