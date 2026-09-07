<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>

<div class="container" style="max-width:900px">

	<div class="page-head page-head--plain">
		<h1><c:out value="${repair.title}"/>
			<span class="badge st-matching"><c:out value="${repair.statusName}"/></span></h1>
		<p>접수번호 ${repair.requestId} ·
			<c:out value="${repair.customerName}"/> 고객님 ·
			<fmt:formatDate value="${repair.createdAt}" pattern="yyyy-MM-dd HH:mm"/> 접수</p>
	</div>

	<!-- 진행 단계 (프로토타입 규격) -->
	<div style="margin-bottom:40px">
		<div class="steps">
			<div class="steps__item done"><div class="steps__dot"><svg><use href="#i-check"/></svg></div><div class="steps__label">접수 완료</div></div>
			<div class="steps__item now"><div class="steps__dot">2</div><div class="steps__label">기사 매칭</div></div>
			<div class="steps__item"><div class="steps__dot">3</div><div class="steps__label">방문 · 수리</div></div>
			<div class="steps__item"><div class="steps__dot">4</div><div class="steps__label">수리 완료</div></div>
		</div>
	</div>

	<!-- 1. 고객이 남긴 내용 -->
	<div class="card">
		<div class="card__head"><h2 class="card__title">고객이 남긴 내용</h2></div>

		<p style="font-size:17px;line-height:1.85;color:var(--g-700);white-space:pre-wrap;margin-bottom:22px"><c:out value="${repair.content}"/></p>

		<c:if test="${not empty repair.photos}">
			<div class="field__label" style="margin-bottom:10px">고장 사진</div>
			<div class="upload" style="margin-bottom:22px">
				<c:forEach var="photo" items="${repair.photos}">
					<span class="thumb">
						<img src="<c:out value='${photo.photoPath}'/>" alt="고장 사진"
						     style="width:100%;height:100%;object-fit:cover;border-radius:var(--r-md)">
					</span>
				</c:forEach>
			</div>
		</c:if>

		<div style="margin-top:26px;padding-top:24px;border-top:1px solid var(--g-100)">
			<dl class="dl--inline">
				<dt>분야</dt><dd><c:out value="${repair.categoryName}"/></dd>
				<dt>위치</dt><dd><c:out value="${repair.serviceAddress}"/></dd>
				<dt>현재 신청</dt><dd>${repair.estimateCount}명</dd>
			</dl>
		</div>

		<div class="note note--gray" style="margin-top:24px">
			<svg><use href="#i-lock"/></svg>
			<span>상세 주소와 채팅은 <b>고객이 회원님을 선택한 뒤</b> 열립니다.</span>
		</div>
	</div>

	<!-- 2. 예상 견적 제시 (인라인 통합) -->
	<c:choose>
		<c:when test="${not empty repair.myEstimateId}">
			<div class="card card--flat">
				<div class="note note--ok" style="margin-bottom:22px">
					<svg><use href="#i-check"/></svg>
					<span><b>이미 견적을 제출한 접수입니다.</b> 고객의 선택을 기다려주세요.</span>
				</div>
				<a class="btn btn--ghost btn--lg btn--block" href="${pageContext.request.contextPath}/fixer/estimates">
					<svg class="ico"><use href="#i-doc"/></svg>내 견적 확인하기</a>
			</div>
		</c:when>

		<c:otherwise>
			<form action="${pageContext.request.contextPath}/fixer/estimates" method="post" id="estimateForm" novalidate>
				<c:if test="${not empty _csrf}">
					<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
				</c:if>
				<input type="hidden" name="requestId" value="${repair.requestId}"/>

				<div class="card" style="border-color:var(--p-200)">
					<div class="card__head">
						<h2 class="card__title">예상 견적 제시</h2>
						<span class="muted" style="font-size:15px">고객의 기사 목록에 바로 노출됩니다</span>
					</div>

					<div class="field-row">
						<div class="field">
							<label class="field__label" for="estimatedPrice">예상 금액 (원)<span class="req">*</span></label>
							<input class="input" id="estimatedPrice" type="number" name="estimatedPrice"
							       min="0" max="100000000" step="1000" required placeholder="예) 75000">
							<div class="field__help">원 단위 정수로 입력합니다. 현장 확인 후 달라질 수 있는 참고 금액입니다.</div>
						</div>
						<div class="field">
							<label class="field__label" for="estimatedDuration">예상 소요 시간 (분)<span class="req">*</span></label>
							<input class="input" id="estimatedDuration" type="number" name="estimatedDuration"
							       min="1" max="43200" required placeholder="예) 40">
							<div class="field__help">분 단위 숫자로 입력합니다. (예: 60 = 1시간)</div>
						</div>
					</div>

					<div class="field">
						<span class="field__label">방문 가능 시간</span>
						<div class="chip-row">
							<button type="button" class="chip chip--on" data-select="visit">지금 바로 가능</button>
							<button type="button" class="chip" data-select="visit">오늘 오후</button>
							<button type="button" class="chip" data-select="visit">내일 오전</button>
						</div>
						<div class="field__help">정확한 방문 시간은 매칭 후 채팅에서 고객과 확정합니다.</div>
					</div>

					<script>
						// 방문 가능 시간 버튼 UI 토글 (데이터 전송 X)
						document.querySelectorAll('button[data-select="visit"]').forEach(function(btn) {
							btn.addEventListener('click', function() {
								// 1. 모든 버튼의 파란색(chip--on) 제거
								document.querySelectorAll('button[data-select="visit"]').forEach(function(c) {
									c.classList.remove('chip--on');
								});

								// 2. 내가 방금 누른 버튼만 파란색(chip--on) 추가
								this.classList.add('chip--on');
							});
						});
					</script>

					<div class="field">
						<span class="field__label">추가 제공 <span class="muted" style="font-weight:400">(선택)</span></span>
						<div class="chip-row">
							<button type="button" class="chip chip--on" data-toggle>출장비 무료</button>
							<button type="button" class="chip" data-toggle>당일 A/S</button>
							<button type="button" class="chip" data-toggle>부품 보증 3개월</button>
						</div>
					</div>

					<div class="field">
						<label class="field__label" for="content">고객에게 한마디<span class="req">*</span></label>
						<textarea class="textarea" id="content" name="content" rows="5" maxlength="1000" required
						          placeholder="어떤 점을 확인하고 어떻게 수리할지, 부품값 포함 여부 등을 적어주세요."></textarea>
						<div class="field__help">
							고객이 기사 선택 화면에서 확인하게 됩니다.
							<b id="contentCount" style="float:right"></b>
						</div>
					</div>

					<div class="note note--gray" style="margin-bottom:22px">
						<svg><use href="#i-alert"/></svg>
						<span>지금 보내는 금액은 <b>확정 금액이 아닙니다.</b> 고객이 회원님을 선택하면 매칭 확인 후 채팅이 열리고,
						최종 금액은 <b>수리를 마친 뒤</b> 영수증 견적서로 확정합니다.</span>
					</div>

					<div class="note note--warn" id="formAlert" style="display:none;margin-bottom:22px">
						<svg><use href="#i-alert"/></svg>
						<span id="formAlertText"></span>
					</div>

					<div class="btn-row">
						<a class="btn btn--ghost btn--lg" href="${pageContext.request.contextPath}/fixer/requests">목록으로</a>
						<button type="submit" id="submitBtn" class="btn btn--primary btn--xl" style="flex:1">
							<svg class="ico"><use href="#i-send"/></svg>예상 견적 보내기
						</button>
					</div>
				</div>
			</form>

			<script>
				(function () {
					var MAX_PRICE = 100000000;
					var MAX_DURATION = 43200;
					var CONTENT_MAX_BYTES = 4000;

					var form    = document.getElementById('estimateForm');
					var priceEl = document.getElementById('estimatedPrice');
					var durEl   = document.getElementById('estimatedDuration');
					var contEl  = document.getElementById('content');
					var box     = document.getElementById('formAlert');
					var boxText = document.getElementById('formAlertText');
					var countEl = document.getElementById('contentCount');
					var btn     = document.getElementById('submitBtn');

					if (!form) return;

					function byteLength(s) {
						if (!s) return 0;
						if (window.TextEncoder) return new TextEncoder().encode(s).length;
						return unescape(encodeURIComponent(s)).length;
					}

					function numberOf(el) {
						if (el.validity && el.validity.badInput) return NaN;
						if (el.value.trim() === '') return null;
						return Number(el.value);
					}

					function collect() {
						var list = [];
						var firstBad = null;
						function bad(el, msg) { list.push(msg); if (!firstBad) firstBad = el; }

						var price = numberOf(priceEl);
						if (price === null)            bad(priceEl, '예상 금액을 입력해주세요.');
						else if (isNaN(price))         bad(priceEl, '예상 금액을 숫자로 입력해주세요.');
						else if (price < 0)            bad(priceEl, '예상 금액은 0원 이상이어야 합니다.');
						else if (price % 1 !== 0)      bad(priceEl, '예상 금액은 원 단위 정수로 입력해주세요.');
						else if (price > MAX_PRICE)    bad(priceEl, '예상 금액이 너무 큽니다. 최대 1억 원까지 가능합니다.');

						var dur = numberOf(durEl);
						if (dur === null)              bad(durEl, '예상 소요 시간(분)을 입력해주세요.');
						else if (isNaN(dur))           bad(durEl, '예상 소요 시간을 숫자로 입력해주세요.');
						else if (dur < 1)              bad(durEl, '예상 소요 시간은 1분 이상이어야 합니다.');
						else if (dur % 1 !== 0)        bad(durEl, '예상 소요 시간은 분 단위 정수로 입력해주세요.');
						else if (dur > MAX_DURATION)   bad(durEl, '예상 소요 시간이 너무 깁니다.');

						var content = contEl.value;
						if (content.trim() === '') {
							bad(contEl, '고객에게 전할 내용을 입력해주세요.');
						} else {
							var bytes = byteLength(content);
							if (bytes > CONTENT_MAX_BYTES) {
								bad(contEl, '견적 설명이 너무 깁니다. (최대 ' + CONTENT_MAX_BYTES + '바이트)');
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
						boxText.innerHTML = html;
						box.style.display = '';
					}

					function updateCount() {
						if (!countEl) return;
						var bytes = byteLength(contEl.value);
						countEl.textContent = bytes.toLocaleString() + ' / ' + CONTENT_MAX_BYTES.toLocaleString() + ' 바이트';
						countEl.style.color = bytes > CONTENT_MAX_BYTES ? 'var(--danger)' : '';
					}
					contEl.addEventListener('input', updateCount);
					updateCount();

					form.addEventListener('submit', function (e) {
						var result = collect();
						if (result.list.length > 0) {
							e.preventDefault();
							render(result);
							box.scrollIntoView({ behavior: 'smooth', block: 'center' });
							if (result.firstBad) result.firstBad.focus();
							return;
						}
						if (box) box.style.display = 'none';
						btn.disabled = true;
						btn.textContent = '제출 중...';
					});
				})();
			</script>
		</c:otherwise>
	</c:choose>

</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp"/>
<script src="${pageContext.request.contextPath}/js/common.js"></script>