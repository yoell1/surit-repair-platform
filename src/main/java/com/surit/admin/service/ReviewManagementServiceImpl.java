package com.surit.admin.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.surit.admin.model.dto.AdminLowRatedFixerDTO;
import com.surit.admin.model.dto.AdminReviewListDTO;
import com.surit.admin.model.dto.AdminReviewSearchCondition;
import com.surit.admin.model.mapper.ReviewManagementMapper;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class ReviewManagementServiceImpl implements ReviewManagementService {

	private final ReviewManagementMapper reviewMapper;

	@Override
	@Transactional(readOnly = true)
	public List<AdminReviewListDTO> getReviewList(AdminReviewSearchCondition cond) {
		
		// 잘못된 페이지 번호 방어
		if (cond.getPage() < 1) {
			cond.setPage(1);
		}
		
		cond.setOffset((cond.getPage() - 1) * cond.getSize());
		return reviewMapper.selectReviewList(cond);
	}

	@Override
	@Transactional(readOnly = true)
	public int getReviewCount(AdminReviewSearchCondition cond) {
		return reviewMapper.selectReviewCount(cond);
	}
	// DTO로 만든 검색조건을 int 타입으로 돌려주는, 아무나 쓸 수 있는 매서드

	@Override
	@Transactional(readOnly = true)
	public AdminReviewListDTO getReviewDetail(Long reviewId) {

		// 1) 꺼낸다
		AdminReviewListDTO review = reviewMapper.selectReviewDetail(reviewId);

		// 2) 확인한다
		if (review == null) {
			throw new IllegalArgumentException("존재하지 않는 리뷰입니다");
		}
		return review;
	}

	@Override
	@Transactional(readOnly = true)
	public List<AdminLowRatedFixerDTO> getLowRatedFixers() {
		return reviewMapper.selectLowRatedFixers();
	}

	@Override
	@Transactional
	public void warnFixer(Long fixerNo, String reason, String adminId) {

		// 2) 확인한다
		if (fixerNo == null) {
			throw new IllegalArgumentException("대상 기사가 없습니다");
		}
		if (reason == null || reason.isBlank()) {
			throw new IllegalArgumentException("경고 사유를 입력해 주세요");
		}
		if (adminId == null || adminId.isBlank()) {
			throw new IllegalStateException("관리자 로그인이 필요합니다");
		}

		// 3~4) 저장한다
		reviewMapper.insertWarning(fixerNo, reason, adminId);

		// 5) 남긴다 (TODO: AdminLogMapper)
	}
}