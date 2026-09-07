<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<title>관리자 | 수릿 Surit</title>
	<link rel="stylesheet" href="/css/style.css">
	<link rel="stylesheet" href="/css/pages.css">
</head>
<body>

<header class="site-header">
	<div class="site-header__inner">

		<a href="/admin" class="logo">
			<span class="logo__mark">
				<svg viewBox="0 0 24 24"><path d="M8 12h8M8 8h8M8 16h5"/></svg>
			</span>
			<span class="logo__text">수릿</span>
			<span class="logo__badge logo__badge--admin">ADMIN</span>
		</a>

		<%-- 지금 보고 있는 주소를 꺼내서, 그 메뉴에만 is-active 를 붙인다 --%>
		<c:set var="uri" value="${pageContext.request.requestURI}" />

		<nav class="gnb">
			<a href="/admin"
				class="${uri eq '/admin' or uri eq '/admin/' or fn:startsWith(uri, '/admin/requests') ? 'is-active' : ''}">접수 현황</a>
			<a href="/admin/members"
				class="${fn:startsWith(uri, '/admin/members') ? 'is-active' : ''}">회원 · 기사</a>
			<a href="/admin/blacklist"
				class="${fn:startsWith(uri, '/admin/blacklist') ? 'is-active' : ''}">블랙리스트</a>
			<a href="/admin/reviews"
				class="${fn:startsWith(uri, '/admin/reviews') ? 'is-active' : ''}">리뷰</a>
			<a href="/admin/inquiries"
				class="${fn:startsWith(uri, '/admin/inquiries') ? 'is-active' : ''}">문의 응대</a>
		</nav>

		<div class="header-right">
			<div class="profile" id="profile">
				<button type="button" class="profile__btn profile__btn--admin">
					<span class="avatar avatar--sm">
						<svg viewBox="0 0 24 24"><path d="M12 12a4 4 0 1 0 0-8 4 4 0 0 0 0 8zM4 20a8 8 0 0 1 16 0"/></svg>
					</span>
					<span class="profile__who"><c:out value="${sessionScope.admin.adminName}"/>님</span>
					<svg class="caret" viewBox="0 0 24 24"><path d="M6 9l6 6 6-6"/></svg>
				</button>
				<div class="profile__menu">
					<div class="profile__name"><c:out value="${sessionScope.admin.adminName}"/>님</div>
					<hr>
					<a href="/admin/logout" class="logout">로그아웃</a>
				</div>
			</div>
		</div>

	</div>
</header>

<main>