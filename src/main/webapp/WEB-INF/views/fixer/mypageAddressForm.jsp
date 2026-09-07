<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!doctype html>
<html lang="ko">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>주소 추가/수정 | 수릿 Surit</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/pages.css">
</head>
<body>

<svg width="0" height="0" style="position:absolute" aria-hidden="true"><defs><symbol id="i-tools" viewBox="0 0 24 24"><path d="M14.7 6.3a1 1 0 0 0 0 1.4l1.6 1.6a1 1 0 0 0 1.4 0l3.77-3.77a6 6 0 0 1-7.94 7.94l-6.91 6.91a2.12 2.12 0 0 1-3-3l6.91-6.91a6 6 0 0 1 7.94-7.94z"/></symbol><symbol id="i-refresh" viewBox="0 0 24 24"><path d="M20 11a8 8 0 0 0-13.7-5.3L3 9"/><path d="M4 13a8 8 0 0 0 13.7 5.3L21 15"/><path d="M3 4v5h5"/><path d="M21 20v-5h-5"/></symbol><symbol id="i-user" viewBox="0 0 24 24"><circle cx="12" cy="8" r="4"/><path d="M4.5 20.5a7.5 7.5 0 0 1 15 0"/></symbol><symbol id="i-list" viewBox="0 0 24 24"><path d="M8 6h13"/><path d="M8 12h13"/><path d="M8 18h13"/><path d="M3.5 6h.01"/><path d="M3.5 12h.01"/><path d="M3.5 18h.01"/></symbol><symbol id="i-home" viewBox="0 0 24 24"><path d="M4 11.5 12 4l8 7.5"/><path d="M6.5 10.5V20h11v-9.5"/></symbol><symbol id="i-wrench" viewBox="0 0 24 24"><path d="M14.7 6.3a1 1 0 0 0 0 1.4l1.6 1.6a1 1 0 0 0 1.4 0l3.77-3.77a6 6 0 0 1-7.94 7.94l-6.91 6.91a2.12 2.12 0 0 1-3-3l6.91-6.91a6 6 0 0 1 7.94-7.94z"/></symbol><symbol id="i-shield" viewBox="0 0 24 24"><path d="M12 3l7 3v5.5c0 4.4-3 8-7 9.5-4-1.5-7-5.1-7-9.5V6z"/><path d="M9.2 12l2 2 3.6-3.8"/></symbol><symbol id="i-chat" viewBox="0 0 24 24"><path d="M4 6.5A2.5 2.5 0 0 1 6.5 4h11A2.5 2.5 0 0 1 20 6.5v8a2.5 2.5 0 0 1-2.5 2.5H9.5L4 21.5z"/></symbol><symbol id="i-search" viewBox="0 0 24 24"><circle cx="11" cy="11" r="7"/><path d="M16.2 16.2 21 21"/></symbol></defs></svg>

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
                <a href="${pageContext.request.contextPath}/support"><svg class="ico"><use href="#i-chat"/></svg>고객센터</a>
            </nav>

            <div>
                <div class="sec-head sec-head--row" style="margin-bottom:24px">
                    <div>
                        <h2>주소 추가</h2>
                        <p>출발 위치 계산에 쓰이는 내 주소입니다. 최대 3개까지 등록할 수 있습니다.</p>
                    </div>
                </div>

                <form action="${pageContext.request.contextPath}/fixer/mypage/address/save" method="post" class="card">
                    <input type="hidden" name="id" value="${address.id}">

                    <div class="field">
                        <label class="field__label">주소 별칭<span class="req">*</span></label>
                        <input type="text" id="aliasInput" name="alias" class="input" value="${address.alias}" placeholder="예) 집, 작업실" required>
                        <div class="chip-row" style="margin-top:12px">
                            <button type="button" class="chip" onclick="setAlias('집')">집</button>
                            <button type="button" class="chip" onclick="setAlias('작업실')">작업실</button>
                            <button type="button" class="chip" onclick="setAlias('사무실')">사무실</button>
                        </div>
                    </div>

                    <div class="field">
                        <label class="field__label">우편번호<span class="req">*</span></label>
                        <div style="display:flex;gap:12px">
                            <input type="text" id="zipcode" name="zipcode" class="input" value="${address.zipcode}" placeholder="우편번호" readonly required>
                            <button type="button" class="btn btn--dark" style="flex:0 0 auto">
                                <svg class="ico"><use href="#i-search"/></svg>주소 검색
                            </button>
                        </div>
                    </div>

                    <div class="field">
                        <label class="field__label">기본주소<span class="req">*</span></label>
                        <input type="text" id="baseAddress" name="baseAddress" class="input" value="${address.baseAddress}" placeholder="주소 검색으로 입력됩니다" readonly required style="background:var(--g-50)">
                    </div>

                    <div class="field">
                        <label class="field__label">상세주소</label>
                        <input type="text" id="detailAddress" name="detailAddress" class="input" value="${address.detailAddress}" placeholder="동 · 호수 등 나머지 주소를 입력하세요">
                    </div>

                    <label class="check" style="margin-bottom:26px">
                        <input type="checkbox" name="isDefault" value="Y" <c:if test="${address.isDefault == 'Y'}">checked</c:if>>이 주소를 기본 주소로 설정합니다
                    </label>

                    <div class="btn-row">
                        <button type="submit" class="btn btn--primary btn--lg">저장하기</button>
                        <a class="btn btn--ghost btn--lg" href="${pageContext.request.contextPath}/fixer/mypage/address">취소</a>
                    </div>
                </form>

                <div class="note note--gray" style="margin-top:22px">
                    <svg class=""><use href="#i-shield"/></svg>
                    <span>기사님의 주소는 고객에게 공개되지 않습니다. 접수와의 거리를 계산할 때만 사용됩니다.</span>
                </div>
            </div>
        </div>
    </div>
</main>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />

<script>
    function setAlias(value) {
        document.getElementById('aliasInput').value = value;
    }
</script>
<script src="${pageContext.request.contextPath}/js/common.js"></script>
</body>
</html>