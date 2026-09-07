package com.surit.fixer.mypage.service;

import java.util.List;
import java.util.Map;

public interface FixerMyPageService {

    // 공통 코드 가져오기
    List<Map<String, Object>> getAllCategories();
    List<Map<String, Object>> getAllRegions();

    // 기사가 기존에 선택한 데이터 가져오기
    List<String> getMyCategories(Long fixerId);
    List<String> getMyRegions(Long fixerId);

    // 데이터 저장 (업데이트)
    void updateCategories(Long fixerId, List<String> categories);
    void updateRegions(Long fixerId, List<String> regions);
}