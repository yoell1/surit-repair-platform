<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../common/admin-header.jsp" %>

<div class="container container--wide">

	<div class="page-head"><h1>문의 응대</h1></div>

	<c:if test="${empty supportNo}">
		<p class="alert">
			고객센터 계정이 없습니다. USERS 테이블에 USER_ID='surit_support' 를 먼저 만들어 주세요.
		</p>
	</c:if>

	<div class="sec-head sec-head--row">
		<div class="btn-row">
			<a class="btn btn--sm ${filter eq 'ALL'  ? 'btn--primary' : 'btn--ghost'}" href="/admin/inquiries?filter=ALL">전체</a>
			<a class="btn btn--sm ${filter eq 'WAIT' ? 'btn--primary' : 'btn--ghost'}" href="/admin/inquiries?filter=WAIT">답변 대기</a>
			<a class="btn btn--sm ${filter eq 'DONE' ? 'btn--primary' : 'btn--ghost'}" href="/admin/inquiries?filter=DONE">답변 완료</a>
		</div>
		<span class="muted">총 ${fn:length(rooms)}건</span>
	</div>

	<c:choose>
		<c:when test="${empty rooms}">
			<p class="empty">해당하는 문의가 없습니다.</p>
		</c:when>
		<c:otherwise>
			<table class="tbl">
				<thead>
					<tr>
						<th class="num">번호</th>
						<th>고객</th>
						<th class="ttl">최근 메시지</th>
						<th class="center">상태</th>
						<th class="center">건수</th>
						<th>최근 시각</th>
						<th class="center"></th>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="r" items="${rooms}">
						<tr>
							<td class="num">${r.roomId}</td>
							<td><c:out value="${r.userName}"/></td>
							<td class="ttl">
								<c:choose>
									<c:when test="${empty r.lastMessage}"><span class="muted">(내용 없음)</span></c:when>
									<c:otherwise><c:out value="${r.lastMessage}"/></c:otherwise>
								</c:choose>
							</td>
							<td class="center">
								<c:choose>
									<c:when test="${r.lastSenderNo eq supportNo}">
										<span class="badge badge--ok">답변 완료</span>
									</c:when>
									<c:otherwise>
										<span class="badge badge--warn">답변 대기</span>
									</c:otherwise>
								</c:choose>
							</td>
							<td class="center">${r.msgCount}</td>
							<td><c:out value="${empty r.lastSentAt ? r.createdAt : r.lastSentAt}"/></td>
							<td class="center">
								<a class="btn btn--sm btn--primary" href="/admin/inquiries/${r.roomId}">답변하기</a>
							</td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</c:otherwise>
	</c:choose>

</div>

<%@ include file="../common/admin-footer.jsp" %>