package com.surit.admin.service;

import java.util.List;

import com.surit.admin.model.dto.AdminFixerDetailDTO;
import com.surit.admin.model.dto.AdminMemberListDTO;
import com.surit.admin.model.dto.MemberSearchCondition;

public interface MemberManagementService {

	List<AdminMemberListDTO> getPendingFixers();
	List<AdminMemberListDTO> getMemberList(MemberSearchCondition cond);
	int getMemberCount(MemberSearchCondition cond);
	AdminFixerDetailDTO getFixerDetail(Long userNo);

	void approveFixer(Long userNo, Long adminNo);
	void rejectFixer(Long userNo, Long adminNo, String reason);
}	