<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!doctype html>
<html lang="ko">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title><c:out value="${profile.fixerName}"/> 기사님 | 수릿 Surit</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/pages.css">
</head>
<body>

<svg width="0" height="0" style="position:absolute" aria-hidden="true">
<defs>
<symbol id="i-user" viewBox="0 0 24 24"><circle cx="12" cy="8" r="4"/><path d="M4.5 20.5a7.5 7.5 0 0 1 15 0"/></symbol>
<symbol id="i-star" viewBox="0 0 24 24"><path d="M12 2.6l2.9 6 6.6.9-4.8 4.6 1.2 6.6L12 17.6 6.1 20.7l1.2-6.6L2.5 9.5l6.6-.9z"/></symbol>
<symbol id="i-shield" viewBox="0 0 24 24"><path d="M12 3l7 3v5.5c0 4.4-3 8-7 9.5-4-1.5-7-5.1-7-9.5V6z"/><path d="M9.2 12l2 2 3.6-3.8"/></symbol>
<symbol id="i-check" viewBox="0 0 24 24"><path d="M4.5 12.5 9.5 17.5 19.5 6.5"/></symbol>
</defs>
</svg>

<jsp:include page="/WEB-INF/views/common/header.jsp" />

<main>
<div class="container" style="max-width:820px">

  <c:if test="${not empty requestId}">
    <p class="muted" style="margin-bottom:18px">
      <a href="${pageContext.request.contextPath}/request/matching/${requestId}">← 목록으로</a>
    </p>
  </c:if>

  <%-- 프로필 헤더 --%>
  <div class="card" style="text-align:center;padding:44px">

    <c:choose>
      <c:when test="${not empty profile.photoUrl}">
        <img src="<c:out value='${profile.photoUrl}'/>" alt="기사 사진"
             style="width:100px;height:100px;border-radius:50%;object-fit:cover;margin:0 auto 18px;border:3px solid var(--p-100)">
      </c:when>
      <c:otherwise>
        <span class="avatar avatar--xl" style="margin:0 auto 18px"><svg><use href="#i-user"/></svg></span>
      </c:otherwise>
    </c:choose>

    <h1 style="font-size:25px;font-weight:800"><c:out value="${profile.fixerName}"/> 기사님</h1>

    <c:if test="${not empty profile.careerYears}">
      <p class="muted" style="margin-top:6px">경력 <c:out value="${profile.careerYears}"/>년</p>
    </c:if>

    <div style="display:flex;justify-content:center;align-items:center;gap:10px;margin-top:14px">
      <c:choose>
        <c:when test="${not empty profile.avgScore}">
          <span class="stars">
            <c:forEach var="i" begin="1" end="5">
              <svg class="${i > profile.avgScore ? 'off' : ''}"><use href="#i-star"/></svg>
            </c:forEach>
          </span>
          <b><c:out value="${profile.avgScore}"/></b>
        </c:when>
        <c:otherwise>
          <span class="muted">아직 등록된 리뷰가 없습니다</span>
        </c:otherwise>
      </c:choose>
      <c:if test="${not empty completedJobCount and completedJobCount > 0}">
        <span class="muted">· 수리 완료 <c:out value="${completedJobCount}"/>건</span>
      </c:if>
    </div>

    <c:if test="${not empty profile.intro}">
      <p style="margin-top:24px;font-size:16px;line-height:1.8;color:var(--g-700);text-align:left;
                padding-top:24px;border-top:1px solid var(--g-100);white-space:pre-wrap">
        <c:out value="${profile.intro}"/>
      </p>
    </c:if>
  </div>

  <%-- 수리 정보 --%>
  <div class="card">
    <div class="card__head"><h2 class="card__title">수리 정보</h2></div>

    <div class="field__label" style="margin-bottom:10px">수리 가능 카테고리</div>
    <div class="chip-row" style="margin-bottom:22px">
      <c:choose>
        <c:when test="${empty categoryNames}">
          <span class="muted">등록된 정보가 없습니다.</span>
        </c:when>
        <c:otherwise>
          <c:forEach var="cat" items="${categoryNames}">
            <span class="chip">${cat}</span>
          </c:forEach>
        </c:otherwise>
      </c:choose>
    </div>

    <div class="field__label" style="margin-bottom:10px">활동 가능 지역</div>
    <div class="chip-row" style="margin-bottom:22px">
      <c:choose>
        <c:when test="${empty regionNames}">
          <span class="muted">등록된 정보가 없습니다.</span>
        </c:when>
        <c:otherwise>
          <c:forEach var="region" items="${regionNames}">
            <span class="chip">${region}</span>
          </c:forEach>
        </c:otherwise>
      </c:choose>
    </div>

    <div class="field__label" style="margin-bottom:10px">보유 자격증 <span class="muted" style="font-weight:400">(관리자 확인 완료)</span></div>
    <div class="chip-row">
      <c:choose>
        <c:when test="${empty licenses}">
          <span class="muted">등록된 자격증이 없습니다.</span>
        </c:when>
        <c:otherwise>
          <c:forEach var="lic" items="${licenses}">
            <span class="chip"><svg class="ico" style="width:16px;height:16px"><use href="#i-check"/></svg><c:out value="${lic.licenseName}"/></span>
          </c:forEach>
        </c:otherwise>
      </c:choose>
    </div>
    <p class="muted" style="font-size:14px;margin-top:14px">
      자격증 원본과 발급번호는 개인정보 보호를 위해 공개하지 않습니다.
    </p>
  </div>

  <%-- 이 접수에 보낸 견적 (requestId 컨텍스트로 들어온 경우만) --%>
  <c:if test="${not empty estimate}">
    <div class="card">
      <div class="card__head">
        <h2 class="card__title">이 접수에 보낸 예상 견적</h2>
        <span class="muted" style="font-size:15px">
          <fmt:formatDate value="${estimate.createdAt}" pattern="MM.dd HH:mm"/> 전송
        </span>
      </div>

      <p style="font-size:16.5px;color:var(--g-700);line-height:1.7;margin-bottom:20px">
        <c:out value="${estimate.content}"/>
      </p>

      <dl class="dl">
        <dt>예상 소요 시간</dt><dd>약 <c:out value="${estimate.estimatedDuration}"/>분</dd>
      </dl>

      <div style="display:flex;justify-content:space-between;align-items:center;
        margin-top:20px;padding-top:20px;border-top:2px solid var(--g-200)">
        <span style="font-size:18px;font-weight:700">예상 합계</span>
        <span style="font-size:30px;font-weight:800;letter-spacing:-1.4px">
          <fmt:formatNumber value="${estimate.estimatedPrice}" pattern="#,##0"/>원
        </span>
      </div>

      <div class="note note--gray" style="margin-top:20px">
        <svg><use href="#i-shield"/></svg>
        <span>확정 금액이 아닙니다. 기사님을 선택하면 채팅이 열리고, 최종 금액은 수리 후 견적서로 확정됩니다.</span>
      </div>

      <c:if test="${estimate.status != 'SELECTED'}">
        <div class="btn-row" style="margin-top:24px">
          <a class="btn btn--ghost btn--lg" href="${pageContext.request.contextPath}/request/matching/${requestId}">거절</a>
          <form method="post" action="${pageContext.request.contextPath}/request/matching/select" style="flex:1">
            <input type="hidden" name="requestId" value="${requestId}">
            <input type="hidden" name="estimateId" value="${estimate.estimateId}">
            <button type="submit" class="btn btn--primary btn--lg" style="width:100%">이 기사님으로 결정</button>
          </form>
        </div>
      </c:if>
      <c:if test="${estimate.status == 'SELECTED'}">
        <div class="note note--ok" style="margin-top:20px">
          <svg><use href="#i-check"/></svg>
          <span>이미 선택된 기사님입니다.</span>
        </div>
      </c:if>
    </div>
  </c:if>

</div>
</main>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
</body>
</html>