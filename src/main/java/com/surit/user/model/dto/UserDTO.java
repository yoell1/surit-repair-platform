package com.surit.user.model.dto;

import java.sql.Timestamp;

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
	
public class UserDTO {
	private Long userNo;
	private String userId;
	private String email;
	private String password;
	private String name;
	private String phone;
	private String userRole;
	private String status;
	private Timestamp createdAt; 
	
}
