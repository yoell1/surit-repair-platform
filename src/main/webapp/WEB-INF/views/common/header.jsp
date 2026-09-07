<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>수릿 Surit</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/pages.css">
</head>
<body>

<!-- 프로젝트 전체 공통 아이콘 스프라이트 (여기 모아두면 모든 페이지에서 안 깨집니다) -->
<svg width="0" height="0" style="position:absolute" aria-hidden="true"><defs>
    <symbol id="i-tools" viewBox="0 0 24 24"><path d="M14.7 6.3a1 1 0 0 0 0 1.4l1.6 1.6a1 1 0 0 0 1.4 0l3.77-3.77a6 6 0 0 1-7.94 7.94l-6.91 6.91a2.12 2.12 0 0 1-3-3l6.91-6.91a6 6 0 0 1 7.94-7.94z"/></symbol>
    <symbol id="i-lock" viewBox="0 0 24 24"><rect x="5" y="10" width="14" height="10" rx="2"/><path d="M8 10V7a4 4 0 0 1 8 0v3"/><circle cx="12" cy="15" r="1.4" fill="currentColor" stroke="none"/></symbol>
    <symbol id="i-fridge" viewBox="0 0 24 24"><rect x="6" y="3" width="12" height="18" rx="2"/><path d="M6 10h12"/><path d="M9 6v2"/><path d="M9 13v2.5"/></symbol>
    <symbol id="i-pc" viewBox="0 0 24 24"><rect x="3" y="5" width="18" height="12" rx="2"/><path d="M9 21h6"/><path d="M12 17v4"/></symbol>
    <symbol id="i-drop" viewBox="0 0 24 24"><path d="M12 3c4 4.5 6 7 6 9a6 6 0 0 1-12 0c0-2 2-4.5 6-9z"/></symbol>
    <symbol id="i-bolt" viewBox="0 0 24 24"><path d="M13 2 5 14h6l-1 8 8-12h-6l1-8z"/></symbol>
    <symbol id="i-washer" viewBox="0 0 24 24"><rect x="5" y="3" width="14" height="18" rx="2"/><circle cx="12" cy="14" r="4"/><path d="M8 6.5h2"/></symbol>
    <symbol id="i-ac" viewBox="0 0 24 24"><rect x="3" y="5" width="18" height="7" rx="2"/><path d="M8 15q2 2 0 4"/><path d="M12 15q2 2 0 4"/><path d="M16 15q2 2 0 4"/></symbol>
    <symbol id="i-chair" viewBox="0 0 24 24"><rect x="6" y="3" width="12" height="8" rx="2"/><path d="M5 13h14"/><path d="M7 21v-4"/><path d="M17 21v-4"/></symbol>
    <symbol id="i-dots" viewBox="0 0 24 24"><circle cx="5" cy="12" r="1.6" fill="currentColor" stroke="none"/><circle cx="12" cy="12" r="1.6" fill="currentColor" stroke="none"/><circle cx="19" cy="12" r="1.6" fill="currentColor" stroke="none"/></symbol>
    <symbol id="i-pin" viewBox="0 0 24 24"><path d="M12 21s7-6.2 7-11a7 7 0 1 0-14 0c0 4.8 7 11 7 11z"/><circle cx="12" cy="10" r="2.6"/></symbol>
    <symbol id="i-clock" viewBox="0 0 24 24"><circle cx="12" cy="12" r="9"/><path d="M12 7v5l3.5 2"/></symbol>
    <symbol id="i-chat" viewBox="0 0 24 24"><path d="M4 6.5A2.5 2.5 0 0 1 6.5 4h11A2.5 2.5 0 0 1 20 6.5v8a2.5 2.5 0 0 1-2.5 2.5H9.5L4 21.5z"/></symbol>
    <symbol id="i-shield" viewBox="0 0 24 24"><path d="M12 3l7 3v5.5c0 4.4-3 8-7 9.5-4-1.5-7-5.1-7-9.5V6z"/><path d="M9.2 12l2 2 3.6-3.8"/></symbol>
    <symbol id="i-card" viewBox="0 0 24 24"><rect x="2.5" y="5.5" width="19" height="13" rx="2.5"/><path d="M2.5 10h19"/></symbol>
    <symbol id="i-search" viewBox="0 0 24 24"><circle cx="11" cy="11" r="7"/><path d="M16.2 16.2 21 21"/></symbol>
    <symbol id="i-bell" viewBox="0 0 24 24"><path d="M18 15V10a6 6 0 1 0-12 0v5l-1.6 2.5h15.2z"/><path d="M10 20.5a2.2 2.2 0 0 0 4 0"/></symbol>
    <symbol id="i-doc" viewBox="0 0 24 24"><path d="M14 3H7a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h10a2 2 0 0 0 2-2V8z"/><path d="M14 3v5h5"/><path d="M9 13h6"/><path d="M9 17h6"/></symbol>
    <symbol id="i-user" viewBox="0 0 24 24"><circle cx="12" cy="8" r="4"/><path d="M4.5 20.5a7.5 7.5 0 0 1 15 0"/></symbol>
    <symbol id="i-users" viewBox="0 0 24 24"><circle cx="9" cy="8" r="3.6"/><path d="M2.5 20a6.5 6.5 0 0 1 13 0"/><path d="M16 5.2a3.6 3.6 0 0 1 0 6.4"/><path d="M18.5 20a5.6 5.6 0 0 0-3-4.5"/></symbol>
    <symbol id="i-home" viewBox="0 0 24 24"><path d="M4 11.5 12 4l8 7.5"/><path d="M6.5 10.5V20h11v-9.5"/></symbol>
    <symbol id="i-star" viewBox="0 0 24 24"><path d="M12 2.6l2.9 6 6.6.9-4.8 4.6 1.2 6.6L12 17.6 6.1 20.7l1.2-6.6L2.5 9.5l6.6-.9z"/></symbol>
    <symbol id="i-check" viewBox="0 0 24 24"><path d="M4.5 12.5 9.5 17.5 19.5 6.5"/></symbol>
    <symbol id="i-chevd" viewBox="0 0 24 24"><path d="M6 9.5 12 15.5 18 9.5"/></symbol>
    <symbol id="i-chevr" viewBox="0 0 24 24"><path d="M9.5 6 15.5 12 9.5 18"/></symbol>
    <symbol id="i-plus" viewBox="0 0 24 24"><path d="M12 5v14"/><path d="M5 12h14"/></symbol>
    <symbol id="i-camera" viewBox="0 0 24 24"><path d="M4 8h3l1.5-2h7L17 8h3a1 1 0 0 1 1 1v9a1 1 0 0 1-1 1H4a1 1 0 0 1-1-1V9a1 1 0 0 1 1-1z"/><circle cx="12" cy="13.5" r="3.6"/></symbol>
    <symbol id="i-image" viewBox="0 0 24 24"><rect x="3" y="5" width="18" height="14" rx="2"/><circle cx="8.5" cy="10" r="1.6"/><path d="M4 17l5-5 4 4 3-2 4 4"/></symbol>
    <symbol id="i-send" viewBox="0 0 24 24"><path d="M21 3 10.5 13.5"/><path d="M21 3l-7 18-3.5-7.5L3 10z"/></symbol>
    <symbol id="i-refresh" viewBox="0 0 24 24"><path d="M20 11a8 8 0 0 0-13.7-5.3L3 9"/><path d="M4 13a8 8 0 0 0 13.7 5.3L21 15"/><path d="M3 4v5h5"/><path d="M21 20v-5h-5"/></symbol>
    <symbol id="i-logout" viewBox="0 0 24 24"><path d="M14 4h4a2 2 0 0 1 2 2v12a2 2 0 0 1-2 2h-4"/><path d="M10 8l-4 4 4 4"/><path d="M6 12h9"/></symbol>
    <symbol id="i-edit" viewBox="0 0 24 24"><path d="M4 20h4L19 9l-4-4L4 16z"/><path d="M14.5 5.5l4 4"/></symbol>
    <symbol id="i-trash" viewBox="0 0 24 24"><path d="M4 7h16"/><path d="M9 7V5h6v2"/><path d="M6 7l1 13h10l1-13"/></symbol>
    <symbol id="i-alert" viewBox="0 0 24 24"><circle cx="12" cy="12" r="9"/><path d="M12 7.5v5.5"/><circle cx="12" cy="16.5" r="1.1" fill="currentColor" stroke="none"/></symbol>
    <symbol id="i-x" viewBox="0 0 24 24"><path d="M6 6l12 12"/><path d="M18 6L6 18"/></symbol>
    <symbol id="i-ban" viewBox="0 0 24 24"><circle cx="12" cy="12" r="9"/><path d="M5.6 5.6l12.8 12.8"/></symbol>
    <symbol id="i-list" viewBox="0 0 24 24"><path d="M8 6h13"/><path d="M8 12h13"/><path d="M8 18h13"/><path d="M3.5 6h.01"/><path d="M3.5 12h.01"/><path d="M3.5 18h.01"/></symbol>
    <symbol id="i-board" viewBox="0 0 24 24"><rect x="3" y="4" width="18" height="16" rx="2"/><path d="M3 9h18"/><path d="M9 9v11"/></symbol>
    <symbol id="i-wrench" viewBox="0 0 24 24"><path d="M14.7 6.3a1 1 0 0 0 0 1.4l1.6 1.6a1 1 0 0 0 1.4 0l3.77-3.77a6 6 0 0 1-7.94 7.94l-6.91 6.91a2.12 2.12 0 0 1-3-3l6.91-6.91a6 6 0 0 1 7.94-7.94z"/></symbol>
    <symbol id="i-money" viewBox="0 0 24 24"><circle cx="12" cy="12" r="9"/><path d="M9.5 9.5h5"/><path d="M9.5 12.5h5"/><path d="M12 7.5v9"/></symbol>
</defs></svg>

<%-- 핵심 로직: 로그인 유저 권한이 FIXER이면서, 현재 URL 경로가 /fixer/ 로 시작해야만 기사 모드로 간주 --%>
<c:set var="uri" value="${pageContext.request.requestURI}" />
<c:set var="isFixerMode" value="${not empty sessionScope.loginMember and sessionScope.loginMember.userRole eq 'FIXER' and fn:contains(uri, '/fixer/')}" />

<header class="site-header">
    <div class="site-header__inner">

        <c:choose>
            <c:when test="${isFixerMode}">
                <a class="logo" href="${pageContext.request.contextPath}/fixer/requests">
                    <span class="logo__mark"><svg><use href="#i-tools"/></svg></span>
                    <span class="logo__text">수릿</span>
                    <span class="logo__badge logo__badge--tech">기사</span>
                </a>
            </c:when>
            <c:otherwise>
                <a class="logo" href="${pageContext.request.contextPath}/">
                    <span class="logo__mark"><svg><use href="#i-tools"/></svg></span>
                    <span class="logo__text">수릿</span>
                </a>
            </c:otherwise>
        </c:choose>

        <nav class="gnb">
            <c:choose>
                <c:when test="${isFixerMode}">
                    <a href="${pageContext.request.contextPath}/fixer/requests" class="${fn:contains(uri, '/requests') ? 'is-active' : ''}">접수 찾기</a>
                    <a href="${pageContext.request.contextPath}/chat" class="${fn:contains(uri, '/chat') ? 'is-active' : ''}">채팅하기</a>
                    <a href="${pageContext.request.contextPath}/support" class="${fn:contains(uri, '/support') ? 'is-active' : ''}">고객센터</a>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/request/request" class="${fn:contains(uri, '/request') ? 'is-active' : ''}">수리 접수</a>
                    <a href="${pageContext.request.contextPath}/chat" class="${fn:contains(uri, '/chat') ? 'is-active' : ''}">채팅하기</a>
                    <a href="${pageContext.request.contextPath}/support" class="${fn:contains(uri, '/support') ? 'is-active' : ''}">고객센터</a>
                </c:otherwise>
            </c:choose>
        </nav>

        <div class="header-right">
            <c:choose>
                <c:when test="${not empty sessionScope.loginMember}">
                    <div class="profile" id="profile">
                        <button class="profile__btn ${isFixerMode ? 'profile__btn--tech' : ''}" type="button">
                            <span class="avatar avatar--sm"><svg><use href="#i-user"/></svg></span>
                            <span class="profile__who"><c:out value="${sessionScope.loginMember.name}"/> ${isFixerMode ? '기사님' : '고객님'}</span>
                            <svg class="caret"><use href="#i-chevd"/></svg>
                        </button>
                        <div class="profile__menu">
                            <div class="profile__name"><c:out value="${sessionScope.loginMember.name}"/>님</div>
                            <hr>
                            <c:choose>
                                <c:when test="${isFixerMode}">
                                    <a href="${pageContext.request.contextPath}/fixer/jobs"><svg class="ico"><use href="#i-user"/></svg>마이페이지</a>
                                    <hr>
                                    <a class="switch" href="${pageContext.request.contextPath}/user/mypage"><svg class="ico"><use href="#i-refresh"/></svg>고객으로 전환</a>
                                </c:when>
                                <c:otherwise>
                                    <a href="${pageContext.request.contextPath}/user/mypage"><svg class="ico"><use href="#i-user"/></svg>마이페이지</a>
                                    <hr>
                                    <c:if test="${sessionScope.loginMember.userRole eq 'FIXER'}">
                                        <a class="switch" href="${pageContext.request.contextPath}/fixer/requests"><svg class="ico"><use href="#i-refresh"/></svg>기사로 전환</a>
                                    </c:if>
                                    <c:if test="${sessionScope.loginMember.userRole ne 'FIXER'}">
                                        <a class="switch" href="${pageContext.request.contextPath}/fixer/verify"><svg class="ico"><use href="#i-refresh"/></svg>기사로 전환</a>
                                    </c:if>
                                </c:otherwise>
                            </c:choose>
                            <a class="logout" href="${pageContext.request.contextPath}/user/logout"><svg class="ico"><use href="#i-logout"/></svg>로그아웃</a>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/user/login" class="btn btn--ghost btn--sm">로그인</a>
                    <a href="${pageContext.request.contextPath}/user/sign" class="btn btn--primary btn--sm">회원가입</a>
                </c:otherwise>
            </c:choose>
        </div>

    </div>
</header>

<main>