<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!doctype html>
<html lang="ko">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>고객센터 | 수릿 Surit</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/pages.css">
</head>
<body>

<svg width="0" height="0" style="position:absolute" aria-hidden="true">
  <defs>
    <symbol id="i-chat" viewBox="0 0 24 24"><path d="M4 6.5A2.5 2.5 0 0 1 6.5 4h11A2.5 2.5 0 0 1 20 6.5v8a2.5 2.5 0 0 1-2.5 2.5H9.5L4 21.5z"/></symbol>
    <symbol id="i-chevd" viewBox="0 0 24 24"><path d="M6 9.5 12 15.5 18 9.5"/></symbol>
  </defs>
</svg>

<jsp:include page="/WEB-INF/views/common/header.jsp" />

<main>

  <div class="container" style="max-width:860px">
    <div class="page-head">
      <h1>고객센터</h1>
      <p>궁금한 점을 먼저 확인해 보세요. 해결되지 않으면 채팅으로 물어보시면 됩니다.</p>
    </div>

    <div class="faq">
      <div class="faq__item is-open">
        <button class="faq__q" type="button">
          수리 전에 들은 견적과 금액이 달라졌어요.<svg class="ico"><use href="#i-chevd"/></svg>
        </button>
        <div class="faq__a">
          기사님이 현장에서 확인 후 추가 작업이 필요한 경우, 반드시 고객님의 동의를 받고 견적서를 다시 보내야 합니다. 수릿은 현장 직접 결제라 <b>결제 전에 견적서를 꼭 확인</b>해 주세요. 동의 없이 금액을 요구받으셨다면 결제 전에 문의해 주시면 즉시 조치합니다.
        </div>
      </div>
      <div class="faq__item">
        <button class="faq__q" type="button">
          접수한 내용을 수정하거나 취소할 수 있나요?<svg class="ico"><use href="#i-chevd"/></svg>
        </button>
        <div class="faq__a">
          기사님을 수락하기 전에는 언제든 무료로 수정·취소할 수 있습니다. 수락한 뒤에도 기사님이 방문하기 전까지는 취소가 가능합니다.
        </div>
      </div>
      <div class="faq__item">
        <button class="faq__q" type="button">
          기사님이 방문하기로 한 시간에 오지 않아요.<svg class="ico"><use href="#i-chevd"/></svg>
        </button>
        <div class="faq__a">
          먼저 채팅으로 연락해 보시고, 답이 없으면 고객센터로 문의해 주세요. 반복되는 기사님은 활동이 정지됩니다.
        </div>
      </div>
      <div class="faq__item">
        <button class="faq__q" type="button">
          수리 후 문제가 다시 생기면 A/S를 받을 수 있나요?<svg class="ico"><use href="#i-chevd"/></svg>
        </button>
        <div class="faq__a">
          수리 완료일로부터 3개월 이내 동일 증상이 재발하면 같은 기사님께 무상 A/S를 요청할 수 있습니다.
        </div>
      </div>
      <div class="faq__item">
        <button class="faq__q" type="button">
          결제는 어떻게 하나요?<svg class="ico"><use href="#i-chevd"/></svg>
        </button>
        <div class="faq__a">
          수릿은 결제를 대행하지 않습니다. 수리가 끝나면 기사님이 보낸 견적서를 확인하고 <b>현장에서 직접</b> 현금이나 카드로 결제하시면 됩니다.
        </div>
      </div>
      <div class="faq__item">
        <button class="faq__q" type="button">
          주소는 왜 3개까지만 등록되나요?<svg class="ico"><use href="#i-chevd"/></svg>
        </button>
        <div class="faq__a">
          집 · 사무실 · 부모님댁처럼 자주 쓰는 곳만 관리하도록 3개로 제한하고 있습니다. 마이페이지 &gt; 주소 관리에서 언제든 바꿀 수 있습니다.
        </div>
      </div>
    </div>

    <div class="card" style="margin-top:44px;text-align:center;padding:44px">
      <span class="tile t-blue" style="margin:0 auto 20px"><svg><use href="#i-chat"/></svg></span>
      <h2 style="font-size:24px;font-weight:800">원하는 답을 찾지 못하셨나요?</h2>
      <p class="muted" style="font-size:17px;margin:12px 0 26px">
        채팅으로 문의하시면 평일 09:00~18:00 사이에 답변드립니다.
      </p>

      <form method="post" action="${pageContext.request.contextPath}/user/mypage/support/new" style="display:inline">
        <button type="submit" class="btn btn--primary btn--lg">
          <svg class="ico"><use href="#i-chat"/></svg>
          <c:choose>
            <c:when test="${empty rooms}">1:1 문의하기</c:when>
            <c:otherwise>문의 이어서 하기</c:otherwise>
          </c:choose>
        </button>
      </form>
    </div>

    <%-- 내 문의 내역 --%>
    <div class="sec-head sec-head--row" style="margin:44px 0 16px"><h2>내 문의 내역</h2></div>

    <c:choose>
      <c:when test="${empty rooms}">
        <div class="card" style="padding:36px">
          <div class="empty">
            <svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path d="M4 6.5A2.5 2.5 0 0 1 6.5 4h11A2.5 2.5 0 0 1 20 6.5v8a2.5 2.5 0 0 1-2.5 2.5H9.5L4 21.5z"/></svg>
            <p>아직 문의하신 내역이 없습니다.</p>
          </div>
        </div>
      </c:when>
      <c:otherwise>
        <c:forEach var="r" items="${rooms}">
          <a class="card" href="${pageContext.request.contextPath}/user/mypage/support/${r.roomId}" style="display:flex;align-items:center;gap:16px;padding:18px 20px;margin-bottom:10px;text-decoration:none;color:inherit">
            <span class="tile t-blue" style="flex:none"><svg><use href="#i-chat"/></svg></span>
            <span style="flex:1;min-width:0">
            <span style="display:block;font-weight:700">
              <c:out value="${empty r.categoryName ? '일반 문의' : r.categoryName}"/>
              <c:if test="${r.unreadCount > 0}">
                <span class="badge badge--danger" style="margin-left:6px">${r.unreadCount}</span>
              </c:if>
            </span>
            <span class="muted" style="display:block;font-size:14.5px;margin-top:4px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap">
              <c:out value="${empty r.lastMessage ? '아직 대화가 없습니다.' : r.lastMessage}"/>
            </span>
          </span>
            <span class="muted" style="flex:none;font-size:13px">
            <c:out value="${empty r.lastSentAt ? r.createdAt : r.lastSentAt}"/>
          </span>
          </a>
        </c:forEach>
      </c:otherwise>
    </c:choose>

  </div>

</main>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
</body>
</html>