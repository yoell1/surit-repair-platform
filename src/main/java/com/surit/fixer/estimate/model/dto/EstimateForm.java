package com.surit.fixer.estimate.model.dto;


import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * 견적 작성 폼에서 받는 값만 담는 DTO.
 *
 * EstimateDTO 를 그대로 @ModelAttribute 로 받으면
 * 사용자가 요청에 status=SELECTED, fixerNo=3 을 끼워 넣었을 때
 * 그 값이 그대로 들어가 버린다(대량 할당 취약점).
 * 그래서 "사용자가 정해도 되는 값" 만 있는 폼 DTO 를 따로 둔다.
 */
@Getter
@Setter
@NoArgsConstructor
public class EstimateForm {

	private Long requestId;
	private Long estimatedPrice;      // 원 단위 정수 (소수점 없음)
	private Long estimatedDuration;   // 예상 소요 시간(분)
	private String     content;
}