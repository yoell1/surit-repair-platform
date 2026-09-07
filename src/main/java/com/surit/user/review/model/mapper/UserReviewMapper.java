package com.surit.user.review.model.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.surit.user.model.dto.UserReviewDTO;

@Mapper
public interface UserReviewMapper {

    /** 특정 고객이 작성한 리뷰 목록 (최신순) */
    List<UserReviewDTO> selectReviewsByUserNo(@Param("userNo") Long userNo);

    /** 리뷰 등록 */
    int insertReview(UserReviewDTO review);

    /** 이 접수에 이미 리뷰를 썼는지 확인 */
    UserReviewDTO selectReviewByRequestId(@Param("requestId") Long requestId,
                                           @Param("userNo") Long userNo);
}