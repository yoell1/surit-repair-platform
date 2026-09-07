package com.surit.fixer.mypage.model.dto;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class FixerAddressDTO {

    private Long addressId;       // PK
    private Long fixerNo;         // 기사 번호 (USER_NO)

    private String alias;         // 주소 별칭 (예: 집, 작업실)
    private String zipcode;       // 우편번호
    private String baseAddress;   // 기본주소
    private String detailAddress; // 상세주소

    private String isDefault;     // 기본 주소 여부 ('Y' 또는 'N')
}