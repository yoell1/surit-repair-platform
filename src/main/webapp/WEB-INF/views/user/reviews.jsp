<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!doctype html>
<html lang="ko">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>내가 쓴 리뷰 | 수릿 Surit</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/pages.css">
</head>
<body>

<jsp:include page="/WEB-INF/views/common/header.jsp" />

<main>
<div class="container">

  <div class="page-head page-head--plain">
    <h1>마이페이지</h1>
  </div>

  <div class="with-side">
    <nav class="side-nav">
      <a href="${pageContext.request.contextPath}/user/mypage">
        <svg class="ico"><use href="#i-list"/></svg>나의 접수
      </a>
      <a href="${pageContext.request.contextPath}/user/mypage/address">
        <svg class="ico"><use href="#i-home"/></svg>주소 관리
      </a>
      <a href="${pageContext.request.contextPath}/user/mypage/profile">
        <svg class="ico"><use href="#i-user"/></svg>내 정보 수정
      </a>
      <a href="${pageContext.request.contextPath}/user/mypage/reviews" class="is-active">
        <svg class="ico"><use href="#i-star"/></svg>내가 쓴 리뷰
      </a>
      <a href="${pageContext.request.contextPath}/user/mypage/support">
        <svg class="ico"><use href="#i-chat"/></svg>고객센터
      </a>
    </nav>

    <div>
      <div class="sec-head" style="margin-bottom:20px"><h2>내가 쓴 리뷰 ${fn:length(reviewList)}건</h2></div>

      <c:choose>
        <c:when test="${empty reviewList}">
          <div class="empty">
            <svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><use href="#i-star"/></svg>
            <p>아직 작성한 리뷰가 없습니다.</p>
          </div>
        </c:when>
        <c:otherwise>
          <c:forEach var="review" items="${reviewList}">
            <div class="card card--sm">
              <div class="card__head" style="border:0;padding-bottom:0;margin-bottom:12px">
                <div>
                  <div class="list-card__title" style="margin:0"><c:out value="${review.requestTitle}"/></div>
                  <div class="muted" style="font-size:14.5px;margin-top:4px">
                    <c:out value="${review.fixerName}"/> 기사님 ·
                    <fmt:formatDate value="${review.createdAt}" pattern="yyyy.MM.dd"/>
                  </div>
                </div>
                <span class="stars">
                  <c:forEach var="i" begin="1" end="5">
                    <svg class="${i > review.score ? 'off' : ''}"><use href="#i-star"/></svg>
                  </c:forEach>
                </span>
              </div>
              <p style="font-size:16px;color:var(--g-700);line-height:1.7">
                <c:out value="${review.content}"/>
              </p>
            </div>
          </c:forEach>
        </c:otherwise>
      </c:choose>
    </div>
  </div>

</div>
</main>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
<script src="${pageContext.request.contextPath}/js/common.js"></script>
</body>
</html>