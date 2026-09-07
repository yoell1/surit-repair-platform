package com.surit.fixer.job.model.dto;

/**
 * REPAIR_REQUESTS.STATUS_CODE 값 (COMMON_CODE 의 STATUS 그룹).
 *
 * 문자열을 여기저기 그대로 적으면 'REQ_03' 을 'REQ_3' 으로 잘못 쓴 걸
 * 컴파일러가 못 잡아준다. 상수로 모아두면 오타는 컴파일 에러가 된다.
 */
public final class JobStatus {

	/** 접수대기 */
	public static final String WAITING   = "REQ_01";
	/** 견적중 */
	public static final String ESTIMATING = "REQ_02";
	/** 매칭완료 → 기사가 실제로 작업할 단계 (결제는 수리완료 후 F-19 에서) */
	public static final String MATCHED   = "REQ_03";
	/** 수리완료 */
	public static final String DONE      = "REQ_04";

	/** 상수만 모아둔 클래스라 인스턴스를 만들 이유가 없다 */
	private JobStatus() {}
}
