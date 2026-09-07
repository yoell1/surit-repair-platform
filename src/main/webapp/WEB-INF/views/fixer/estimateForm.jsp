<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>
<%@ include file="common/icons.jspf" %>
<c:set var="navActive" value="requests"/>

<div class="container" style="max-width:900px">

	<div class="page-head page-head--plain">
		<h1>예상 견적 제시</h1>
		<p>보낸 견적은 고객의 기사 목록에 바로 노출됩니다.</p>
	</div>

	<c:if test="${not empty message}">
		<div class="note note--warn" style="margin-bottom:24px">
			<svg><use href="#i-alert"/></svg>
			<span><c:out value="${message}"/></span>
		</div>
	</c:if>

	<!-- 접수 내용 -->
	<div class="card">
		<div class="card__head"><h2 class="card__title">접수 내용</h2></div>
		<dl class="dl--inline">
			<dt>제목</dt><dd><c:out value="${repair.title}"/></dd>
			<dt>분야</dt><dd><c:out value="${repair.categoryName}"/></dd>
			<dt>주소</dt><dd><c:out value="${repair.serviceAddress}"/></dd>
		</dl>
		<div style="margin-top:20px;padding-top:20px;border-top:1px solid var(--g-100)">
			<div class="field__label" style="margin-bottom:8px">증상</div>
			<p style="font-size:16px;line-height:1.8;color:var(--g-700);white-space:pre-wrap;margin:0"><c:out value="${repair.content}"/></p>
		</div>
	</div>

	<%--
		novalidate 를 붙인 이유 (2026-09-02 추가) :

		required / min / max 를 그대로 두면 브라우저 기본 검증이
		submit 이벤트보다 먼저 걸린다. 그러면 아래에 만든 검사 코드가
		아예 실행되지 않아서, 오류를 한 번에 모아 보여줄 수 없고
		"금액 상한" 처럼 브라우저가 모르는 규칙은 검사되지도 않는다.

		그래서 브라우저 검증을 끄고 제출 자체를 여기서 멈춘다.
		여기서 멈추면 페이지가 다시 뜨지 않으므로
		금액·시간·설명이 입력한 그대로 남는다.

		속성 자체는 남겨둔다. 자바스크립트가 꺼진 환경에서는
		novalidate 도 의미가 없어지고 브라우저 검증이 다시 살아난다.
	--%>
	<form action="/fixer/estimates" method="post" novalidate>

		<%-- CSRF 를 켜둔 프로젝트에서만 토큰이 만들어진다. 없으면 이 줄은 그냥 건너뛴다 --%>
		<c:if test="${not empty _csrf}">
			<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
		</c:if>

		<%--
			requestId 는 화면에 보이지 않게 hidden 으로 넘긴다.
			단, 사용자가 이 값을 바꿔서 보낼 수 있으므로
			서버에서 "내가 볼 수 있는 접수인가" 를 다시 확인한다.
		--%>
		<input type="hidden" name="requestId" value="${repair.requestId}"/>

		<div class="card" style="border-color:var(--p-200)">
			<div class="card__head">
				<h2 class="card__title">견적 입력</h2>
				<span class="muted" style="font-size:15px">현장 확인 후 달라질 수 있는 참고 금액입니다</span>
			</div>

			<div class="field-row">
				<div class="field">
					<label class="field__label" for="estimatedPrice">예상 금액 (원)<span class="req">*</span></label>
					<input class="input" id="estimatedPrice" type="number" name="estimatedPrice"
					       min="0" max="100000000" step="1000" required placeholder="예) 75000">
					<div class="field__help">원 단위 정수로 입력합니다. 최대 1억 원.</div>
				</div>
				<div class="field">
					<label class="field__label" for="estimatedDuration">예상 소요 시간 (분)<span class="req">*</span></label>
					<input class="input" id="estimatedDuration" type="number" name="estimatedDuration"
					       min="1" max="43200" required placeholder="예) 90">
					<div class="field__help">90 = 1시간 30분. 최대 30일(43,200분).</div>
				</div>
			</div>

			<%--
				maxlength 는 남겨둔다.

				자기소개(verify.jsp)에서는 maxlength 를 뺐다. 거기는 4000"자" 라
				한글로 채우면 12000바이트가 되어 컬럼(4000바이트)을 넘겨버려서,
				maxlength 가 오히려 "여기까진 괜찮다" 는 잘못된 신호를 줬다.

				여기는 반대다. 1000자를 한글로 채워도 3000바이트라
				컬럼(4000바이트) 안에 들어온다. 그래서 maxlength 가
				바이트 검사보다 먼저 걸리는 안전한 울타리 역할을 한다.
			--%>
			<div class="field">
				<label class="field__label" for="content">고객에게 한마디<span class="req">*</span></label>
				<textarea class="textarea" id="content" name="content" rows="6" maxlength="1000" required
					placeholder="어떤 작업을 하는지, 부품값이 포함인지 등을 적어주세요."></textarea>
				<div class="field__help">
					고객이 견적 목록에서 보게 됩니다. 한글은 1자가 3바이트입니다.
					<b id="contentCount" style="float:right"></b>
				</div>
			</div>

			<div class="note note--gray" style="margin-bottom:22px">
				<svg><use href="#i-alert"/></svg>
				<span>지금 보내는 금액은 <b>확정 금액이 아닙니다.</b> 고객이 회원님을 선택하면
				내 작업 화면에서 연락처와 방문 주소가 열립니다.</span>
			</div>

			<%-- 제출을 막았을 때 이유를 모아 보여주는 자리 --%>
			<div class="note note--warn" id="formAlert" style="display:none;margin-bottom:22px">
				<svg><use href="#i-alert"/></svg>
				<span id="formAlertText"></span>
			</div>

			<div class="btn-row">
				<a class="btn btn--ghost btn--lg" href="/fixer/requests/${repair.requestId}">취소</a>
				<button type="submit" id="submitBtn" class="btn btn--primary btn--xl" style="flex:1">
					<svg class="ico"><use href="#i-send"/></svg>견적 제출</button>
			</div>
		</div>

	</form>

</div>

<script>
(function () {

	var MAX_PRICE          = 100000000;   // 1억 원
	var MAX_DURATION       = 43200;       // 30일(분)
	var CONTENT_MAX_BYTES  = 4000;        // ESTIMATES.CONTENT = VARCHAR2(4000 BYTE)

	var form     = document.querySelector('form[action="/fixer/estimates"]');
	var priceEl  = document.getElementById('estimatedPrice');
	var durEl    = document.getElementById('estimatedDuration');
	var contEl   = document.getElementById('content');
	var box      = document.getElementById('formAlert');
	var boxText  = document.getElementById('formAlertText');
	var countEl  = document.getElementById('contentCount');
	var btn      = document.getElementById('submitBtn');

	if (!form) return;

	/*
	 * 문자열의 UTF-8 바이트 길이.
	 * 오라클이 세는 단위와 같은 단위로 세야 화면과 DB 가 어긋나지 않는다.
	 * TextEncoder 가 없는 옛 브라우저를 위한 대체 계산도 같이 둔다.
	 */
	function byteLength(s) {
		if (!s) return 0;
		if (window.TextEncoder) return new TextEncoder().encode(s).length;
		return unescape(encodeURIComponent(s)).length;
	}

	/* 숫자 칸은 값이 이상하면 브라우저가 빈 문자열을 돌려준다.
	   그래서 "안 적었다" 와 "이상하게 적었다" 를 badInput 으로 구분한다. */
	function numberOf(el) {
		if (el.validity && el.validity.badInput) return NaN;
		if (el.value.trim() === '') return null;
		return Number(el.value);
	}

	/* 검사 결과를 배열로 모은다. 하나 걸릴 때마다 멈추지 않고 끝까지 본다.
	   한 번 제출했는데 오류가 하나씩 나오면 사용자가 몇 번을 다시 눌러야 한다. */
	function collect() {

		var list = [];
		var firstBad = null;
		function bad(el, msg) { list.push(msg); if (!firstBad) firstBad = el; }

		var price = numberOf(priceEl);
		if (price === null)            bad(priceEl, '예상 금액을 입력해주세요.');
		else if (isNaN(price))         bad(priceEl, '예상 금액을 숫자로 입력해주세요.');
		else if (price < 0)            bad(priceEl, '예상 금액은 0원 이상이어야 합니다.');
		else if (price % 1 !== 0)      bad(priceEl, '예상 금액은 원 단위 정수로 입력해주세요.');
		else if (price > MAX_PRICE)    bad(priceEl, '예상 금액이 너무 큽니다. 최대 1억 원까지 입력할 수 있습니다.');

		var dur = numberOf(durEl);
		if (dur === null)              bad(durEl, '예상 소요 시간(분)을 입력해주세요.');
		else if (isNaN(dur))           bad(durEl, '예상 소요 시간을 숫자로 입력해주세요.');
		else if (dur < 1)              bad(durEl, '예상 소요 시간은 1분 이상이어야 합니다.');
		else if (dur % 1 !== 0)        bad(durEl, '예상 소요 시간은 분 단위 정수로 입력해주세요.');
		else if (dur > MAX_DURATION)   bad(durEl, '예상 소요 시간이 너무 깁니다. 최대 30일(43,200분)까지 입력할 수 있습니다.');

		var content = contEl.value;
		if (content.trim() === '') {
			bad(contEl, '고객에게 전할 내용을 입력해주세요.');
		} else {
			var bytes = byteLength(content);
			if (bytes > CONTENT_MAX_BYTES) {
				bad(contEl, '견적 설명이 너무 깁니다. 현재 ' + bytes
				          + '바이트 / 최대 ' + CONTENT_MAX_BYTES + '바이트 (한글은 1자당 3바이트)');
			}
		}

		return { list: list, firstBad: firstBad };
	}

	function render(result) {
		if (!box) return;
		var html = '<b>아래 항목을 확인해주세요.</b><br>';
		for (var i = 0; i < result.list.length; i++) {
			html += '· ' + result.list[i] + '<br>';
		}
		html += '<span class="muted">입력하신 내용은 그대로 남아 있습니다. 해당 항목만 고쳐서 다시 눌러주세요.</span>';
		boxText.innerHTML = html;
		box.style.display = '';
	}

	/* 남은 바이트를 타이핑하는 동안 보여준다. 다 쓰고 나서 알면 늦다. */
	function updateCount() {
		if (!countEl) return;
		var bytes = byteLength(contEl.value);
		countEl.textContent = bytes.toLocaleString() + ' / ' + CONTENT_MAX_BYTES.toLocaleString() + ' 바이트';
		countEl.style.color = bytes > CONTENT_MAX_BYTES ? 'var(--danger, #c0392b)' : '';
	}
	contEl.addEventListener('input', updateCount);
	updateCount();

	form.addEventListener('submit', function (e) {

		var result = collect();

		if (result.list.length > 0) {
			/*
			 * 여기서 멈추기 때문에 페이지가 다시 뜨지 않는다.
			 * 그래서 금액·시간·설명이 입력한 그대로 남는다.
			 * 서버까지 갔다가 되돌아오는 방식이면 전부 다시 쳐야 한다.
			 */
			e.preventDefault();
			render(result);
			box.scrollIntoView({ behavior: 'smooth', block: 'center' });
			if (result.firstBad) result.firstBad.focus();
			return;
		}

		if (box) box.style.display = 'none';

		/*
		 * 여기까지 왔으면 폼은 그대로 전송된다.
		 * 버튼을 비활성화하는 건 "실수로 두 번 누르는 것" 만 줄여주는 보조 수단이다.
		 * 브라우저는 submit 이벤트가 끝난 뒤에 전송하므로 지금 누른 제출은 막지 않는다.
		 *
		 * 진짜 중복 방지는 서버(INSERT 의 WHERE 조건)가 한다.
		 * 자바스크립트가 꺼져 있거나 새로고침으로 다시 보내는 경우까지는 못 막는다.
		 */
		if (btn.disabled) { e.preventDefault(); return; }
		btn.disabled = true;
		btn.textContent = '제출 중...';
	});

})();
</script>

<jsp:include page="/WEB-INF/views/common/footer.jsp"/>