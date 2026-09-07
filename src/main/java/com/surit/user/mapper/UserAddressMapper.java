package com.surit.user.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.surit.user.model.dto.UserAddressDTO;

@Mapper
public interface UserAddressMapper {

    /** 내 주소 목록 (기본 주소가 먼저 오도록 정렬) */
    List<UserAddressDTO> selectAddressesByUserNo(@Param("userNo") Long userNo);

    /** 주소 단건 조회 (내 주소가 아니면 null) */
    UserAddressDTO selectAddressById(@Param("addressId") Long addressId,
                                      @Param("userNo") Long userNo);

    /** 주소 신규 등록. INSERT 후 addressId 가 파라미터 객체에 채워짐 */
    int insertAddress(UserAddressDTO address);

    /** 주소 수정 (내 주소일 때만) */
    int updateAddress(UserAddressDTO address);

    /** 주소 삭제 (내 주소일 때만) */
    int deleteAddress(@Param("addressId") Long addressId,
                       @Param("userNo") Long userNo);

    /**
     * 기본 주소 해제.
     * 새 주소를 기본으로 설정하기 전에, 기존에 기본이었던 주소를 N으로 바꿔둔다.
     * (한 회원당 기본 주소는 항상 1개만 있어야 하므로)
     */
    int clearDefaultByUserNo(@Param("userNo") Long userNo);
    
	/** 이 회원이 가진 주소 개수. 3개 제한 검사용 */
	int countByUserNo(@Param("userNo") Long userNo);
}
