package com.surit.admin.model.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@AllArgsConstructor
@Data
public class AdminLowRatedFixerDTO {
	private Long userNo;
	private String userId;
	private String name;
	private Double avgScore;
	private Integer reviewCount;
}