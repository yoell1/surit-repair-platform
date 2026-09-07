package com.surit.user.model.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@ToString
	
public class UserAddressDTO {
	 private Long addressId;
	 private Long userNo;
	 private String address;
	 private String addressDetail;
	 private String isDefault; 
	 private String addressName;
}
