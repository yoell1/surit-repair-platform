<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../common/admin-header.jsp" %>
<div class="container container--wide">

	<div class="page-head">
		<h1>리뷰 관리</h1>
	</div>

	<%--===== 평점 하위 기사 =====--%>
	<div class="sec-head sec-head--row" style="margin-bottom:20px">
		<div>
			<h2>평점 하위 기사 ${fn:length(lowRatedFixers)}명</h2>
			<p>평균 별점 3.0 미만인 기사입니다. 경고를 등록하면 제재 이력에 남습니다.</p>
		</div>
	</div>

	<c:forEach var="lf" items="${lowRatedFixers}">
		<div class="list-card">
			<div class="list-card__body">
				<div style="display:flex;align-items:center;gap:10px">
					<b style="font-size:19px"><c:out value="${lf.name}"/></b>
					<span class="badge badge--danger">★ ${lf.avgScore}</span>
				</div>
				<div class="muted" style="font-size:14.5px;margin-top:4px">
					아이디 <c:out value="${lf.userId}"/> · 리뷰 ${lf.reviewCount}건
				</div>
			</div>
			<div class="btn-row">
				<form method="post" style="display:flex;gap:6px"
					action="${pageContext.request.contextPath}/admin/reviews/${lf.userNo}/warn">
					<input type="text" name="reason" class="input" style="width:260px"
						placeholder="경고 사유" required>
					<button type="submit" class="btn btn--danger btn--sm">기사 경고</button>
				</form>
			</div>
		</div>
	</c:forEach>

	<c:if test="${empty lowRatedFixers}">
		<div class="card card--sm" style="text-align:center;padding:40px">
			<span class="muted">평점 하위 기사가 없습니다.</span>
		</div>
	</c:if>

	<%--===== 전체 리뷰 =====--%>
	<div class="sec-head sec-head--row" style="margin:52px 0 20px">
		<h2>전체 리뷰 ${totalCount}건</h2>
	</div>

	<%-- 필터 --%>
	<form method="get" action="${pageContext.request.contextPath}/admin/reviews"
		class="card card--sm" style="margin-bottom:16px;display:flex;gap:8px">
		<select name="score" class="input" style="width:120px">
			<option value="">전체 별점</option>
			<c:forEach var="s" begin="1" end="5">
				<option value="${s}" <c:if test="${condition.score eq s}">selected</c:if>>${s}점</option>
			</c:forEach>
		</select>
		<label class="input" style="width:140px;display:flex;align-items:center;gap:6px">
			<input type="checkbox" name="lowOnly" value="true"
				<c:if test="${condition.lowOnly}">checked</c:if>> 3점 이하만
		</label>
		<input type="text" name="keyword" class="input" style="flex:1"
			placeholder="기사명 또는 고객명" value="${fn:escapeXml(condition.keyword)}">
		<button type="submit" class="btn btn--primary btn--sm">검색</button>
	</form>

	<div class="card card--sm">
		<table class="tbl">
			<thead>
				<tr>
					<th style="width:70px">별점</th>
					<th style="width:110px">기사</th>
					<th style="width:110px">고객</th>
					<th>리뷰 원문</th>
					<th style="width:110px">작성일</th>
				</tr>
			</thead>
			<tbody>
			<c:forEach var="r" items="${reviewList}">
				<tr>
					<td>
						<c:choose>
							<c:when test="${r.score le 2}">
								<span class="badge badge--danger">★ ${r.score}</span>
							</c:when>
							<c:when test="${r.score eq 3}">
								<span class="badge badge--warn">★ ${r.score}</span>
							</c:when>
							<c:otherwise>
								<span class="badge badge--ok">★ ${r.score}</span>
							</c:otherwise>
						</c:choose>
					</td>
					<td class="ttl"><c:out value="${r.fixerName}"/></td>
					<td><c:out value="${r.userName}"/></td>
					<td><c:out value="${r.content}"/></td>
					<td class="num"><c:out value="${r.createdAt}"/></td>
				</tr>
			</c:forEach>

			<c:if test="${empty reviewList}">
				<tr>
					<td colspan="5" style="text-align:center;padding:40px" class="muted">
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
				href="${pageContext.request.contextPath}/admin/reviews?page=${p}&amp;score=${fn:escapeXml(condition.score)}&amp;keyword=${fn:escapeXml(condition.keyword)}">
				${p}
			</a>
		</c:forEach>
	</div>

</div>
<%@ include file="../common/admin-footer.jsp" %>