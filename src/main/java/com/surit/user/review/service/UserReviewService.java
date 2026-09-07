package com.surit.user.review.service;
 
import java.util.List;

import com.surit.user.model.dto.UserReviewDTO;
 
public interface UserReviewService {
 
	 
	   /** 특정 고객이 작성한 리뷰 목록 조회 (마이페이지 - 내가 쓴 리뷰) */
    List<UserReviewDTO> getReviewsByUserNo(Long userNo);
 
    /** 리뷰 작성 (이미 썼으면 예외) */
    void submitReview(Long requestId, Long userNo, Long fixerNo, Long score, String content);
 
    /** 이 접수에 이미 리뷰를 썼는지 (있으면 그 리뷰, 없으면 null) */
    UserReviewDTO getReviewByRequestId(Long requestId, Long userNo);
}