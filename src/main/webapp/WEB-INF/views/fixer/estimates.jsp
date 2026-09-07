<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>
<%@ include file="common/icons.jspf" %>
<c:set var="navActive" value="estimates"/>

<div class="container">

	<div class="page-head">
		<h1>내 견적</h1>
		<p>내가 보낸 예상 견적입니다. 고객이 선택하면 <b>내 작업</b>으로 넘어갑니다.</p>
	</div>

	<%@ include file="common/fixernav.jspf" %>

	<c:if test="${not empty message}">
		<div class="note note--blue" style="margin-bottom:24px">
			<svg><use href="#i-bell"/></svg>
			<span><c:out value="${message}"/></span>
		</div>
	</c:if>

	<c:choose>
		<c:when test="${empty estimateList}">
			<div class="card card--flat" style="text-align:center;padding:56px 24px">
				<b style="font-size:19px">아직 제출한 견적이 없습니다.</b>
				<p class="muted" style="margin-top:8px">내 분야·지역에 맞는 접수를 먼저 찾아보세요.</p>
				<a class="btn btn--primary btn--lg" style="margin-top:18px" href="/fixer/requests">
					<svg class="ico"><use href="#i-search"/></svg>새 접수 보러가기</a>
			</div>
		</c:when>

		<c:otherwise>
			<%--
				이전에는 칸마다 고정 너비를 줬는데, 그 합이 카드 폭보다 넓어서
				너비를 안 준 '접수 제목'이 최소 폭까지 밀려 한 글자씩 세로로 접혔다.
				고정 너비를 걷어내고 제목이 남는 폭을 갖게 한 뒤,
				줄바꿈되면 곤란한 칸에만 nowrap 을 준다. 2026-09-03
			--%>
			<div class="card card--sm" style="overflow-x:auto">
				<table class="tbl">
					<thead>
						<tr>
							<th style="white-space:nowrap">견적번호</th>
							<th>접수 제목</th>
							<th style="white-space:nowrap">분야</th>
							<th style="white-space:nowrap">고객</th>
							<th style="white-space:nowrap">예상 금액</th>
							<th style="white-space:nowrap">소요 시간</th>
							<th style="white-space:nowrap">내 견적</th>
							<th style="white-space:nowrap">접수 상태</th>
							<th style="white-space:nowrap">제출일</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach var="estimate" items="${estimateList}">
							<tr>
								<td class="num">${estimate.estimateId}</td>
								<td>
									<div class="ttl">
										<a href="/fixer/requests/${estimate.requestId}"><c:out value="${estimate.requestTitle}"/></a>
									</div>
								</td>
								<td style="white-space:nowrap"><c:out value="${estimate.categoryName}"/></td>
								<td style="white-space:nowrap"><c:out value="${estimate.customerName}"/></td>
								<%--
									fmt:formatNumber 는 서버에서 돈다. 브라우저에는 이미
									"75,000 원" 이라는 글자만 도착한다.
									pattern="#,##0" : # 는 값이 있을 때만, 0 은 없어도 0 을 찍는다.
								--%>
								<td class="num" style="white-space:nowrap"><fmt:formatNumber value="${estimate.estimatedPrice}" pattern="#,##0"/> 원</td>
								<td class="num" style="white-space:nowrap">${estimate.estimatedDuration} 분</td>
								<td>
									<c:choose>
										<c:when test="${estimate.status eq 'SELECTED'}">
											<span class="badge st-assigned">선택됨</span>
										</c:when>
										<c:otherwise>
											<span class="badge badge--gray">대기중</span>
										</c:otherwise>
									</c:choose>
								</td>
								<td><span class="badge badge--gray"><c:out value="${estimate.requestStatusName}"/></span></td>
								<td class="num" style="white-space:nowrap"><fmt:formatDate value="${estimate.createdAt}" pattern="yyyy-MM-dd HH:mm"/></td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</div>

			<p class="muted" style="margin-top:16px;font-size:14.5px">
				수리까지 끝났는데 내 견적이 선택되지 않은 건은 목록에서 빠집니다.
				행을 지우는 게 아니라 화면에서만 거르는 것이라 데이터는 그대로 남아 있습니다.
			</p>
		</c:otherwise>
	</c:choose>

</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp"/>
