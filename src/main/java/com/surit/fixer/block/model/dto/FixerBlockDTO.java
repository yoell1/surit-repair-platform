package com.surit.fixer.block.model.dto;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import java.time.LocalDateTime;

@Getter
@Setter
@NoArgsConstructor
public class FixerBlockDTO {
    private Long blockId;          // 차단 내역 PK
    private Long customerNo;       // 차단된 고객의 유저 번호
    private String customerName;   // 차단된 고객의 이름 (화면 출력용)
    private LocalDateTime createdAt; // 차단한 날짜
}
