package com.surit.fixer.payment.model.dto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class PaymentDetailDTO {
    private Long detailId;
    private Long paymentId;
    private String itemCode;
    private String itemName;
    private Integer quantity;
    private Long unitPrice;
}
