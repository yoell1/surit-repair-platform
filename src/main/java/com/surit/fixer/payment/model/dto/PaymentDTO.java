package com.surit.fixer.payment.model.dto;

import lombok.Getter;
import lombok.Setter;
import java.util.List;

@Getter
@Setter
public class PaymentDTO {
    private Long paymentId;      // 결제 ID (PK)
    private Long requestId;      // 예약/요청 ID
    private Long fixerNo;        // 기사 번호
    private Long totalAmount;    // 총 결제 금액
    private String paymentMethod; // 결제 수단 (CARD, CASH 등)

    // 여러 개의 상세 내역을 리스트로 한 번에 받음
    private List<PaymentDetailDTO> details;
}
