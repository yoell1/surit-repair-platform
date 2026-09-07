<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>
<%@ include file="common/icons.jspf" %>
<c:set var="navActive" value="requests"/>

<div class="container">

	<div class="page-head">
		<h1>내 주변 새 접수</h1>
		<p>내가 등록한 <b>수리 분야</b>와 <b>활동 지역</b>에 맞는 접수만 보입니다.</p>
	</div>

	<%@ include file="common/fixernav.jspf" %>

	<%--
		내가 등록한 지역·분야를 목록 위에 같이 보여준다.

		접수가 안 보일 때 "내 조건이 뭐였더라" 를 기억에 의존해 떠올려야 했다.
		인증 화면으로 갔다 와야 확인이 되니 화면을 두 번 오가게 된다.
		매칭 조건 자체를 옆에 놓아두면 그 자리에서 바로 대조가 된다.
	--%>
	<c:if test="${not empty myRegionNames or not empty myCategoryNames}">
		<div class="card card--sm" style="margin-bottom:20px">
			<div style="display:flex;gap:32px;flex-wrap:wrap;align-items:flex-start">

				<div>
					<div class="field__label" style="margin-bottom:6px">내 활동 지역</div>
					<div>
						<c:forEach var="name" items="${myRegionNames}">
							<span class="badge badge--gray"><c:out value="${name}"/></span>
						</c:forEach>
						<c:if test="${empty myRegionNames}"><span class="muted">등록된 지역 없음</span></c:if>
					</div>
				</div>

				<div>
					<div class="field__label" style="margin-bottom:6px">수리 가능 분야</div>
					<div>
						<c:forEach var="name" items="${myCategoryNames}">
							<span class="badge badge--primary"><c:out value="${name}"/></span>
						</c:forEach>
						<c:if test="${empty myCategoryNames}"><span class="muted">등록된 분야 없음</span></c:if>
					</div>
				</div>

				<div style="margin-left:auto">
					<a class="btn btn--ghost btn--sm" href="/fixer/verify">인증 정보 수정</a>
				</div>

			</div>
		</div>
	</c:if>

	<c:if test="${not empty message}">
		<div class="note note--warn" style="margin-bottom:24px">
			<svg><use href="#i-alert"/></svg>
			<span><c:out value="${message}"/></span>
		</div>
	</c:if>

	<!-- 검색 -->
	<div class="card card--sm" style="margin-bottom:28px">
		<form action="/fixer/requests" method="get">
			<div class="field-row" style="margin-bottom:0">
				<div class="field" style="margin-bottom:0">
					<label class="field__label" for="categoryCode">분야</label>
					<select class="input" id="categoryCode" name="categoryCode">
						<option value="">분야 전체</option>
						<c:forEach var="category" items="${categoryList}">
							<%--
								검색하고 돌아왔을 때 고른 값이 그대로 남아 있게 한다.
								컨트롤러가 model 에 categoryCode 를 다시 실어 보내주기 때문에 가능하다.
							--%>
							<option value="${category.codeId}"
								<c:if test="${categoryCode eq category.codeId}">selected</c:if>>
								<c:out value="${category.codeName}"/>
							</option>
						</c:forEach>
					</select>
				</div>
				<div class="field" style="margin-bottom:0">
					<label class="field__label" for="keyword">검색어</label>
					<%-- 사용자가 친 글자를 그대로 다시 넣을 때도 c:out 으로 이스케이프한다 --%>
					<input class="input" id="keyword" type="text" name="keyword"
					       value="<c:out value='${keyword}'/>" placeholder="제목 · 내용 검색">
				</div>
			</div>
			<div class="btn-row" style="margin-top:16px">
				<button type="submit" class="btn btn--primary btn--lg">
					<svg class="ico"><use href="#i-search"/></svg>검색</button>
				<a class="btn btn--ghost btn--lg" href="/fixer/requests">초기화</a>
			</div>
		</form>
	</div>

	<!-- 목록 -->
	<c:choose>
		<c:when test="${empty requestList}">
			<div class="card card--flat" style="text-align:center;padding:56px 24px">
				<span class="tile tile--sm t-blue" style="margin:0 auto 16px"><svg><use href="#i-search"/></svg></span>
				<b style="font-size:19px">조건에 맞는 새 접수가 없습니다.</b>
				<p class="muted" style="margin-top:8px">
					위에 표시된 활동 지역과 수리 분야를 넓히면 더 많은 접수가 보입니다.
					<a href="/fixer/verify">인증 정보에서 수정하기</a>
				</p>
			</div>
		</c:when>

		<c:otherwise>
			<c:forEach var="request" items="${requestList}">
				<%-- 아직 아무도 견적을 안 낸 접수는 강조해서 보여준다 --%>
				<div class="list-card ${request.estimateCount eq 0 ? 'list-card--accent' : ''}">

					<span class="tile t-lock"><svg><use href="#i-tools"/></svg></span>

					<div class="list-card__body">
						<div style="display:flex;align-items:center;gap:10px;flex-wrap:wrap">
							<span class="badge badge--primary"><c:out value="${request.categoryName}"/></span>
							<span class="badge ${request.statusCode == 'REQ_99' ? 'badge--danger' : 'badge--gray'}">
							    <c:out value="${request.statusName}"/>
							</span>
							<span class="muted" style="font-size:14.5px">
								접수번호 ${request.requestId} ·
								<fmt:formatDate value="${request.createdAt}" pattern="yyyy-MM-dd HH:mm"/>
							</span>
						</div>

						<div class="list-card__title">
							<a href="/fixer/requests/${request.requestId}"><c:out value="${request.title}"/></a>
						</div>

						<div class="list-card__meta">
							<c:out value="${request.serviceAddress}"/> ·
							<c:choose>
								<c:when test="${request.estimateCount eq 0}">
									<b style="color:var(--ok)">아직 신청자가 없어요</b>
								</c:when>
								<c:otherwise>
									현재 ${request.estimateCount}명 신청
								</c:otherwise>
							</c:choose>
						</div>
					</div>

					<%--
						myEstimateId 가 null 이면 "아직 견적을 안 냈다" 는 뜻이다.
						이 값을 Long 으로 둔 이유가 여기 있다. 원시형이면 0 이 되어
						"0번 견적을 냈다" 로 읽혀서 이 분기가 뒤집힌다.
					--%>
					<c:choose>
						<c:when test="${not empty request.myEstimateId}">
							<div style="text-align:right">
								<span class="badge st-done">견적 제출함</span><br>
								<a class="btn btn--ghost btn--sm" style="margin-top:8px"
								   href="/fixer/requests/${request.requestId}">상세 보기</a>
							</div>
						</c:when>
						<c:otherwise>
							<a class="btn btn--primary btn--lg" href="/fixer/requests/${request.requestId}">상세 보기</a>
						</c:otherwise>
					</c:choose>

				</div>
			</c:forEach>
		</c:otherwise>
	</c:choose>

</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp"/>