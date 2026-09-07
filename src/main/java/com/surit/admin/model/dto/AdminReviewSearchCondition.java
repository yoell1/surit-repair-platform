package com.surit.admin.model.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class AdminReviewSearchCondition {
	private Long score;      // null이면 전체, 1~5
	private boolean lowOnly;    // true면 3점 이하만 나오게
	private String keyword;     // 기사명 / 고객명

	private int size = 10;
	private int page = 1;
	private int offset;
}