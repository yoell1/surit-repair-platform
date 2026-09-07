
// ==========================================================
package com.surit.user.address.service;
 
import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.surit.user.mapper.UserAddressMapper;
import com.surit.user.model.dto.UserAddressDTO;

import lombok.RequiredArgsConstructor;
 
@Service
@RequiredArgsConstructor
public class UserAddressServiceImpl implements UserAddressService {
 
    private final UserAddressMapper mapper;
 
    @Override
    @Transactional(readOnly = true)
    public List<UserAddressDTO> getAddressesByUserNo(Long userNo) {
        return mapper.selectAddressesByUserNo(userNo);
    }
 
    @Override
    @Transactional(readOnly = true)
    public UserAddressDTO getAddress(Long addressId, Long userNo) {
        return mapper.selectAddressById(addressId, userNo);
    }
 
	@Override
	@Transactional
	public void insertAddress(UserAddressDTO address) {

		// ★ 주소는 3개까지. 화면의 <c:if> 는 버튼만 숨길 뿐이라
		//   새로고침 안 한 페이지나 연속 클릭으로 뚫린다. 여기서 막아야 한다.
		if (mapper.countByUserNo(address.getUserNo()) >= 3) {
			throw new IllegalStateException("주소는 최대 3개까지 등록할 수 있습니다.");
		}

		if ("Y".equals(address.getIsDefault())) {
			mapper.clearDefaultByUserNo(address.getUserNo());
		}
		mapper.insertAddress(address);
	}
 
    @Override
    @Transactional
    public void updateAddress(UserAddressDTO address) {
 
        // 내 주소가 맞는지 확인
        UserAddressDTO existing = mapper.selectAddressById(address.getAddressId(), address.getUserNo());
        if (existing == null) {
            throw new IllegalStateException("존재하지 않거나 접근할 수 없는 주소입니다.");
        }
 
        if ("Y".equals(address.getIsDefault())) {
            mapper.clearDefaultByUserNo(address.getUserNo());
        }
 
        mapper.updateAddress(address);
    }
 
    @Override
    @Transactional
    public void deleteAddress(Long addressId, Long userNo) {
 
        UserAddressDTO existing = mapper.selectAddressById(addressId, userNo);
        if (existing == null) {
            throw new IllegalStateException("존재하지 않거나 접근할 수 없는 주소입니다.");
        }
 
        mapper.deleteAddress(addressId, userNo);
    }
}