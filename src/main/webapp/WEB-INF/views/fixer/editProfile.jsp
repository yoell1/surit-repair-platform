<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!doctype html>
<html lang="ko">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>내 정보 수정 | 수릿 Surit</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/pages.css">
</head>
<body>

<svg width="0" height="0" style="position:absolute" aria-hidden="true"><defs><symbol id="i-tools" viewBox="0 0 24 24"><path d="M14.7 6.3a1 1 0 0 0 0 1.4l1.6 1.6a1 1 0 0 0 1.4 0l3.77-3.77a6 6 0 0 1-7.94 7.94l-6.91 6.91a2.12 2.12 0 0 1-3-3l6.91-6.91a6 6 0 0 1 7.94-7.94z"/></symbol><symbol id="i-refresh" viewBox="0 0 24 24"><path d="M20 11a8 8 0 0 0-13.7-5.3L3 9"/><path d="M4 13a8 8 0 0 0 13.7 5.3L21 15"/><path d="M3 4v5h5"/><path d="M21 20v-5h-5"/></symbol><symbol id="i-user" viewBox="0 0 24 24"><circle cx="12" cy="8" r="4"/><path d="M4.5 20.5a7.5 7.5 0 0 1 15 0"/></symbol><symbol id="i-list" viewBox="0 0 24 24"><path d="M8 6h13"/><path d="M8 12h13"/><path d="M8 18h13"/><path d="M3.5 6h.01"/><path d="M3.5 12h.01"/><path d="M3.5 18h.01"/></symbol><symbol id="i-home" viewBox="0 0 24 24"><path d="M4 11.5 12 4l8 7.5"/><path d="M6.5 10.5V20h11v-9.5"/></symbol><symbol id="i-wrench" viewBox="0 0 24 24"><path d="M14.7 6.3a1 1 0 0 0 0 1.4l1.6 1.6a1 1 0 0 0 1.4 0l3.77-3.77a6 6 0 0 1-7.94 7.94l-6.91 6.91a2.12 2.12 0 0 1-3-3l6.91-6.91a6 6 0 0 1 7.94-7.94z"/></symbol><symbol id="i-shield" viewBox="0 0 24 24"><path d="M12 3l7 3v5.5c0 4.4-3 8-7 9.5-4-1.5-7-5.1-7-9.5V6z"/><path d="M9.2 12l2 2 3.6-3.8"/></symbol><symbol id="i-chat" viewBox="0 0 24 24"><path d="M4 6.5A2.5 2.5 0 0 1 6.5 4h11A2.5 2.5 0 0 1 20 6.5v8a2.5 2.5 0 0 1-2.5 2.5H9.5L4 21.5z"/></symbol></defs></svg>

<jsp:include page="/WEB-INF/views/common/header.jsp" />

<main>
    <div class="container">
        <div class="page-head page-head--plain"><h1>내 정보 수정</h1></div>

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
                <a href="${pageContext.request.contextPath}/fixer/mypage/address"><svg class="ico"><use href="#i-home"/></svg>주소 관리</a>
                <a href="${pageContext.request.contextPath}/fixer/mypage/profile" class="is-active"><svg class="ico"><use href="#i-user"/></svg>내 정보 수정</a>
                <a href="${pageContext.request.contextPath}/support"><svg class="ico"><use href="#i-chat"/></svg>고객센터</a>
            </nav>

            <div>
                <div class="sec-head" style="margin-bottom:24px"><h2>내 정보 수정</h2></div>

                <form action="${pageContext.request.contextPath}/fixer/mypage/profile" method="post">
                    <div class="card">
                        <div class="field">
                            <label class="field__label">아이디</label>
                            <input type="text" class="input" value="${user.userId}" readonly style="background:var(--g-50)">
                            <div class="field__help">아이디는 변경할 수 없습니다.</div>
                        </div>
                        <div class="field">
                            <label class="field__label">이름</label>
                            <input type="text" name="name" class="input" value="${user.name}" required>
                        </div>
                        <div class="field">
							<label class="field__label" for="p-phone">전화번호<span class="req">*</span></label>
							 <input type="text" id="p-phone" name="phone" class="input" value="${user.phone}" placeholder="01012345678" required>
							 <p id="check-phone-result" class="field__help" aria-live="polite"></p>
                            <div class="field__help">번호는 고객에게 공개되지 않고, 알림 발송에만 사용됩니다.</div>
                        </div>
                        <div class="field">
                            <label class="field__label">이메일</label>
                            <input type="email" name="email" class="input" value="${user.email}" required>
                        </div>
                        <div class="field">
                            <label class="field__label">새 비밀번호</label>
                            <input type="password" name="password" class="input" placeholder="변경할 때만 입력하세요">
                        </div>
                        <div class="field">
                            <label class="field__label">새 비밀번호 확인</label>
                            <input type="password" id="pwdConfirm" class="input" placeholder="한 번 더 입력하세요">
                        </div>
                        <div class="btn-row" style="margin-top:8px">
                            <button type="submit" class="btn btn--primary btn--lg">저장하기</button>
                            <a href="${pageContext.request.contextPath}/fixer/mypage" class="btn btn--ghost btn--lg">취소</a>
                        </div>
                    </div>
                </form>

            </div>
        </div>
    </div>
</main>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
<script src="${pageContext.request.contextPath}/js/common.js"></script>
</body>
</html>