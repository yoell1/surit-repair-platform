package com.surit.fixer.payment.mapper;

import org.apache.ibatis.annotations.Mapper;
import com.surit.fixer.payment.model.dto.PaymentDTO;
import com.surit.fixer.payment.model.dto.PaymentDetailDTO;

@Mapper
public interface FixerPaymentMapper {
    // 1. 영수증 마스터 인서트
    int insertPayment(PaymentDTO payment);
    // 2. 영수증 상세 내역 인서트
    int insertPaymentDetail(PaymentDetailDTO detail);
    // 3. 수리 요청 상태를 '완료(COMPLETED)'로 변경
    int updateRequestStatusToCompleted(Long requestId);
    
    // 기존 코드 아래에 이 코드를 추가해 주세요.
    PaymentDTO selectPaymentByEstimateId(Long estimateId);
}