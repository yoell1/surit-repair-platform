package com.surit.fixer.booking.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import com.surit.fixer.booking.model.dto.BookingDetailDTO;

@Mapper
public interface FixerBookingMapper {
    // 예약 상세 정보 조회
    BookingDetailDTO selectBookingDetail(Long requestId);

    // 예약 상태 업데이트 (확정 or 취소)
    int updateRequestStatus(@Param("requestId") Long requestId, @Param("status") String status);
}