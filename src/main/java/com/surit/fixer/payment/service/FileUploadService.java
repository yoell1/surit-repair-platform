package com.surit.fixer.payment.service;

import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import java.io.File;
import java.io.IOException;
import java.util.UUID;

@Service
public class FileUploadService {

    // 로컬 저장소 경로
    private final String uploadDir = "C:/surit/uploads/";

    public String saveFile(MultipartFile file) throws IOException {
        if (file.isEmpty()) return null;

        // 폴더가 없으면 자동 생성
        File dir = new File(uploadDir);
        if (!dir.exists()) dir.mkdirs();

        // 파일 이름 중복 방지를 위해 UUID(랜덤 문자열) 적용
        String originalFilename = file.getOriginalFilename();
        String savedFilename = UUID.randomUUID().toString() + "_" + originalFilename;

        File dest = new File(uploadDir + savedFilename);
        file.transferTo(dest); // 실제 디스크에 파일 저장

        // DB에 저장될 접근 경로 반환
        return "/uploads/" + savedFilename;
    }
}