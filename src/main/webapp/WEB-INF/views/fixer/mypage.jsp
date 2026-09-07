<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!doctype html>
<html lang="ko">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>수리 정보 관리 | 수릿 Surit</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/pages.css">
</head>
<body>

<svg width="0" height="0" style="position:absolute" aria-hidden="true"><defs><symbol id="i-tools" viewBox="0 0 24 24"><path d="M14.7 6.3a1 1 0 0 0 0 1.4l1.6 1.6a1 1 0 0 0 1.4 0l3.77-3.77a6 6 0 0 1-7.94 7.94l-6.91 6.91a2.12 2.12 0 0 1-3-3l6.91-6.91a6 6 0 0 1 7.94-7.94z"/></symbol><symbol id="i-refresh" viewBox="0 0 24 24"><path d="M20 11a8 8 0 0 0-13.7-5.3L3 9"/><path d="M4 13a8 8 0 0 0 13.7 5.3L21 15"/><path d="M3 4v5h5"/><path d="M21 20v-5h-5"/></symbol><symbol id="i-user" viewBox="0 0 24 24"><circle cx="12" cy="8" r="4"/><path d="M4.5 20.5a7.5 7.5 0 0 1 15 0"/></symbol><symbol id="i-list" viewBox="0 0 24 24"><path d="M8 6h13"/><path d="M8 12h13"/><path d="M8 18h13"/><path d="M3.5 6h.01"/><path d="M3.5 12h.01"/><path d="M3.5 18h.01"/></symbol><symbol id="i-home" viewBox="0 0 24 24"><path d="M4 11.5 12 4l8 7.5"/><path d="M6.5 10.5V20h11v-9.5"/></symbol><symbol id="i-wrench" viewBox="0 0 24 24"><path d="M14.7 6.3a1 1 0 0 0 0 1.4l1.6 1.6a1 1 0 0 0 1.4 0l3.77-3.77a6 6 0 0 1-7.94 7.94l-6.91 6.91a2.12 2.12 0 0 1-3-3l6.91-6.91a6 6 0 0 1 7.94-7.94z"/></symbol><symbol id="i-shield" viewBox="0 0 24 24"><path d="M12 3l7 3v5.5c0 4.4-3 8-7 9.5-4-1.5-7-5.1-7-9.5V6z"/><path d="M9.2 12l2 2 3.6-3.8"/></symbol><symbol id="i-chat" viewBox="0 0 24 24"><path d="M4 6.5A2.5 2.5 0 0 1 6.5 4h11A2.5 2.5 0 0 1 20 6.5v8a2.5 2.5 0 0 1-2.5 2.5H9.5L4 21.5z"/></symbol><symbol id="i-pin" viewBox="0 0 24 24"><path d="M12 21s7-6.2 7-11a7 7 0 1 0-14 0c0 4.8 7 11 7 11z"/><circle cx="12" cy="10" r="2.6"/></symbol></defs></svg>

<jsp:include page="/WEB-INF/views/common/header.jsp" />

<main>
    <div class="container">
        <div class="page-head page-head--plain">
            <h1>마이페이지</h1>
        </div>

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
                <a href="${pageContext.request.contextPath}/fixer/mypage" class="is-active"><svg class="ico"><use href="#i-wrench"/></svg>수리 정보 관리</a>
                <a href="${pageContext.request.contextPath}/fixer/mypage/address"><svg class="ico"><use href="#i-home"/></svg>주소 관리</a>
                <a href="${pageContext.request.contextPath}/fixer/mypage/profile"><svg class="ico"><use href="#i-user"/></svg>내 정보 수정</a>
            </nav>

            <div>
                <div class="sec-head sec-head--row" style="margin-bottom:20px">
                    <div>
                        <h2>수리 정보 관리</h2>
                        <p>여기서 고른 카테고리와 지역의 접수만 <b>접수 찾기</b>에 올라옵니다.</p>
                    </div>
                </div>

                <form action="${pageContext.request.contextPath}/fixer/mypage/categories" method="post" class="card" style="margin-bottom: 24px;">
                    <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:16px;">
                        <h3 style="font-size:18px; margin:0;">수리 가능 카테고리</h3>
                        <span style="color:var(--g-500); font-size:14px;"><span id="catCount">0</span>개 선택됨</span>
                    </div>

                    <div class="chip-row" style="margin-bottom:16px; gap:8px;">
                        <c:forEach var="cat" items="${categoryList}">
                            <label style="cursor: pointer;">
                                <input type="checkbox" name="categories" value="${cat.codeId}" class="chip-checkbox cat-checkbox" onchange="countCatChecked()" <c:if test="${fn:contains(myCategories, cat.codeId)}">checked</c:if> style="display:none;">
                                <span class="chip-label"><c:out value="${cat.codeName}"/></span>
                            </label>
                        </c:forEach>
                    </div>
                    <p style="color:var(--g-500); font-size:13px; margin-bottom:20px;">선택을 해제하면 해당 품목의 새 접수 알림이 오지 않습니다.</p>
                    <button type="submit" class="btn btn--primary">카테고리 저장</button>
                </form>

                <form action="${pageContext.request.contextPath}/fixer/mypage/regions" method="post" id="regionForm" class="card">
                    <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:16px;">
                        <h3 style="font-size:18px; margin:0;">활동 가능 지역</h3>
                        <span style="color:var(--g-500); font-size:14px;"><span id="regionCountUI">0</span> / 5</span>
                    </div>
                    <p style="font-size:15px; font-weight:500; margin-bottom:12px;">선택 가능한 지역 (최대 5개)</p>

                    <div class="chip-row" style="margin-bottom:20px; gap:8px;">
                        <c:forEach var="region" items="${regionList}">
                            <label style="cursor: pointer;">
                                <input type="checkbox" name="regions" value="${region.codeId}" class="chip-checkbox region-checkbox" onchange="countRegionChecked(this)" <c:if test="${fn:contains(myRegions, region.codeId)}">checked</c:if> style="display:none;">
                                <span class="chip-label"><c:out value="${region.codeName}"/></span>
                            </label>
                        </c:forEach>
                    </div>
                    <div class="note note--gray" style="margin-bottom:20px; padding:12px; background:#f9fafb; border-radius:8px; font-size:13.5px; color:var(--g-600);">
                        <svg class="ico" style="margin-right:4px;"><use href="#i-pin"/></svg><span>등록한 지역 안에서 올라온 접수만 보입니다. 지역을 넓힐수록 받는 접수가 늘어납니다.</span>
                    </div>
                    <button type="submit" class="btn btn--primary">지역 저장</button>
                </form>
            </div>
        </div>
    </div>
</main>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />

<style>
    .chip-label {
        display: inline-flex; align-items: center; justify-content: center;
        padding: 8px 16px; border-radius: 20px; border: 1px solid var(--g-200);
        background: #fff; color: var(--g-600); font-size: 14px; transition: all 0.2s; user-select: none;
    }
    .cat-checkbox:checked + .chip-label,
    .region-checkbox:checked + .chip-label {
        border-color: #3b82f6; color: #3b82f6; font-weight: 500; background-color: #eff6ff;
    }
</style>

<script>
    function countCatChecked() {
        const checkboxes = document.querySelectorAll('.cat-checkbox:checked');
        document.getElementById('catCount').innerText = checkboxes.length;
    }
    function countRegionChecked(target) {
        const checkboxes = document.querySelectorAll('.region-checkbox:checked');
        if (checkboxes.length > 5) {
            alert('활동 지역은 최대 5개까지만 선택할 수 있습니다.');
            target.checked = false;
            return;
        }
        document.getElementById('regionCountUI').innerText = checkboxes.length;
    }
    document.addEventListener("DOMContentLoaded", function() {
        countCatChecked();
        document.getElementById('regionCountUI').innerText = document.querySelectorAll('.region-checkbox:checked').length;
    });
</script>
<script src="${pageContext.request.contextPath}/js/common.js"></script>
</body>
</html>