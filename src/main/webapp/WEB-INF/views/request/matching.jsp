<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!doctype html>
<html lang="ko">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>기사 매칭 | 수릿 Surit</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/pages.css">
</head>
<body>

<svg width="0" height="0" style="position:absolute" aria-hidden="true">
<defs>
<symbol id="i-user" viewBox="0 0 24 24"><circle cx="12" cy="8" r="4"/><path d="M4.5 20.5a7.5 7.5 0 0 1 15 0"/></symbol>
<symbol id="i-star" viewBox="0 0 24 24"><path d="M12 2.6l2.9 6 6.6.9-4.8 4.6 1.2 6.6L12 17.6 6.1 20.7l1.2-6.6L2.5 9.5l6.6-.9z"/></symbol>
<symbol id="i-check" viewBox="0 0 24 24"><path d="M4.5 12.5 9.5 17.5 19.5 6.5"/></symbol>
<symbol id="i-clock" viewBox="0 0 24 24"><circle cx="12" cy="12" r="9"/><path d="M12 7v5l3.5 2"/></symbol>
<symbol id="i-shield" viewBox="0 0 24 24"><path d="M12 3l7 3v5.5c0 4.4-3 8-7 9.5-4-1.5-7-5.1-7-9.5V6z"/><path d="M9.2 12l2 2 3.6-3.8"/></symbol>
<symbol id="i-image" viewBox="0 0 24 24"><rect x="3" y="5" width="18" height="14" rx="2"/><circle cx="8.5" cy="10" r="1.6"/><path d="M4 17l5-5 4 4 3-2 4 4"/></symbol>
</defs>
</svg>

<jsp:include page="/WEB-INF/views/common/header.jsp" />

<main>
<div class="container">

  <div class="page-head page-head--plain">
    <h1>
      <c:out value="${request.title}"/>
      <c:choose>
        <c:when test="${request.statusCode == 'REQ_01'}">
          <span class="badge st-received"><c:out value="${request.statusName}"/></span>
        </c:when>
        <c:when test="${request.statusCode == 'REQ_02'}">
          <span class="badge st-matching"><c:out value="${request.statusName}"/></span>
        </c:when>
        <c:when test="${request.statusCode == 'REQ_03'}">
          <span class="badge st-assigned"><c:out value="${request.statusName}"/></span>
        </c:when>
        <c:when test="${request.statusCode == 'REQ_04'}">
          <span class="badge st-done"><c:out value="${request.statusName}"/></span>
        </c:when>
        <c:when test="${request.statusCode == 'REQ_05'}">
          <span class="badge st-canceled"><c:out value="${request.statusName}"/></span>
        </c:when>
        <%-- 긴급접수(REQ_99). 2026-09-02 추가.
             원래 c:otherwise 가 없어서 REQ_99 면 상태 배지가 아예 안 그려졌다. --%>
        <c:when test="${request.statusCode == 'REQ_99'}">
          <span class="badge st-received"><c:out value="${request.statusName}"/></span>
        </c:when>
      </c:choose>
    </h1>
    <p><fmt:formatDate value="${request.createdAt}" pattern="yyyy.MM.dd HH:mm"/> 접수</p>
  </div>

  <%-- 진행 단계: 접수완료 → 기사매칭 → 방문·수리 → 수리완료
       request.statusCode 기준으로 현재 단계 표시 --%>
  <div style="margin-bottom:36px">
    <div class="steps">
      <div class="steps__item done">
        <div class="steps__dot"><svg><use href="#i-check"/></svg></div>
        <div class="steps__label">접수 완료</div>
      </div>
      <%-- REQ_99(긴급접수)도 "기사 매칭 중" 단계다. 2026-09-02 추가. --%>
      <div class="steps__item ${request.statusCode == 'REQ_01' || request.statusCode == 'REQ_02' || request.statusCode == 'REQ_99' ? 'now' : (request.statusCode == 'REQ_03' || request.statusCode == 'REQ_04' ? 'done' : '')}">
        <div class="steps__dot">
          <c:choose>
            <c:when test="${request.statusCode == 'REQ_03' || request.statusCode == 'REQ_04'}">
              <svg><use href="#i-check"/></svg>
            </c:when>
            <c:otherwise>2</c:otherwise>
          </c:choose>
        </div>
        <div class="steps__label">기사 매칭</div>
      </div>
      <div class="steps__item ${request.statusCode == 'REQ_03' ? 'now' : (request.statusCode == 'REQ_04' ? 'done' : '')}">
        <div class="steps__dot">
          <c:choose>
            <c:when test="${request.statusCode == 'REQ_04'}">
              <svg><use href="#i-check"/></svg>
            </c:when>
            <c:otherwise>3</c:otherwise>
          </c:choose>
        </div>
        <div class="steps__label">방문 · 수리</div>
      </div>
      <div class="steps__item ${request.statusCode == 'REQ_04' ? 'now' : ''}">
        <div class="steps__dot">4</div>
        <div class="steps__label">수리 완료</div>
      </div>
    </div>
  </div>

  <div class="summary" style="margin-bottom:44px">
    <c:if test="${not empty request.photos}">
      <div class="summary__thumbs">
        <c:forEach var="photo" items="${request.photos}" varStatus="ps" begin="0" end="1">
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
    <%-- 긴급접수(REQ_99)도 아직 기사를 안 정한 상태라 수정·취소가 가능하다. 2026-09-02 --%>
    <c:if test="${request.statusCode == 'REQ_01' || request.statusCode == 'REQ_02' || request.statusCode == 'REQ_99'}">
      <div class="summary__actions" style="display: flex; gap: 8px;">
        <!-- 1. 컨트롤러 매핑과 동일하게 /request/{번호}/edit 으로 순서 변경 -->
        <a class="btn btn--ghost btn--sm" href="${pageContext.request.contextPath}/request/${request.requestId}/edit">수정</a>

        <!-- 2. a 태그 대신 form 태그를 사용해 실제 취소 로직(POST)을 타도록 변경 -->
        <form method="post" action="${pageContext.request.contextPath}/request/${request.requestId}/cancel" style="margin: 0;">
          <button type="submit" class="btn btn--danger btn--sm" onclick="return confirm('정말 접수를 취소하시겠습니까?');">접수 취소</button>
        </form>
      </div>
    </c:if>
  </div>

  <div class="sec-head sec-head--row">
    <div>
      <h2>신청한 기사님 ${fn:length(estimateList)}명</h2>
      <p>아래 금액은 기사님이 보낸 <b>예상 견적</b>입니다. 선택하면 기사님이 확인한 뒤 채팅이 열리고,
        그 전까지는 양쪽 모두 취소할 수 있습니다.</p>
    </div>
  </div>

  <c:choose>
    <c:when test="${empty estimateList}">
      <div class="empty">
        <svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><use href="#i-clock"/></svg>
        <p>아직 신청한 기사님이 없습니다. 조금만 기다려 주세요.</p>
      </div>
    </c:when>
    <c:otherwise>
      <c:forEach var="est" items="${estimateList}">
        <div class="tech">
          <div class="tech__top">
            <span class="avatar avatar--lg"><svg><use href="#i-user"/></svg></span>
            <div>
              <div class="tech__name"><c:out value="${est.fixerName}"/> 기사님</div>
              <%-- 경력/평점/후기건수는 EstimateDTO/FixerProfileDTO 확인 후 추가 --%>
            </div>
            <div class="tech__price">
              <small>예상 견적</small>
              <b><fmt:formatNumber value="${est.estimatedPrice}" pattern="#,##0"/>원</b>
            </div>
          </div>

          <p class="tech__msg">
            <c:out value="${est.content}"/>
            <c:if test="${not empty est.estimatedDuration}">
              <br>예상 소요 시간 약 ${est.estimatedDuration}분
            </c:if>
          </p>

          <div class="tech__foot">
            <a class="btn btn--ghost" href="${pageContext.request.contextPath}/fixers/${est.fixerNo}?requestId=${request.requestId}">프로필 보기</a>

            <c:choose>
              <c:when test="${est.status == 'SELECTED'}">
                <span class="badge badge--ok" style="margin-left:auto">선택됨</span>
              </c:when>
              <%-- 긴급접수(REQ_99)에서도 기사를 고를 수 있어야 한다. 2026-09-02 추가.
                   이 조건이 없으면 견적은 들어오는데 "결정" 버튼이 안 그려져서
                   매칭 자체가 불가능했다. --%>
              <c:when test="${request.statusCode == 'REQ_01' || request.statusCode == 'REQ_02' || request.statusCode == 'REQ_99'}">
                <form method="post" action="${pageContext.request.contextPath}/request/matching/select" style="margin-left:auto">
                  <input type="hidden" name="requestId" value="${request.requestId}">
                  <input type="hidden" name="estimateId" value="${est.estimateId}">
                  <button type="submit" class="btn btn--primary btn--lg">이 기사님으로 결정</button>
                </form>
              </c:when>
            </c:choose>
          </div>
        </div>
      </c:forEach>
    </c:otherwise>
  </c:choose>

  <div class="note note--gray" style="margin-top:28px;justify-content:center">
    <svg><use href="#i-clock"/></svg>
    <span>아직 마음에 드는 기사님이 없다면 조금 더 기다려 보세요. 신청은 계속 들어옵니다.</span>
  </div>

  <div class="note note--blue" style="margin-top:16px">
    <svg><use href="#i-shield"/></svg>
    <span><b>선택 이후 진행 순서</b><br>
    기사님 확인 → 채팅 시작 → 채팅에서 방문 일정 확정 → 방문 · 수리 →
    현장에서 결제 → 결제한 금액으로 영수증 겸 견적서 발행</span>
  </div>

</div>
</main>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />

</body>
</html>