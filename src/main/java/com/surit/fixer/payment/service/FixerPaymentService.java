package com.surit.fixer.payment.service;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.surit.fixer.payment.mapper.FixerPaymentMapper;
import com.surit.fixer.payment.model.dto.PaymentDTO;
import com.surit.fixer.payment.model.dto.PaymentDetailDTO;

@Service
@RequiredArgsConstructor
public class FixerPaymentService {

    private final FixerPaymentMapper paymentMapper;

    @Transactional // 하나라도 실패하면 영수증 생성 전체 롤백!
    public void processPaymentAndCompleteJob(PaymentDTO paymentInfo) {

        // 1. 마스터 테이블(PAYMENT)에 인서트 (이때 paymentId가 생성되어 세팅됨)
        paymentMapper.insertPayment(paymentInfo);

        // 2. 받아온 상세 내역(PAYMENT_DETAIL)들을 반복문으로 불러오기
        if (paymentInfo.getDetails() != null) {
            for (PaymentDetailDTO detail : paymentInfo.getDetails()) {
                detail.setPaymentId(paymentInfo.getPaymentId()); // 마스터에서 딴 ID를 넣어줌
                paymentMapper.insertPaymentDetail(detail);
            }
        }

        // 3. 작업 상태를 '완료'로 업데이트
        paymentMapper.updateRequestStatusToCompleted(paymentInfo.getRequestId());
    }
    
    // 기존 코드 아래에 이 메서드를 추가해 주세요.
    public PaymentDTO getPaymentByEstimateId(Long estimateId) {
        return paymentMapper.selectPaymentByEstimateId(estimateId);
    }
}
