<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!doctype html>
<html lang="ko">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>마이페이지 | 수릿 Surit</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/pages.css">
</head>
<body>
<svg width="0" height="0" style="position:absolute" aria-hidden="true">
<defs>
<symbol id="i-list" viewBox="0 0 24 24"><path d="M8 6h13"/><path d="M8 12h13"/><path d="M8 18h13"/><path d="M3.5 6h.01"/><path d="M3.5 12h.01"/><path d="M3.5 18h.01"/></symbol>
<symbol id="i-home" viewBox="0 0 24 24"><path d="M4 11.5 12 4l8 7.5"/><path d="M6.5 10.5V20h11v-9.5"/></symbol>
<symbol id="i-user" viewBox="0 0 24 24"><circle cx="12" cy="8" r="4"/><path d="M4.5 20.5a7.5 7.5 0 0 1 15 0"/></symbol>
<symbol id="i-star" viewBox="0 0 24 24"><path d="M12 2.6l2.9 6 6.6.9-4.8 4.6 1.2 6.6L12 17.6 6.1 20.7l1.2-6.6L2.5 9.5l6.6-.9z"/></symbol>
<symbol id="i-chat" viewBox="0 0 24 24"><path d="M4 6.5A2.5 2.5 0 0 1 6.5 4h11A2.5 2.5 0 0 1 20 6.5v8a2.5 2.5 0 0 1-2.5 2.5H9.5L4 21.5z"/></symbol>
<symbol id="i-refresh" viewBox="0 0 24 24"><path d="M20 11a8 8 0 0 0-13.7-5.3L3 9"/><path d="M4 13a8 8 0 0 0 13.7 5.3L21 15"/><path d="M3 4v5h5"/><path d="M21 20v-5h-5"/></symbol>
</defs>
</svg>

<jsp:include page="/WEB-INF/views/common/header.jsp" />

<main>
<div class="container">

  <div class="page-head page-head--plain">
    <h1>마이페이지</h1>
  </div>

  <div class="profile-box">
    <span class="avatar avatar--xl"><svg><use href="#i-user"/></svg></span>
    <div>
      <div class="profile-box__name"><c:out value="${user.name}"/> 고객님</div>
      <div class="profile-box__mail"><c:out value="${user.email}"/></div>
    </div>
    <div class="btn-row">
      <a class="btn btn--ghost" href="${pageContext.request.contextPath}/user/mypage/profile">내 정보 수정</a>
      <c:choose>
        <%-- FIXER 권한이 있는 경우: 기사 마이페이지로 이동 --%>
        <c:when test="${user.userRole == 'FIXER'}">
          <a class="btn btn--dark" href="${pageContext.request.contextPath}/fixer/mypage">
            <svg class="ico"><use href="#i-refresh"/></svg>기사로 전환
          </a>
        </c:when>

        <%-- USER인 경우: 기사 인증(가입) 화면으로 이동 --%>
        <c:otherwise>
          <a class="btn btn--dark" href="${pageContext.request.contextPath}/fixer/verify">
            <svg class="ico"><use href="#i-refresh"/></svg>기사로 전환
          </a>
        </c:otherwise>
      </c:choose>
    </div>
  </div>

  <div class="with-side">

    <nav class="side-nav">
      <a href="${pageContext.request.contextPath}/user/mypage" class="is-active">
        <svg class="ico"><use href="#i-list"/></svg>나의 접수
      </a>
      <a href="${pageContext.request.contextPath}/user/mypage/address">
        <svg class="ico"><use href="#i-home"/></svg>주소 관리
      </a>
      <a href="${pageContext.request.contextPath}/user/mypage/profile">
        <svg class="ico"><use href="#i-user"/></svg>내 정보 수정
      </a>
      <a href="${pageContext.request.contextPath}/user/mypage/reviews">
        <svg class="ico"><use href="#i-star"/></svg>내가 쓴 리뷰
      </a>
      <a href="${pageContext.request.contextPath}/user/mypage/support">
        <svg class="ico"><use href="#i-chat"/></svg>고객센터
      </a>
    </nav>

    <div>
      <div class="sec-head sec-head--row" style="margin-bottom:20px">
        <h2>나의 접수</h2>
      </div>

      <%-- 상단 상태 탭: 실제 COMMON_CODE(STATUS) 코드 그대로 표시 --%>
      <div class="chip-row" style="margin-bottom:24px" id="status-filter">
        <button class="chip chip--dark" data-status-filter="all">전체 ${fn:length(requestList)}</button>
        <button class="chip" data-status-filter="REQ_01">접수대기 ${waitingCnt}</button>
        <button class="chip" data-status-filter="REQ_02">견적중 ${estimatingCnt}</button>
        <button class="chip" data-status-filter="REQ_99">긴급 ${urgentCnt}</button>
        <button class="chip" data-status-filter="REQ_03">매칭완료 ${matchedCnt}</button>
        <button class="chip" data-status-filter="REQ_04">수리완료 ${doneCnt}</button>
        <button class="chip" data-status-filter="REQ_05">취소 ${canceledCnt}</button>
      </div>

      <div class="card card--sm">
        <table class="tbl">
          <thead>
            <tr>
              <th style="width:90px">접수일</th>
              <th>수리 항목</th>
              <th style="width:110px">견적 수</th>
              <th style="width:120px">상태</th>
              <th style="width:120px"></th>
            </tr>
          </thead>
          <tbody>
          <c:choose>
            <c:when test="${empty requestList}">
              <tr>
                <td colspan="5">
                  <div class="empty">
                    <svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                      <path d="M4 6.5A2.5 2.5 0 0 1 6.5 4h11A2.5 2.5 0 0 1 20 6.5v8a2.5 2.5 0 0 1-2.5 2.5H9.5L4 21.5z"/>
                    </svg>
                    <p>아직 접수한 내역이 없습니다.</p>
                  </div>
                </td>
              </tr>
            </c:when>
            <c:otherwise>
              <c:forEach var="req" items="${requestList}">
                <tr data-status-row="${req.statusCode}">
                  <td class="num"><fmt:formatDate value="${req.createdAt}" pattern="MM.dd"/></td>
                  <td>
                    <div class="ttl"><c:out value="${req.title}"/></div>
                    <div class="muted" style="font-size:14.5px;margin-top:4px">
                      <c:out value="${req.categoryName}"/>
                    </div>
                  </td>
                  <td>
                    <c:choose>
                      <c:when test="${req.estimateCount > 0}">
                        <b><c:out value="${req.estimateCount}"/>건</b>
                      </c:when>
                      <c:otherwise>
                        <span class="muted">-</span>
                      </c:otherwise>
                    </c:choose>
                  </td>
                  <td>
                    <c:choose>
                      <c:when test="${req.statusCode == 'REQ_01'}">
                        <span class="badge st-received"><c:out value="${req.statusName}"/></span>
                      </c:when>
                      <c:when test="${req.statusCode == 'REQ_02'}">
                        <span class="badge st-matching"><c:out value="${req.statusName}"/></span>
                      </c:when>
                      <c:when test="${req.statusCode == 'REQ_03'}">
                        <span class="badge st-assigned"><c:out value="${req.statusName}"/></span>
                      </c:when>
                      <c:when test="${req.statusCode == 'REQ_04'}">
                        <span class="badge st-done"><c:out value="${req.statusName}"/></span>
                      </c:when>
                      <c:when test="${req.statusCode == 'REQ_05'}">
                        <span class="badge st-canceled"><c:out value="${req.statusName}"/></span>
                      </c:when>
                      <c:otherwise>
                        <span class="badge badge--gray"><c:out value="${req.statusName}"/></span>
                      </c:otherwise>
                    </c:choose>
                  </td>
                  <td class="right">
                    <c:choose>
                      <%-- 아직 기사를 안 정한 접수는 매칭 화면으로 보낸다.
                           REQ_99(긴급접수) 2026-09-02 추가 — 없으면 긴급 건만
                           일반 상세로 빠져서 견적을 고를 수가 없다. --%>
                      <c:when test="${req.statusCode == 'REQ_01' || req.statusCode == 'REQ_02' || req.statusCode == 'REQ_99'}">
                        <a class="btn btn--ghost btn--sm" href="${pageContext.request.contextPath}/request/matching/${req.requestId}">상세 보기</a>
                      </c:when>
                      <c:otherwise>
                        <a class="btn btn--ghost btn--sm" href="${pageContext.request.contextPath}/request/${req.requestId}">상세 보기</a>
                      </c:otherwise>
                    </c:choose>
                  </td>
                </tr>
              </c:forEach>
            </c:otherwise>
          </c:choose>
          </tbody>
        </table>
      </div>
    </div>

  </div>
</div>
</main>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />

</body>
</html>