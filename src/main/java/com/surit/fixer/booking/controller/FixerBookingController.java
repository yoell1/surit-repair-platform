package com.surit.fixer.booking.controller;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import com.surit.fixer.booking.service.FixerBookingService;
import com.surit.fixer.booking.model.dto.BookingDetailDTO;

@Slf4j
@Controller
@RequestMapping("/fixer/bookings")
@RequiredArgsConstructor
public class FixerBookingController {

    private final FixerBookingService bookingService;

    /**
     * 예약 상세(확정된 예약) 화면 조회
     */
    @GetMapping("/{requestId}")
    public String showBookingDetail(@PathVariable Long requestId, Model model) {
        BookingDetailDTO bookingDetail = bookingService.getBookingDetail(requestId);
        model.addAttribute("booking", bookingDetail);

        return "fixer/booking-detail"; // 예약 상세 JSP 경로
    }

    /**
     * 예약 확정 처리 (상태를 'SCHEDULED'로 변경)
     */
    @PostMapping("/{requestId}/confirm")
    public String confirmBooking(@PathVariable Long requestId) {
        log.info("예약 확정 처리 - 요청번호: {}", requestId);
        bookingService.updateBookingStatus(requestId, "REQ_03");	// 예약 확정 = 매칭완료

        return "redirect:/fixer/bookings/" + requestId;
    }

    /**
     * 예약 취소 처리 (안내문구에 따라 상태를 다시 'MATCHING'으로 되돌림)
     */
    @PostMapping("/{requestId}/cancel")
    public String cancelBooking(@PathVariable Long requestId) {
        log.info("예약 취소 처리 - 요청번호: {}", requestId);
        // 설계서 내용: "접수는 다시 매칭 상태로 돌아갑니다."
        bookingService.updateBookingStatus(requestId, "REQ_02");	// 예약 취소 = 견적중으로 되돌림

        // 취소 후에는 기사의 '내 작업(진행 중)' 목록 등으로 리다이렉트
        return "redirect:/fixer/jobs";
    }
}