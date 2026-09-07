package com.surit.fixer.estimate.service;

import java.nio.charset.StandardCharsets;
import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.surit.common.request.model.dto.RequestDTO;
import com.surit.common.request.model.mapper.RequestMapper;
import com.surit.fixer.common.FixerGuard;
import com.surit.fixer.estimate.model.dto.EstimateDTO;
import com.surit.fixer.estimate.model.dto.EstimateForm;
import com.surit.fixer.estimate.model.mapper.EstimateMapper;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class EstimateServiceImpl implements EstimateService {

	/*
	 * 금액을 BigDecimal 이 아니라 long(원 단위 정수) 으로 다루는 이유 :
	 *  1) 원화만 지원하므로 소수점이 나올 일이 없다
	 *  2) 세금·할인·포인트처럼 나눗셈이 들어가는 계산이 없다
	 *     (기사가 예상 금액을 제시하고 고객이 확인하는 흐름뿐)
	 *  3) 이 DTO 를 쓰는 다른 기능에서 BigDecimal 전용 연산 메소드를
	 *     따로 써야 하는 부담이 생긴다
	 *  → 팀 합의로 전부 Long 통일
	 */

	/** 견적 금액 상한. 실수로 0 을 몇 개 더 붙이는 걸 막는다 */
	private static final long MAX_PRICE        = 100_000_000L;   // 1억 원
	private static final long MAX_DURATION_MIN = 60L * 24 * 30;  // 30일(분)

	/*
	 * 견적 설명 길이 상한 (2026-09-02 변경).
	 *
	 * 원래는 content.length() > 1000 이었다. 즉 "글자 수" 로 셌다.
	 * 그런데 ESTIMATES.CONTENT 는 VARCHAR2(4000 BYTE) 라서
	 * 오라클은 "바이트" 로 센다. 세는 단위가 서로 달랐다.
	 *
	 * 당장 터지지는 않았다. 1000자를 통과시켜도 한글은 1자 3바이트라
	 * 최악이 3000바이트여서 4000바이트 안에 들어왔기 때문이다.
	 * 즉 안전했던 이유가 "여유가 우연히 남아서" 였다.
	 * 나중에 누군가 설명이 짧다며 2000자로 올리면
	 * 한글 2000자 = 6000바이트가 되어 그 순간 ORA-12899 가 난다.
	 *
	 * 자기소개(FIXER_PROFILE.INTRO)에서 같은 이유로 실제 장애가 났었다.
	 * 그래서 여기도 컬럼과 같은 단위(바이트)로 맞춘다.
	 */
	private static final int CONTENT_MAX_BYTES = 4000;

	private final EstimateMapper mapper;
	private final RequestMapper  requestMapper;
	private final FixerGuard     fixerGuard;

	@Override
	@Transactional(readOnly = true)
	public RequestDTO getTargetRequest(long fixerNo, long requestId) {

		fixerGuard.requireApprovedFixer(fixerNo);

		RequestDTO request = requestMapper.selectRequestDetail(fixerNo, requestId);
		if (request == null) {
			throw new IllegalStateException("견적을 낼 수 없는 접수입니다.");
		}
		return request;
	}

	@Override
	@Transactional(rollbackFor = Exception.class)
	public void submit(long fixerNo, EstimateForm form) {

		fixerGuard.requireApprovedFixer(fixerNo);
		validate(form);

		// 내 분야/지역이 맞는 접수인지, 차단한 고객은 아닌지 확인.
		// (열려 있는지 / 중복인지는 아래 INSERT 의 WHERE 가 다시 확인한다)
		RequestDTO target = requestMapper.selectRequestDetail(fixerNo, form.getRequestId());
		if (target == null) {
			throw new IllegalStateException("견적을 낼 수 없는 접수입니다.");
		}

		EstimateDTO estimate = new EstimateDTO();
		estimate.setRequestId(form.getRequestId());
		estimate.setFixerNo(fixerNo);   // 폼이 아니라 세션에서 온 값.
		                                // 폼으로 받으면 개발자도구로 바꿔서 남의 이름으로 견적을 낼 수 있다.
		estimate.setEstimatedPrice(form.getEstimatedPrice());
		estimate.setEstimatedDuration(form.getEstimatedDuration());
		estimate.setContent(form.getContent());

		int inserted = mapper.insertEstimate(estimate);
		if (inserted == 0) {
			// WHERE 조건에 걸려서 안 들어갔다. 어느 조건인지 여기서 구분해준다.
			if (mapper.countMyEstimate(form.getRequestId(), fixerNo) > 0) {
				throw new IllegalStateException("이미 이 접수에 견적을 제출했습니다.");
			}
			throw new IllegalStateException("이미 마감된 접수입니다. 목록을 새로고침해주세요.");
		}

		// 접수대기 → 견적중. 이미 견적중이면 0건이지만 그건 정상이라 확인하지 않는다.
		mapper.updateRequestToEstimating(form.getRequestId());
	}

	@Override
	@Transactional(readOnly = true)
	public List<EstimateDTO> getMyEstimates(long fixerNo) {

		fixerGuard.requireApprovedFixer(fixerNo);
		return mapper.selectMyEstimates(fixerNo);
	}

	/*
	 * 화면(estimateForm.jsp)에서도 같은 조건을 먼저 검사한다.
	 * 화면 검사는 "여기까지 오기 전에 멈춰서 입력값을 지켜주는" 용도이고,
	 * 실제 차단은 이 메소드가 한다.
	 * 자바스크립트를 끄거나 개발자도구로 값을 바꿔서 보내면
	 * 화면 검사는 통째로 건너뛰어지기 때문이다.
	 */
	private void validate(EstimateForm form) {

		if (form.getRequestId() == null) {
			throw new IllegalStateException("접수 번호가 없습니다.");
		}

		// null 검사를 먼저 한 뒤에 비교한다.
		// Long 은 참조형이라 값이 없으면 null 이고, 그 상태로 < > 비교를 하면
		// 자동 언박싱 과정에서 NullPointerException 이 난다.
		Long price = form.getEstimatedPrice();
		if (price == null) {
			throw new IllegalStateException("예상 금액을 입력해주세요.");
		}
		if (price < 0) {
			throw new IllegalStateException("예상 금액은 0원 이상이어야 합니다.");
		}
		if (price > MAX_PRICE) {
			throw new IllegalStateException("예상 금액이 너무 큽니다. 최대 1억 원까지 입력할 수 있습니다.");
		}

		Long duration = form.getEstimatedDuration();
		if (duration == null || duration <= 0) {
			throw new IllegalStateException("예상 소요 시간(분)을 입력해주세요.");
		}
		if (duration > MAX_DURATION_MIN) {
			throw new IllegalStateException("예상 소요 시간이 너무 깁니다. 최대 30일(43,200분)까지 입력할 수 있습니다.");
		}

		String content = form.getContent();
		if (content == null || content.isBlank()) {
			throw new IllegalStateException("견적 설명을 입력해주세요.");
		}

		/*
		 * 글자 수가 아니라 UTF-8 바이트로 센다.
		 * ESTIMATES.CONTENT 가 VARCHAR2(4000 BYTE) 라 오라클도 바이트로 센다.
		 * 여기서 글자 수로 세면 세는 단위가 달라지고,
		 * 어긋난 만큼이 그대로 ORA-12899 로 튀어나온다.
		 */
		int bytes = content.getBytes(StandardCharsets.UTF_8).length;
		if (bytes > CONTENT_MAX_BYTES) {
			throw new IllegalStateException(
				"견적 설명이 너무 깁니다. 한글 기준 약 1,300자까지 입력할 수 있습니다. (현재 "
				+ bytes + "바이트 / 최대 " + CONTENT_MAX_BYTES + "바이트)");
		}
	}
}