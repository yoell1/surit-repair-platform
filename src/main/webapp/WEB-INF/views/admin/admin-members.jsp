<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../common/admin-header.jsp" %>
	<div class="container container--wide">

		<div class="page-head">
			<h1>회원 · 기사 관리</h1>
			<p>기사 가입을 심사하고 계정 상태를 관리합니다.</p>
		</div>

		<%--=====승인 대기 기사=====--%>
			<div class="sec-head sec-head--row" style="margin-bottom:20px">
				<div>
					<h2>기사 가입 승인 대기 ${fn:length(pendingFixers)}명</h2>
					<p>가입 후 제출한 자격증을 확인하고 승인해 주세요.
						반려하면 사유가 기사에게 전달되고 재제출할 수 있습니다.</p>
				</div>
			</div>

			<c:forEach var="f" items="${pendingFixers}">
				<div class="list-card">
					<div class="list-card__body">
						<div style="display:flex;align-items:center;gap:10px">
							<b style="font-size:19px"><c:out value="${f.name}"/></b>
							<span class="badge badge--warn">승인 대기</span>
						</div>
						<div class="list-card__meta" style="margin-top:6px">
							아이디 <c:out value="${f.userId}"/>
						</div>
						<div class="muted" style="font-size:14.5px;margin-top:4px">
							신청일 ${fn:substring(f.createdAt, 0, 10)}
						</div>
					</div>
					<div class="btn-row">
						<a class="btn btn--ghost btn--sm"
							href="${pageContext.request.contextPath}/admin/members/${f.userNo}">서류 보기</a>


					</div>
				</div>
			</c:forEach>

			<c:if test="${empty pendingFixers}">
				<div class="card card--sm" style="text-align:center;padding:40px">
					<span class="muted">승인 대기 중인 기사가 없습니다.</span>
				</div>
			</c:if>

			<%--=====전체 회원=====--%>
				<div class="sec-head sec-head--row" style="margin:52px 0 20px">
					<h2>전체 회원 ${totalCount}명</h2>
				</div>

				<%-- 검색 --%>
					<form method="get" action="${pageContext.request.contextPath}/admin/members" class="card card--sm"
						style="margin-bottom:16px;display:flex;gap:8px">
						<select name="userRole" class="input" style="width:120px">
							<option value="ALL" <c:if test="${condition.userRole eq 'ALL'}">selected</c:if>>전체
							</option>
							<option value="USER" <c:if test="${condition.userRole eq 'USER'}">selected</c:if>>회원
							</option>
							<option value="FIXER" <c:if test="${condition.userRole eq 'FIXER'}">selected</c:if>>기사
							</option>
						</select>
						<select name="status" class="input" style="width:120px">
							<option value="ALL" <c:if test="${condition.status eq 'ALL'}">selected</c:if>>전체
							</option>
							<option value="ACTIVE" <c:if test="${condition.status eq 'ACTIVE'}">selected</c:if>>정상
							</option>
							<option value="SUSPENDED" <c:if test="${condition.status eq 'SUSPENDED'}">selected
								</c:if>>정지</option>
							<option value="BANNED" <c:if test="${condition.status eq 'BANNED'}">selected</c:if>>차단
							</option>
						</select>
						<input type="text" name="keyword" class="input" style="flex:1" placeholder="이름 또는 아이디"
							value="${fn:escapeXml(condition.keyword)}">
						<button type="submit" class="btn btn--primary btn--sm">검색</button>
					</form>

					<div class="card card--sm">
						<table class="tbl">
							<thead>
								<tr>
									<th style="width:80px">유형</th>
									<th style="width:130px">이름</th>
									<th style="width:130px">가입일</th>
									<th style="width:120px">상태</th>
									<th style="width:90px">평점</th>
									<th style="width:110px">리뷰</th>
									<th></th>
								</tr>
							</thead>
							<tbody>
								<c:forEach var="m" items="${memberList}">
									<tr>
										<td>
											<c:choose>
												<c:when test="${m.userRole eq 'FIXER'}">
													<span class="badge badge--primary">기사</span>
												</c:when>
												<c:otherwise>
													<span class="badge badge--gray">회원</span>
												</c:otherwise>
											</c:choose>
										</td>
										<td class="ttl"><c:out value="${m.name}"/></td>
										<td class="num">${fn:substring(m.createdAt, 0, 10)}</td>
										<td>
											<c:choose>
												<c:when test="${m.status eq 'ACTIVE'}">
													<span class="badge badge--gray">정상</span>
												</c:when>
												<c:when test="${m.status eq 'SUSPENDED'}">
													<span class="badge badge--warn">정지</span>
												</c:when>
												<c:otherwise>
													<span class="badge badge--danger">차단</span>
												</c:otherwise>
											</c:choose>
										</td>
										<td class="num">
											<c:choose>
												<c:when test="${empty m.avgScore}">-</c:when>
												<c:otherwise>${m.avgScore}</c:otherwise>
											</c:choose>
										</td>
										<td class="num">${m.reviewCount}건</td>
										<td class="right">
											<div class="btn-row">
												<a class="btn btn--ghost btn--sm"
													href="${pageContext.request.contextPath}/admin/members/${m.userNo}">상세</a>

											</div>
										</td>
									</tr>
								</c:forEach>

								<c:if test="${empty memberList}">
									<tr>
										<td colspan="7" style="text-align:center;padding:40px" class="muted">
											조회 결과가 없습니다.
										</td>
									</tr>
								</c:if>
							</tbody>
						</table>
					</div>

					<%--=====페이지 번호=====--%>
						<div style="display:flex;gap:6px;justify-content:center;margin-top:24px">
							<c:forEach var="p" begin="1" end="${totalPage}">
								<a class="btn btn--sm ${p == condition.page ? 'btn--primary' : 'btn--ghost'}"
									href="${pageContext.request.contextPath}/admin/members?page=${p}&amp;userRole=${fn:escapeXml(condition.userRole)}&amp;status=${fn:escapeXml(condition.status)}&amp;keyword=${fn:escapeXml(condition.keyword)}">
									${p}
								</a>
							</c:forEach>
						</div>

	</div>

	<%@ include file="../common/admin-footer.jsp" %>