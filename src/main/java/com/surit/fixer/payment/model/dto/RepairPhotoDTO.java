package com.surit.fixer.payment.model.dto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class RepairPhotoDTO {
    private Long photoId;       // PK
    private Long requestId;     // 수리 요청 ID
    private String photoPath;   // 파일이 저장된 실제 경로 (/uploads/...)
    private String photoType;   // BEFORE (수리 전) / AFTER (수리 후)
    private Long fileSize;      // 파일 용량
}
