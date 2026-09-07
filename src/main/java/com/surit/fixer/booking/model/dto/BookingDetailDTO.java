package com.surit.fixer.booking.model.dto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class BookingDetailDTO {
    private Long requestId;
    private String visitDate;      // 방문 일시 (예: 08.14 14:00~16:00)
    private String visitAddress;   // 방문 주소 (예: 강남구 언주로 30, 302호)
    private String customerName;   // 고객 이름 (예: 이수민)
    private String status;         // 현재 상태 (SCHEDULED, MATCHING 등)
}