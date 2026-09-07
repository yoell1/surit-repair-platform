<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>
<%@ include file="common/icons.jspf" %>
<c:set var="navActive" value="jobs"/>

<div class="container" style="max-width:900px">

	<div class="page-head page-head--plain">
		<h1><c:out value="${job.title}"/>
			<c:choose>
				<c:when test="${job.statusCode eq 'REQ_04'}">
					<span class="badge st-done"><c:out value="${job.statusName}"/></span>
				</c:when>
				<c:otherwise>
					<span class="badge st-repairing"><c:out value="${job.statusName}"/></span>
				</c:otherwise>
			</c:choose>
		</h1>
		<p>접수번호 ${job.requestId} · <fmt:formatDate value="${job.createdAt}" pattern="yyyy-MM-dd HH:mm"/> 접수</p>
	</div>

	<%-- navActive 는 위에서 이미 정해두고 정작 메뉴를 include 하지 않고 있었다. 2026-09-03 --%>
	<%@ include file="common/fixernav.jspf" %>

	<c:if test="${not empty message}">
		<div class="note note--blue" style="margin-bottom:24px">
			<svg><use href="#i-bell"/></svg>
			<span><c:out value="${message}"/></span>
		</div>
	</c:if>

	<!-- 접수 정보 -->
	<div class="card">
		<div class="card__head"><h2 class="card__title">접수 정보</h2></div>
		<dl class="dl--inline">
			<dt>분야</dt><dd><c:out value="${job.categoryName}"/></dd>
			<dt>상태</dt><dd><c:out value="${job.statusName}"/></dd>
		</dl>
		<div style="margin-top:20px;padding-top:20px;border-top:1px solid var(--g-100)">
			<div class="field__label" style="margin-bottom:8px">증상</div>
			<p style="font-size:16px;line-height:1.8;color:var(--g-700);white-space:pre-wrap;margin:0"><c:out value="${job.content}"/></p>
		</div>
	</div>

	<!-- 고객 / 방문지 (예약 확정 안내 보강) -->
	<div class="card" style="border-color:var(--p-200)">
		<div class="card__head">
			<h2 class="card__title">확정된 예약 및 방문지</h2>
			<span class="muted" style="font-size:15px">매칭된 뒤에만 보입니다</span>
		</div>
		<div style="display:flex;align-items:center;gap:20px;margin-bottom:22px">
			<span class="avatar avatar--lg"><svg><use href="#i-user"/></svg></span>
			<div>
				<div style="font-size:21px;font-weight:700"><c:out value="${job.customerName}"/> 고객님</div>
				<div class="muted" style="font-size:16px;margin-top:4px"><c:out value="${job.customerPhone}"/></div>
			</div>
			
			<%-- 이 화면은 "내 견적이 채택된 건" 만 열리므로 채팅 상대가 항상 있다.
			     전화 대신 채팅으로 유도해야 번호가 덜 노출된다. --%>
			<a class="btn btn--primary" style="margin-left:auto"
			   href="/fixer/chat/${job.requestId}">고객과 채팅하기</a>
		</div>
		<dl class="dl--inline">
			<dt>방문 주소</dt><dd><c:out value="${job.serviceAddress}"/></dd>
			<dt>방문 일시</dt><dd class="muted">채팅에서 시간을 협의하고 일정을 확정해주세요.</dd>
		</dl>
	</div>

	<!-- 내 견적 -->
	<div class="card">
		<div class="card__head">
			<h2 class="card__title">내가 보낸 예상 견적</h2>
			<span class="muted" style="font-size:15px">견적번호 ${job.estimateId}</span>
		</div>
		<p style="font-size:16px;line-height:1.8;color:var(--g-700);white-space:pre-wrap;margin:0 0 20px"><c:out value="${job.estimateContent}"/></p>
		<dl class="dl--inline">
			<dt>예상 소요 시간</dt><dd>${job.estimatedDuration} 분</dd>
		</dl>
		<div style="display:flex;justify-content:space-between;align-items:center;margin-top:20px;padding-top:20px;border-top:2px solid var(--g-200)">
			<span style="font-size:18px;font-weight:700">예상 금액</span>
			<span style="font-size:32px;font-weight:800;letter-spacing:-1.4px"><fmt:formatNumber value="${job.estimatedPrice}" pattern="#,##0"/>원</span>
		</div>
	</div>

	<!-- 수리 완료 처리 (결제 폼으로 연결되도록 변경) -->
	<div class="card card--flat">
		<div class="card__head"><h2 class="card__title">수리를 마치셨나요?</h2></div>
		<c:choose>
			<c:when test="${job.statusCode eq 'REQ_03'}">
				<p class="muted" style="font-size:16.5px;line-height:1.8">
					현장에서 결제를 받은 뒤 최종 금액으로 영수증 겸 견적서를 보내면 접수가 완료됩니다.
				</p>
				<!-- 기존 폼 POST 전송을 빼고 결제/영수증 폼으로 이동하는 버튼으로 수정 -->
				<a class="btn btn--dark btn--lg btn--block" style="margin-top:22px" href="${pageContext.request.contextPath}/fixer/payment?requestId=${job.requestId}">
					<svg class="ico"><use href="#i-doc"/></svg>수리 완료 처리 화면 열기
				</a>
			</c:when>
			<c:when test="${job.statusCode eq 'REQ_04'}">
				<div class="note note--ok" style="margin-bottom:0">
					<svg><use href="#i-check"/></svg>
					<span><b>수리가 완료된 작업입니다.</b></span>
				</div>
			</c:when>
			<c:otherwise>
				<div class="note note--gray" style="margin-bottom:0">
					<svg><use href="#i-clock"/></svg>
					<span>아직 완료 처리를 할 수 있는 단계가 아닙니다.</span>
				</div>
			</c:otherwise>
		</c:choose>
	</div>
	
	<!-- =================================================
		     최종 결제 및 영수증 (수리 완료 상태일 때만 노출)
		================================================== -->
		<c:if test="${job.statusCode eq 'REQ_04'}">
		    <!-- 수정 포인트 1: 튀는 테두리 스타일(border-color) 제거하고 공통 .card 유지 -->
		    <div class="card" style="margin-top: 20px;">
		        <div class="card__head" style="margin-bottom: 16px;">
		            <h3 class="card__title" style="font-size: 18px;">최종 결제 및 수리 내역</h3>
		            <span class="badge st-done">결제 완료</span>
		        </div>

		        <!-- 금액 및 결제 방식 비교 -->
		        <div class="list-card__meta" style="line-height: 2; margin-bottom: 24px;">
		            <div style="display: flex; justify-content: space-between; border-bottom: 1px solid var(--g-200); padding-bottom: 12px; margin-bottom: 12px;">
		                <span class="muted">예상 견적 금액</span>
		                <!-- 수정 포인트 2: estimate 객체 대신 이미 있는 job 객체의 예상 금액 재활용 -->
		                <del style="color: var(--g-500);"><fmt:formatNumber value="${job.estimatedPrice}" pattern="#,##0"/>원</del>
		            </div>
		            
		            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 8px;">
		                <span class="muted">실제 결제 금액</span>
		                <!-- 수정 포인트 3: '원' 글자를 <b> 태그 밖으로 빼서 폰트 사이즈 정상화 -->
		                <span>
		                    <b style="font-size: 24px; color: var(--p-600); letter-spacing: -0.5px;">
		                        <fmt:formatNumber value="${payment.totalAmount}" pattern="#,##0"/>
		                    </b>원
		                </span>
		            </div>
		            
		            <div style="display: flex; justify-content: space-between; align-items: center;">
		                <span class="muted">결제 방식</span>
		                <strong style="font-size: 15px; background: var(--g-100); padding: 4px 10px; border-radius: 6px;">
		                    <c:choose>
		                        <c:when test="${payment.paymentMethod == 'CARD'}">카드 결제</c:when>
		                        <c:when test="${payment.paymentMethod == 'CASH'}">현금 결제</c:when>
		                        <c:when test="${payment.paymentMethod == 'TRANSFER'}">계좌 이체</c:when>
		                        <c:otherwise>${payment.paymentMethod}</c:otherwise>
		                    </c:choose>
		                </strong>
		            </div>
		        </div>

		        <!-- 수리 전/후 사진 -->
		        <div class="field">
		            <span class="field__label">수리 전 · 후 사진</span>
		            <div style="display: flex; gap: 12px; margin-top: 12px;">
		                <div style="flex: 1;">
		                    <span class="muted" style="display: block; font-size: 13px; margin-bottom: 8px; text-align: center;">수리 전</span>
		                    <div style="width: 100%; height: 160px; background: url('${pageContext.request.contextPath}${payment.beforePhotoUrl}') center/cover no-repeat; border-radius: 8px; border: 1px solid var(--g-200);"></div>
		                </div>
		                <div style="flex: 1;">
		                    <span class="muted" style="display: block; font-size: 13px; margin-bottom: 8px; text-align: center;">수리 후</span>
		                    <div style="width: 100%; height: 160px; background: url('${pageContext.request.contextPath}${payment.afterPhotoUrl}') center/cover no-repeat; border-radius: 8px; border: 1px solid var(--g-200);"></div>
		                </div>
		            </div>
		        </div>
		    </div>
		</c:if>
	
	<p style="margin-top:24px"><a href="${pageContext.request.contextPath}/fixer/jobs">← 목록으로</a></p>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp"/>