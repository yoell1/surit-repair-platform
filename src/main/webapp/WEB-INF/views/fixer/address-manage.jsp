<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!doctype html>
<html lang="ko">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>주소 관리 | 수릿 Surit</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/pages.css">
</head>
<body>

<svg width="0" height="0" style="position:absolute" aria-hidden="true"><defs><symbol id="i-tools" viewBox="0 0 24 24"><path d="M14.7 6.3a1 1 0 0 0 0 1.4l1.6 1.6a1 1 0 0 0 1.4 0l3.77-3.77a6 6 0 0 1-7.94 7.94l-6.91 6.91a2.12 2.12 0 0 1-3-3l6.91-6.91a6 6 0 0 1 7.94-7.94z"/></symbol><symbol id="i-refresh" viewBox="0 0 24 24"><path d="M20 11a8 8 0 0 0-13.7-5.3L3 9"/><path d="M4 13a8 8 0 0 0 13.7 5.3L21 15"/><path d="M3 4v5h5"/><path d="M21 20v-5h-5"/></symbol><symbol id="i-user" viewBox="0 0 24 24"><circle cx="12" cy="8" r="4"/><path d="M4.5 20.5a7.5 7.5 0 0 1 15 0"/></symbol><symbol id="i-list" viewBox="0 0 24 24"><path d="M8 6h13"/><path d="M8 12h13"/><path d="M8 18h13"/><path d="M3.5 6h.01"/><path d="M3.5 12h.01"/><path d="M3.5 18h.01"/></symbol><symbol id="i-home" viewBox="0 0 24 24"><path d="M4 11.5 12 4l8 7.5"/><path d="M6.5 10.5V20h11v-9.5"/></symbol><symbol id="i-wrench" viewBox="0 0 24 24"><path d="M14.7 6.3a1 1 0 0 0 0 1.4l1.6 1.6a1 1 0 0 0 1.4 0l3.77-3.77a6 6 0 0 1-7.94 7.94l-6.91 6.91a2.12 2.12 0 0 1-3-3l6.91-6.91a6 6 0 0 1 7.94-7.94z"/></symbol><symbol id="i-shield" viewBox="0 0 24 24"><path d="M12 3l7 3v5.5c0 4.4-3 8-7 9.5-4-1.5-7-5.1-7-9.5V6z"/><path d="M9.2 12l2 2 3.6-3.8"/></symbol><symbol id="i-chat" viewBox="0 0 24 24"><path d="M4 6.5A2.5 2.5 0 0 1 6.5 4h11A2.5 2.5 0 0 1 20 6.5v8a2.5 2.5 0 0 1-2.5 2.5H9.5L4 21.5z"/></symbol><symbol id="i-edit" viewBox="0 0 24 24"><path d="M4 20h4L19 9l-4-4L4 16z"/><path d="M14.5 5.5l4 4"/></symbol><symbol id="i-trash" viewBox="0 0 24 24"><path d="M4 7h16"/><path d="M9 7V5h6v2"/><path d="M6 7l1 13h10l1-13"/></symbol><symbol id="i-plus" viewBox="0 0 24 24"><path d="M12 5v14"/><path d="M5 12h14"/></symbol></defs></svg>

<jsp:include page="/WEB-INF/views/common/header.jsp" />

<main>
    <div class="container">
        <div class="page-head page-head--plain"><h1>주소 관리</h1></div>

        <div class="profile-box">
            <span class="avatar avatar--xl"><svg><use href="#i-user"/></svg></span>
            <div>
                <div class="profile-box__name"><c:out value="${user.name}"/> 기사님</div>
                <div class="profile-box__mail"><c:out value="${user.email}"/></div>
            </div>
            <div class="btn-row">
                <a class="btn btn--ghost" href="${pageContext.request.contextPath}/fixer/mypage/profile">내 정보 수정</a>
                <a class="btn btn--dark" href="${pageContext.request.contextPath}/user/mypage"><svg class="ico"><use href="#i-refresh"/></svg>고객으로 전환</a>
            </div>
        </div>

        <div class="with-side">
            <nav class="side-nav">
                <a href="${pageContext.request.contextPath}/fixer/jobs"><svg class="ico"><use href="#i-list"/></svg>내 작업</a>
                <a href="${pageContext.request.contextPath}/fixer/verify"><svg class="ico"><use href="#i-shield"/></svg>기사 인증</a>
                <a href="${pageContext.request.contextPath}/fixer/mypage"><svg class="ico"><use href="#i-wrench"/></svg>수리 정보 관리</a>
                <a href="${pageContext.request.contextPath}/fixer/mypage/address" class="is-active"><svg class="ico"><use href="#i-home"/></svg>주소 관리</a>
                <a href="${pageContext.request.contextPath}/fixer/mypage/profile"><svg class="ico"><use href="#i-user"/></svg>내 정보 수정</a>
            </nav>

            <div>
                <div class="sec-head sec-head--row" style="margin-bottom:24px">
                    <div>
                        <h2>주소 관리</h2>
                        <p>출발 위치 계산에 쓰이는 내 주소입니다. 최대 3개까지 등록할 수 있습니다. (${fn:length(addressList)} / 3)</p>
                    </div>
                </div>

                <c:choose>
                    <c:when test="${empty addressList}">
                        <div class="card card--flat" style="text-align:center;padding:40px">
                            <p class="muted">등록된 주소가 없습니다.</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="addr" items="${addressList}">
                            <div class="list-card">
                                <span class="tile tile--sm t-blue"><svg><use href="#i-home"/></svg></span>
                                <div class="list-card__body">
                                    <div style="display:flex;align-items:center;gap:10px">
                                        <b style="font-size:19px"><c:out value="${addr.alias}"/></b>
                                        <c:if test="${addr.isDefault == 'Y'}">
                                            <span class="badge badge--primary">기본 주소</span>
                                        </c:if>
                                    </div>
                                    <div class="list-card__meta" style="margin-top:6px">
                                        <c:out value="${addr.baseAddress}"/> <c:out value="${addr.detailAddress}"/>
                                    </div>
                                </div>
                                <div class="btn-row">
                                    <a class="btn btn--ghost btn--sm" href="${pageContext.request.contextPath}/fixer/mypage/address/form?id=${addr.id}">
                                        <svg class="ico"><use href="#i-edit"/></svg>수정
                                    </a>
                                    <form method="post" action="${pageContext.request.contextPath}/fixer/mypage/address/delete" style="display:inline;">
                                        <input type="hidden" name="addressId" value="${addr.id}">
                                        <button type="submit" class="btn btn--danger btn--sm" onclick="return confirm('이 주소를 삭제하시겠습니까?');"><svg class="ico"><use href="#i-trash"/></svg>삭제</button>
                                    </form>
                                </div>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>

                <c:if test="${fn:length(addressList) < 3}">
                    <a class="btn btn--ghost btn--block btn--lg" style="margin-top:18px" href="${pageContext.request.contextPath}/fixer/mypage/address/form">
                        <svg class="ico"><use href="#i-plus"/></svg>새 주소 추가하기
                    </a>
                </c:if>

                <div class="note note--gray" style="margin-top:22px">
                    <svg class=""><use href="#i-shield"/></svg>
                    <span>기사님의 주소는 고객에게 공개되지 않습니다. 접수와의 거리를 계산할 때만 사용됩니다.</span>
                </div>
            </div>
        </div>
    </div>
</main>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
<script src="${pageContext.request.contextPath}/js/common.js"></script>
</body>
</html>