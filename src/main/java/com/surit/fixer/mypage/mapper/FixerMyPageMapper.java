package com.surit.fixer.mypage.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.util.List;
import java.util.Map;

@Mapper
public interface FixerMyPageMapper {
    List<Map<String, Object>> selectAllCategories();
    List<Map<String, Object>> selectAllRegions();

    List<String> selectMyCategories(Long fixerId);
    List<String> selectMyRegions(Long fixerId);

    void deleteMyCategories(Long fixerId);
    void insertMyCategory(@Param("fixerId") Long fixerId, @Param("categoryCode") String categoryCode);

    void deleteMyRegions(Long fixerId);
    void insertMyRegion(@Param("fixerId") Long fixerId, @Param("regionCode") String regionCode);
}