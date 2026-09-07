<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<title>관리자 로그인 | 수릿 Surit</title>
	<link rel="stylesheet" href="/css/style.css">
	<link rel="stylesheet" href="/css/pages.css">
</head>
<body>

<div style="max-width:400px;margin:120px auto;padding:0 20px">

	<div style="text-align:center;margin-bottom:32px">
		<span class="logo__text" style="font-size:32px;font-weight:800">수릿</span>
		<span class="logo__badge logo__badge--admin">ADMIN</span>
		<p class="muted" style="margin-top:8px">관리자 전용 페이지입니다.</p>
	</div>

	<div class="card card--sm">
		<c:if test="${not empty error}">
			<div class="alert" style="margin-bottom:16px;color:#EF4444"><c:out value="${error}"/></div>
		</c:if>

		<form method="post" action="/admin/login">
			<input type="hidden" name="returnUri" value="<c:out value='${returnUri}'/>">

			<label><b>아이디</b></label>
			<input type="text" name="adminId" class="input"
				style="width:100%;margin:8px 0 16px" required autofocus>

			<label><b>비밀번호</b></label>
			<input type="password" name="adminPwd" class="input"
				style="width:100%;margin:8px 0 24px" required>

			<button type="submit" class="btn btn--primary" style="width:100%">로그인</button>
		</form>
	</div>

</div>

</body>
</html>