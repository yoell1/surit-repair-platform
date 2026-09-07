package com.surit.user.review.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.surit.user.model.dto.UserReviewDTO;
import com.surit.user.review.model.mapper.UserReviewMapper;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class UserReviewServiceImpl implements UserReviewService {

    private final UserReviewMapper mapper;

    /** 특정 고객이 작성한 리뷰 목록 조회 (마이페이지 - 내가 쓴 리뷰) */
    @Override
    @Transactional(readOnly = true)
    public List<UserReviewDTO> getReviewsByUserNo(Long userNo) {
        return mapper.selectReviewsByUserNo(userNo);
    }

    /** 리뷰 작성 (이미 썼으면 예외) */
    @Override
    @Transactional
    public void submitReview(Long requestId, Long userNo, Long fixerNo, Long score, String content) {

        if (mapper.selectReviewByRequestId(requestId, userNo) != null) {
            throw new IllegalStateException("이미 리뷰를 작성한 접수입니다.");
        }

        UserReviewDTO review = new UserReviewDTO();
        review.setRequestId(requestId);
        review.setUserNo(userNo);
        review.setFixerNo(fixerNo);
        review.setScore(score);
        review.setContent(content);

        mapper.insertReview(review);
    }

    /** 이 접수에 이미 리뷰를 썼는지 (있으면 그 리뷰, 없으면 null) */
    @Override
    @Transactional(readOnly = true)
    public UserReviewDTO getReviewByRequestId(Long requestId, Long userNo) {
        return mapper.selectReviewByRequestId(requestId, userNo);
    }
}