// [1] 파일: com.surit.user.service.UserAddressService (신규 인터페이스)
// ==========================================================
package com.surit.user.address.service;
 
import java.util.List;

import com.surit.user.model.dto.UserAddressDTO;
 
public interface UserAddressService {
 
    List<UserAddressDTO> getAddressesByUserNo(Long userNo);
 
    UserAddressDTO getAddress(Long addressId, Long userNo);
 
    void insertAddress(UserAddressDTO address);
 
    void updateAddress(UserAddressDTO address);
 
    void deleteAddress(Long addressId, Long userNo);
}