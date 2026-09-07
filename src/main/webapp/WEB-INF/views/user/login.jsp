<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>로그인 | 수릿 Surit</title>
    <link rel="stylesheet" href="/css/style.css">
    <link rel="stylesheet" href="/css/pages.css">
</head>
<body>

<header class="site-header">
    <div class="site-header__inner">
        <a href="/" class="logo">
            <div class="logo__mark">
                <svg viewBox="0 0 24 24"><path d="M8 12h8M8 8h8M8 16h5"/></svg>
            </div>
            <span class="logo__text">수릿</span>
        </a>
    </div>
</header>

<main>

<div class="auth">

    <div class="auth__side">
        <h2>고장 났을 때<br>가장 빠른 방법.</h2>
        <p>증상만 남기면 가까운 수리 기사님이 직접 신청합니다.<br>
           검증된 기사, 투명한 견적, 현장 직접 결제.</p>
        <ul>
            <li>
                <svg viewBox="0 0 24 24"><path d="M20 6L9 17l-5-5"/></svg>
                평균 32분 안에 방문
            </li>
            <li>
                <svg viewBox="0 0 24 24"><path d="M20 6L9 17l-5-5"/></svg>
                등록 기사 860명
            </li>
            <li>
                <svg viewBox="0 0 24 24"><path d="M20 6L9 17l-5-5"/></svg>
                누적 수리 12,400건
            </li>
        </ul>
    </div>

    <div class="auth__form">
        <div class="auth__form-inner">
            <h1>다시 만나서 반가워요</h1>
            <p>수릿 계정으로 로그인하고 접수를 이어가세요.</p>

            <c:if test="${ error != null }">
                <div class="note note--warn">
                    <svg viewBox="0 0 24 24"><path d="M12 9v4M12 17h.01M10.29 3.86l-8.18 14.14A2 2 0 0 0 3.82 21h16.36a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/></svg>
                    <p>${ error }</p>
                </div>
            </c:if>

            <form id="login-form" action="/user/login" method="post">

                <c:if test="${ param.redirectURL != null }">
                    <input type="hidden" name="redirectURL" value="${ param.redirectURL }">
                </c:if>

                <div class="field">
                    <label class="field__label" for="login-id">아이디</label>
                    <input type="text" id="login-id" name="userId" class="input"
                        placeholder="아이디를 입력하세요" required autocomplete="off">
                </div>

                <div class="field">
                    <label class="field__label" for="login-pwd">비밀번호</label>
                    <input type="password" id="login-pwd" name="userPwd" class="input"
                        placeholder="비밀번호를 입력하세요" required>
                </div>

                <div style="display:flex;align-items:center;justify-content:space-between;margin-bottom:28px">
                    <label class="check">
                        <input type="checkbox" checked>
                        로그인 상태 유지
                    </label>
                    <a class="muted" href="#" style="font-size:15px">비밀번호를 잊으셨나요?</a>
                </div>

                <button type="submit" class="btn btn--primary btn--xl btn--block">로그인</button>
            </form>

            <div class="auth__bottom">
                아직 회원이 아니신가요?
                <a href="/user/sign">회원가입</a>
            </div>
        </div>
    </div>

</div>

</main>

<footer class="site-footer">
    <div class="site-footer__brand">
        <span class="site-footer__mark">
            <svg viewBox="0 0 24 24"><path d="M8 12h8M8 8h8M8 16h5"/></svg>
        </span>
        <span>수릿 Surit</span>
    </div>
    <address>
        (주)수릿 | 대표 홍길동 | 사업자등록번호 000-00-00000<br>
        서울특별시 강남구 테헤란로 000 | 통신판매업신고 2026-서울강남-0000<br>
        고객센터 1600-0000 (평일 09:00~18:00) | help@surit.kr
    </address>
    <div class="site-footer__bottom">
        <span>&copy; 2026 Surit. All rights reserved.</span>
        <span><a href="/support">고객센터</a> &middot; <a href="#">이용약관</a> &middot; <a href="#">개인정보처리방침</a></span>
    </div>
</footer>

<script src="/js/common.js"></script>
</body>
</html>