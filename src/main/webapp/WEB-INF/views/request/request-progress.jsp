<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!doctype html>
<html lang="ko">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>접수 상세 | 수릿 Surit</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/pages.css">
</head>
<body>

<svg width="0" height="0" style="position:absolute" aria-hidden="true">
<defs>
<symbol id="i-user" viewBox="0 0 24 24"><circle cx="12" cy="8" r="4"/><path d="M4.5 20.5a7.5 7.5 0 0 1 15 0"/></symbol>
<symbol id="i-star" viewBox="0 0 24 24"><path d="M12 2.6l2.9 6 6.6.9-4.8 4.6 1.2 6.6L12 17.6 6.1 20.7l1.2-6.6L2.5 9.5l6.6-.9z"/></symbol>
<symbol id="i-check" viewBox="0 0 24 24"><path d="M4.5 12.5 9.5 17.5 19.5 6.5"/></symbol>
<symbol id="i-chat" viewBox="0 0 24 24"><path d="M4 6.5A2.5 2.5 0 0 1 6.5 4h11A2.5 2.5 0 0 1 20 6.5v8a2.5 2.5 0 0 1-2.5 2.5H9.5L4 21.5z"/></symbol>
<symbol id="i-shield" viewBox="0 0 24 24"><path d="M12 3l7 3v5.5c0 4.4-3 8-7 9.5-4-1.5-7-5.1-7-9.5V6z"/><path d="M9.2 12l2 2 3.6-3.8"/></symbol>
<symbol id="i-alert" viewBox="0 0 24 24"><circle cx="12" cy="12" r="9"/><path d="M12 7.5v5.5"/><circle cx="12" cy="16.5" r="1.1" fill="currentColor" stroke="none"/></symbol>
<symbol id="i-image" viewBox="0 0 24 24"><rect x="3" y="5" width="18" height="14" rx="2"/><circle cx="8.5" cy="10" r="1.6"/><path d="M4 17l5-5 4 4 3-2 4 4"/></symbol>
<symbol id="i-x" viewBox="0 0 24 24"><path d="M6 6l12 12"/><path d="M18 6L6 18"/></symbol>
</defs>
</svg>

<jsp:include page="/WEB-INF/views/common/header.jsp" />

<main>
<div class="container" style="max-width:900px">

  <div class="page-head page-head--plain">
    <h1>
      <c:out value="${request.title}"/>
      <span class="badge st-assigned"><c:out value="${request.statusName}"/></span>
    </h1>
    <p><fmt:formatDate value="${request.createdAt}" pattern="yyyy.MM.dd HH:mm"/> 접수</p>
  </div>

  <%-- 진행 단계 --%>
  <div style="margin-bottom:40px">
    <div class="steps">
      <div class="steps__item done">
        <div class="steps__dot"><svg><use href="#i-check"/></svg></div>
        <div class="steps__label">접수 완료</div>
      </div>
      <div class="steps__item done">
        <div class="steps__dot"><svg><use href="#i-check"/></svg></div>
        <div class="steps__label">기사 매칭</div>
      </div>
      <div class="steps__item now">
        <div class="steps__dot">3</div>
        <div class="steps__label">방문 · 수리</div>
      </div>
      <div class="steps__item">
        <div class="steps__dot">4</div>
        <div class="steps__label">수리 완료</div>
      </div>
    </div>
  </div>

  <%-- ⚠ 방문 일시는 채팅에서 정한다고만 되어있고, 이걸 저장할 DB 컬럼이
       아직 없어요. 채팅 기능/방문일시 저장 컬럼 만드시면 여기 채워드릴게요. --%>
  <div class="card" style="border-color:var(--p-200)">
    <div class="card__head">
      <h2 class="card__title">확정된 예약</h2>
    </div>
    <dl class="dl">
      <dt>방문 일시</dt><dd class="muted">채팅에서 일정을 확정해 주세요</dd>
      <dt>방문 주소</dt><dd><c:out value="${request.serviceAddress}"/></dd>
      <dt>연락</dt><dd>채팅으로만 (번호 비공개)</dd>
    </dl>
    <div class="btn-row" style="margin-top:26px">
      <form method="post" action="${pageContext.request.contextPath}/request/${request.requestId}/cancel" style="display:inline">
        <button type="submit" class="btn btn--danger btn--lg">
          <svg class="ico"><use href="#i-x"/></svg>접수 취소
        </button>
      </form>
      <%-- ⚠ /chat 컨트롤러 아직 미확인 --%>
      <a class="btn btn--soft btn--xl" style="flex:1" href="${pageContext.request.contextPath}/chat">
        <svg class="ico"><use href="#i-chat"/></svg>기사님과 채팅하기
      </a>
    </div>
    <div class="note note--gray" style="margin-top:20px">
      <svg><use href="#i-shield"/></svg>
      <span>방문 전까지는 취소할 수 있고, 지금까지 발생한 비용은 없습니다.
      시간을 바꾸고 싶다면 취소 대신 <b>채팅에서 일정을 다시 정해</b> 주세요.</span>
    </div>
  </div>

  <%-- 담당 기사 (선택된 견적의 기사) --%>
  <c:if test="${not empty selectedEstimate}">
    <div class="card">
      <div class="card__head"><h2 class="card__title">담당 기사님</h2></div>
      <div style="display:flex;align-items:center;gap:20px">
        <span class="avatar avatar--lg"><svg><use href="#i-user"/></svg></span>
        <div>
          <div style="font-size:21px;font-weight:700"><c:out value="${selectedEstimate.fixerName}"/> 기사님</div>
        </div>
        <a class="btn btn--ghost btn--lg" style="margin-left:auto"
           href="${pageContext.request.contextPath}/fixers/${selectedEstimate.fixerNo}">프로필 보기</a>
      </div>
    </div>

    <%-- 예상 견적 --%>
    <div class="card">
      <div class="card__head">
        <h2 class="card__title">기사님이 보낸 예상 견적</h2>
        <span class="muted" style="font-size:15px">
          <fmt:formatDate value="${selectedEstimate.createdAt}" pattern="MM.dd HH:mm"/> 전송
        </span>
      </div>
      <dl class="dl">
        <dt><c:out value="${request.categoryName}"/></dt>
        <dd><fmt:formatNumber value="${selectedEstimate.estimatedPrice}" pattern="#,##0"/>원</dd>
      </dl>
      <div style="display:flex;justify-content:space-between;align-items:center;
        margin-top:20px;padding-top:20px;border-top:2px solid var(--g-200)">
        <span style="font-size:18px;font-weight:700">예상 합계</span>
        <span style="font-size:32px;font-weight:800;letter-spacing:-1.4px">
          <fmt:formatNumber value="${selectedEstimate.estimatedPrice}" pattern="#,##0"/>원
        </span>
      </div>
      <c:if test="${not empty selectedEstimate.content}">
        <div class="note note--blue" style="margin-top:22px">
          <svg><use href="#i-alert"/></svg>
          <span><c:out value="${selectedEstimate.content}"/></span>
        </div>
      </c:if>
    </div>
  </c:if>

  <%-- 접수 내용 --%>
  <div class="summary">
    <c:if test="${not empty request.photos}">
      <div class="summary__thumbs">
        <c:forEach var="photo" items="${request.photos}" begin="0" end="1">
          <span class="thumb"><svg><use href="#i-image"/></svg></span>
        </c:forEach>
      </div>
    </c:if>
    <div class="summary__body">
      <div class="summary__title">접수 내용</div>
      <p style="font-size:16.5px;color:var(--g-700);margin-bottom:14px">
        <c:out value="${request.content}"/>
      </p>
      <div class="summary__meta">
        <span>카테고리 <b><c:out value="${request.categoryName}"/></b></span>
        <span>방문 주소 <b><c:out value="${request.serviceAddress}"/></b></span>
      </div>
    </div>
  </div>
</div>

</main>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
</body>
</html>