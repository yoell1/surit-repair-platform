package com.surit.admin.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.surit.admin.model.dto.AdminFixerDetailDTO;
import com.surit.admin.model.dto.AdminMemberListDTO;
import com.surit.admin.model.dto.MemberSearchCondition;
import com.surit.admin.model.mapper.MemberManagementMapper;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class MemberManagementServiceImpl implements MemberManagementService {

	private final MemberManagementMapper memberMapper;
	
	// 기사 가입 승인 대기 기능
	@Override
	@Transactional(readOnly = true)
	public List<AdminMemberListDTO> getPendingFixers() {
		return memberMapper.selectPendingFixers();
	}
	/* public List<AdminMemberListDTO> getPendingFixers() -> 대기중인 기사명단 싹 긁어 오기
	 * return memberMapper.selectPendingFixers(); -> Mapper에게 조회를 시키고 결과를 그대로 돌려준다
	*/
	
	// 전체 회원 리스트 조회 기능 (회원, 기사)
	@Override
	@Transactional(readOnly = true)
	public List<AdminMemberListDTO> getMemberList(MemberSearchCondition cond) { 
		// 회원 목록 반환
		
		// 잘못된 페이지 번호 방어
		if (cond.getPage() < 1) {
			cond.setPage(1);
		}
		
		cond.setOffset((cond.getPage() - 1) * cond.getSize()); // 페이지 하나씩 건너뜀
		return memberMapper.selectMemberList(cond); // 계산이 채워진 cond를 통으로 Mapper 넘김
	}
	/*
	 * offset를 쓴 이유 : sql 번역기
	 */
	
	// 조건에 맞는 회원이 총 몇 명인지 세는 것
	@Override
	@Transactional(readOnly = true)
	public int getMemberCount(MemberSearchCondition cond) {
		return memberMapper.selectMemberCount(cond);
	}
	/*
	 * public int getMemberCount(MemberSearchCondition cond) -> 검색 조건을 받아서, 조건에 맞는 회원 수
	  를 int로 돌려준다. 
	 * return memberMapper.selectMemberCount(cond); -> Mapper에게 COUNT 조회를 시키고 결과를 그대로 돌려준다.
	 */
	
	// 기사 상세 기능
	@Override
	@Transactional(readOnly = true)
	public AdminFixerDetailDTO getFixerDetail(Long userNo) {

		// 1) 꺼낸다
		AdminFixerDetailDTO fixer = memberMapper.selectFixerDetail(userNo);

		// 2) 확인한다
		if (fixer == null) {
			throw new IllegalArgumentException("존재하지 않는 회원입니다");
		}

		// 3) 기사면 1:N 정보를 채운다
		if ("FIXER".equals(fixer.getUserRole())) {
			fixer.setLicenses(memberMapper.selectLicenses(userNo));
			fixer.setCategories(memberMapper.selectCategories(userNo));
			fixer.setRegions(memberMapper.selectRegions(userNo));
		}
		return fixer;
	}
	/*
	 * if ("FIXER".equals(fixer.getUserRole())) {	-> userRole이 fixer랑 일치하면 FIXER로 임명
			fixer.setLicenses(memberMapper.selectLicenses(userNo)); -> userNo가 일치하는 자격증 정보
			fixer.setCategories(memberMapper.selectCategories(userNo)); -> 수리 가능 카테고리
			fixer.setRegions(memberMapper.selectRegions(userNo)); -> 수리 가능 지역
			
			다 따로 조회하는 이유 : 이름 중복 방지
	 */

	
	@Override
	@Transactional
	public void approveFixer(Long userNo, Long adminNo) {

		// 1) 꺼낸다
		AdminFixerDetailDTO fixer = memberMapper.selectFixerDetail(userNo);

		// 2) 확인한다
		if (fixer == null) {
			throw new IllegalArgumentException("존재하지 않는 회원입니다");
		}
		//userRole이 'FIXER'랑 일치하지 않으면 throw new IllegalStateException("기사 계정이 아닙니다");
		if (!"FIXER".equals(fixer.getUserRole())) {
			throw new IllegalStateException("기사 계정이 아닙니다");
		}
		// getApprovalStatus(승인 상태)가 APPROVED면 throw new IllegalStateException("이미 승인된 기사입니다");
		if ("APPROVED".equals(fixer.getApprovalStatus())) {
			throw new IllegalStateException("이미 승인된 기사입니다");
		}
		// selectLicenses(자격증)이 Empty인 경우 throw new IllegalStateException("제출된 자격증이 없습니다");
		if (memberMapper.selectLicenses(userNo).isEmpty()) {
			throw new IllegalStateException("제출된 자격증이 없습니다");
		}

		// 3~4) 바꾸고 저장한다
		memberMapper.updateApprove(userNo);

		// 5) 남긴다 (TODO: AdminLogMapper)
	}
	
	// 기사 반려 기능
	@Override
	@Transactional
	public void rejectFixer(Long userNo, Long adminNo, String reason) {

		// 1) userNo와 일치하는 Fixer의 상세 정보를 꺼낸다 
		AdminFixerDetailDTO fixer = memberMapper.selectFixerDetail(userNo);

		// 2) fixer값이 null 이면 throw new IllegalArgumentException("존재하지 않는 회원입니다");
		if (fixer == null) {
			throw new IllegalArgumentException("존재하지 않는 회원입니다");
		}
		// reason 값이 null 이거나 reason 값이 Blank면 throw new IllegalArgumentException("반려 사유를 입력해 주세요");
		if (reason == null || reason.isBlank()) {
			throw new IllegalArgumentException("반려 사유를 입력해 주세요");
		}
		// ApprovalStatus()가 APPROVED와 일치하면 throw new IllegalStateException("이미 승인된 기사는 반려할 수 없습니다");
		if ("APPROVED".equals(fixer.getApprovalStatus())) {
			throw new IllegalStateException("이미 승인된 기사는 반려할 수 없습니다");
		}

		// 3~4) 바꾸고 저장한다
		memberMapper.updateReject(userNo, reason);

		// 5) 마음을 남긴다 (TODO: AdminLogMapper)
	}
}