<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../common/admin-header.jsp" %>
<div class="container container--wide">

	<div class="page-head">
		<h1>접수 현황</h1>
		<p>전체 수리 접수를 상태별로 확인하고 검색합니다.</p>
	</div>

	<%--===== 상태별 건수 (클릭하면 그 상태로 필터) =====--%>
	<div class="kpis" style="margin-bottom:32px">
		<c:forEach var="s" items="${statusCounts}">
			<c:set var="kpiColor" value="" />
			<c:if test="${s.statusCode eq 'REQ_01'}"><c:set var="kpiColor" value="kpi--blue" /></c:if>
			<c:if test="${s.statusCode eq 'REQ_02'}"><c:set var="kpiColor" value="kpi--accent" /></c:if>
			<c:if test="${s.statusCode eq 'REQ_04'}"><c:set var="kpiColor" value="kpi--ok" /></c:if>

			<c:set var="kpiOn" value="" />
			<c:if test="${condition.statusCode eq s.statusCode}"><c:set var="kpiOn" value="border-color:#2F6BFF" /></c:if>

			<a class="kpi ${kpiColor}" style="text-decoration:none;${kpiOn}"
				href="${pageContext.request.contextPath}/admin?statusCode=${s.statusCode}">
				<div class="kpi__label">${s.statusName}</div>
				<div class="kpi__value">${s.cnt}<small>건</small></div>
			</a>
		</c:forEach>
	</div>

	<%--===== 검색 =====--%>
	<div class="sec-head sec-head--row" style="margin-bottom:20px">
		<h2>전체 접수 ${totalCount}건</h2>
	</div>

	<form method="get" action="${pageContext.request.contextPath}/admin"
		class="card card--sm" style="margin-bottom:16px;display:flex;gap:8px;align-items:center">

		<input type="date" name="fromDate" class="input" style="width:160px" value="${fn:escapeXml(condition.fromDate)}">
		<span class="muted">~</span>
		<input type="date" name="toDate" class="input" style="width:160px" value="${fn:escapeXml(condition.toDate)}">

		<select name="statusCode" class="input" style="width:140px">
			<option value="">전체 상태</option>
			<c:forEach var="s" items="${statusCounts}">
				<option value="${fn:escapeXml(s.statusCode)}"
					<c:if test="${condition.statusCode eq s.statusCode}">selected</c:if>><c:out value="${s.statusName}"/></option>
			</c:forEach>
		</select>

		<input type="text" name="keyword" class="input" style="flex:1"
			placeholder="접수 제목 또는 고객명" value="${fn:escapeXml(condition.keyword)}">

		<button type="submit" class="btn btn--primary btn--sm">검색</button>
		<a href="${pageContext.request.contextPath}/admin" class="btn btn--ghost btn--sm">초기화</a>
	</form>

	<%--===== 목록 =====--%>
	<div class="card card--sm">
		<table class="tbl">
			<thead>
				<tr>
					<th style="width:80px">접수번호</th>
					<th style="width:130px">카테고리</th>
					<th>제목</th>
					<th style="width:120px">고객</th>
					<th style="width:220px">방문 주소</th>
					<th style="width:120px" class="right">견적</th>
					<th style="width:110px">담당 기사</th>
					<th style="width:100px">상태</th>
					<th style="width:130px">접수일시</th>
				</tr>
			</thead>
			<tbody>
			<c:forEach var="r" items="${requestList}">
				<tr>
					<td class="num">#${r.requestId}</td>
					<td><c:out value="${r.categoryName}"/></td>
					<td class="ttl"><c:out value="${r.title}"/></td>
					<td>
						<c:out value="${r.customerName}"/>
						<div class="muted" style="font-size:14px"><c:out value="${r.customerPhone}"/></div>
					</td>
					<td class="muted" style="font-size:15px"><c:out value="${r.serviceAddress}"/></td>
					<td class="right num">
						<c:choose>
							<c:when test="${not empty r.estimatedPrice}">
								<fmt:formatNumber value="${r.estimatedPrice}" pattern="#,##0"/>원
							</c:when>
							<c:when test="${r.estimateCount > 0}">
								<span class="muted">견적 ${r.estimateCount}건</span>
							</c:when>
							<c:otherwise><span class="muted">-</span></c:otherwise>
						</c:choose>
					</td>
					<td>
						<c:choose>
							<c:when test="${not empty r.fixerName}"><c:out value="${r.fixerName}"/></c:when>
							<c:otherwise><span class="muted">미배정</span></c:otherwise>
						</c:choose>
					</td>
					<td>
						<c:set var="stClass" value="badge--gray" />
						<c:if test="${r.statusCode eq 'REQ_01'}"><c:set var="stClass" value="st-received" /></c:if>
						<c:if test="${r.statusCode eq 'REQ_02'}"><c:set var="stClass" value="st-repairing" /></c:if>
						<c:if test="${r.statusCode eq 'REQ_03'}"><c:set var="stClass" value="st-assigned" /></c:if>
						<c:if test="${r.statusCode eq 'REQ_04'}"><c:set var="stClass" value="st-done" /></c:if>
						<%-- 긴급접수(REQ_99). 2026-09-02 추가 --%>
						<c:if test="${r.statusCode eq 'REQ_99'}"><c:set var="stClass" value="st-received" /></c:if>
						<span class="badge ${stClass}"><c:out value="${r.statusName}"/></span>
					</td>
					<td class="num"><c:out value="${r.createdAt}"/></td>
				</tr>
			</c:forEach>

			<c:if test="${empty requestList}">
				<tr>
					<td colspan="9" style="text-align:center;padding:40px" class="muted">
						조회 결과가 없습니다.
					</td>
				</tr>
			</c:if>
			</tbody>
		</table>
	</div>

	<%--===== 페이지 번호 =====--%>
	<div style="display:flex;gap:6px;justify-content:center;margin-top:24px">
		<c:forEach var="p" begin="1" end="${totalPage}">
			<a class="btn btn--sm ${p == condition.page ? 'btn--primary' : 'btn--ghost'}"
				href="${pageContext.request.contextPath}/admin?page=${p}&amp;statusCode=${fn:escapeXml(condition.statusCode)}&amp;keyword=${fn:escapeXml(condition.keyword)}&amp;fromDate=${fn:escapeXml(condition.fromDate)}&amp;toDate=${fn:escapeXml(condition.toDate)}">
				${p}
			</a>
		</c:forEach>
	</div>

</div>
<%@ include file="../common/admin-footer.jsp" %>