package com.surit.fixer.verify.model.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.surit.fixer.estimate.model.dto.EstimateDTO;
import com.surit.fixer.verify.model.dto.FixerLicenseDTO;
import com.surit.fixer.verify.model.dto.FixerProfileDTO;

@Mapper
public interface FixerMapper {

	// ---------- 조회 ----------

	/** 기사 프로필 (신청 이력이 있는지 확인용). 없으면 null */

	FixerProfileDTO selectFixerProfile(Long userNo);

	/** 기사가 등록한 자격증 목록 (재신청 시 기존 파일 삭제용) */
	List<FixerLicenseDTO> selectLicensesByUserNo(Long userNo);


	// ---------- 등록 / 수정 ----------

	int insertFixerProfile(FixerProfileDTO profile);   // 신규 신청
	int updateFixerProfile(FixerProfileDTO profile);   // 재신청

	int insertFixerLicense(FixerLicenseDTO license);

	int insertFixerRegion(@Param("userNo") Long userNo,
	                      @Param("regionCode") String regionCode);

	int insertFixerCategory(@Param("userNo") Long userNo,
	                        @Param("categoryCode") String categoryCode);

	 
	/** 고객이 보는 기사 공개 프로필 (이름 + 평점/리뷰수 포함) */
	FixerProfileDTO selectPublicProfile(Long userNo);
	 
	// ---------- 삭제 (재신청 시 기존 데이터 정리) ----------

	int deleteLicensesByUserNo(Long userNo);
	int deleteRegionsByUserNo(Long userNo);
	int deleteCategoriesByUserNo(Long userNo);
	 
	// ---------- 기사 공개 프로필 화면용 ----------

	List<String> selectFixerCategoryNames(Long userNo);
	 
	List<String> selectFixerRegionNames(Long userNo);
	 
	Long selectCompletedJobCount(Long userNo);
	 
	EstimateDTO selectEstimateByRequestAndFixer(@Param("requestId") Long requestId,
	                                             @Param("fixerNo") Long fixerNo);
	 
}