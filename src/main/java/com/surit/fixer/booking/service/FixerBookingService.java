package com.surit.fixer.booking.service;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.surit.fixer.booking.mapper.FixerBookingMapper;
import com.surit.fixer.booking.model.dto.BookingDetailDTO;

@Service
@RequiredArgsConstructor
public class FixerBookingService {

    private final FixerBookingMapper bookingMapper;

    public BookingDetailDTO getBookingDetail(Long requestId) {
        return bookingMapper.selectBookingDetail(requestId);
    }

    @Transactional
    public void updateBookingStatus(Long requestId, String status) {
        int result = bookingMapper.updateRequestStatus(requestId, status);
        if (result == 0) {
            throw new RuntimeException("예약 상태 변경에 실패했습니다.");
        }

        // TODO: (선택) 취소일 경우 "고객에게 알림이 갑니다" 설계에 맞춰 알림(Notification) DB 저장 로직 추가 가능
    }
}
