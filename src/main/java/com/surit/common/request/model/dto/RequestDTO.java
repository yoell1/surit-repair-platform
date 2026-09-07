package com.surit.common.request.model.dto;

import java.sql.Timestamp;
import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * REPAIR_REQUESTS 한 줄 + 화면에 같이 보여줄 조인 결과.
 *
 * REQUEST_ID 는 IDENTITY 라 INSERT 할 때 넣지 않는다.
 */
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class RequestDTO {

	// ---- REPAIR_REQUESTS 컬럼 ----
	private Long      requestId;
	private Long      userNo;          // 의뢰한 고객
	private String    categoryCode;
	private String    title;
	private String    content;
	private String    serviceAddress;
	private String    statusCode;
	private Timestamp createdAt;
	
	private String visitDate;
	private String visitTimeCode;

	/**
	 * 긴급 신청 여부. 체크하면 "Y", 체크 안 하면 파라미터가 아예 안 넘어와 null 이다.
	 * (2026-09-02 추가)
	 *
	 * REPAIR_REQUESTS 에 이런 컬럼은 없다. 긴급 여부를 STATUS_CODE 의 REQ_99 로
	 * 표현하기로 해서, 이 값은 화면에서 서비스까지만 전달되고
	 * createRequest() 에서 상태 코드로 바뀐 뒤 버려진다.
	 *
	 * 상태 칸 하나에 진행 단계와 긴급 여부를 같이 담는 방식이라
	 * 매칭(REQ_03)되는 순간 긴급이었다는 사실이 사라진다.
	 * REPAIR_REQUESTS 에 IS_URGENT 컬럼이 생기면 이 필드를 그 컬럼에 그대로
	 * 매핑하고 상태 코드는 건드리지 않는 것이 맞다.
	 */
	private String urgentYn;

	// ---- 조인해서 가져오는 값 ----
	private String  categoryName;      // COMMON_CODE.CODE_NAME
	private String  statusName;        // COMMON_CODE.CODE_NAME
	private String  customerName;      // USERS.NAME
    private Long estimateCount;     // 이 접수에 달린 견적 수


	/**
	 * 내가 이미 이 접수에 견적을 냈으면 그 ESTIMATE_ID, 아니면 null.
	 * 목록에서 접수 하나마다 따로 조회하면 N+1 이 되니까
	 * 목록 SQL 안에서 스칼라 서브쿼리로 한 번에 가져온다.
	 */
	private Long myEstimateId;

	// ---- 상세 화면에서만 채운다 ----
	private List<RequestPhotoDTO> photos;
}