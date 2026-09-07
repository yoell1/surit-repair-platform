package com.surit.fixer.mypage.service;

import com.surit.fixer.mypage.mapper.FixerMyPageMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;

@Service
public class FixerMyPageServiceImpl implements FixerMyPageService {

    private final FixerMyPageMapper mapper;

    @Autowired
    public FixerMyPageServiceImpl(FixerMyPageMapper mapper) {
        this.mapper = mapper;
    }

    @Override
    public List<Map<String, Object>> getAllCategories() {
        return mapper.selectAllCategories();
    }

    @Override
    public List<Map<String, Object>> getAllRegions() {
        return mapper.selectAllRegions();
    }

    @Override
    public List<String> getMyCategories(Long fixerId) {
        return mapper.selectMyCategories(fixerId);
    }

    @Override
    public List<String> getMyRegions(Long fixerId) {
        return mapper.selectMyRegions(fixerId);
    }

    @Override
    @Transactional
    public void updateCategories(Long fixerId, List<String> categories) {
        // 기존 데이터 삭제 후 새로 추가
        mapper.deleteMyCategories(fixerId);
        if (categories != null && !categories.isEmpty()) {
            for (String categoryCode : categories) {
                mapper.insertMyCategory(fixerId, categoryCode);
            }
        }
    }

    @Override
    @Transactional
    public void updateRegions(Long fixerId, List<String> regions) {
        mapper.deleteMyRegions(fixerId);
        if (regions != null && !regions.isEmpty()) {
            for (String regionCode : regions) {
                mapper.insertMyRegion(fixerId, regionCode);
            }
        }
    }
}