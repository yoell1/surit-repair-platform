<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>

<svg width="0" height="0" style="position:absolute" aria-hidden="true"><defs><symbol id="i-tools" viewBox="0 0 24 24"><path d="M14.7 6.3a1 1 0 0 0 0 1.4l1.6 1.6a1 1 0 0 0 1.4 0l3.77-3.77a6 6 0 0 1-7.94 7.94l-6.91 6.91a2.12 2.12 0 0 1-3-3l6.91-6.91a6 6 0 0 1 7.94-7.94z"/></symbol><symbol id="i-lock" viewBox="0 0 24 24"><rect x="5" y="10" width="14" height="10" rx="2"/><path d="M8 10V7a4 4 0 0 1 8 0v3"/><circle cx="12" cy="15" r="1.4" fill="currentColor" stroke="none"/></symbol><symbol id="i-fridge" viewBox="0 0 24 24"><rect x="6" y="3" width="12" height="18" rx="2"/><path d="M6 10h12"/><path d="M9 6v2"/><path d="M9 13v2.5"/></symbol><symbol id="i-pc" viewBox="0 0 24 24"><rect x="3" y="5" width="18" height="12" rx="2"/><path d="M9 21h6"/><path d="M12 17v4"/></symbol><symbol id="i-drop" viewBox="0 0 24 24"><path d="M12 3c4 4.5 6 7 6 9a6 6 0 0 1-12 0c0-2 2-4.5 6-9z"/></symbol><symbol id="i-bolt" viewBox="0 0 24 24"><path d="M13 2 5 14h6l-1 8 8-12h-6l1-8z"/></symbol><symbol id="i-chat" viewBox="0 0 24 24"><path d="M4 6.5A2.5 2.5 0 0 1 6.5 4h11A2.5 2.5 0 0 1 20 6.5v8a2.5 2.5 0 0 1-2.5 2.5H9.5L4 21.5z"/></symbol><symbol id="i-user" viewBox="0 0 24 24"><circle cx="12" cy="8" r="4"/><path d="M4.5 20.5a7.5 7.5 0 0 1 15 0"/></symbol><symbol id="i-wrench" viewBox="0 0 24 24"><path d="M14.7 6.3a1 1 0 0 0 0 1.4l1.6 1.6a1 1 0 0 0 1.4 0l3.77-3.77a6 6 0 0 1-7.94 7.94l-6.91 6.91a2.12 2.12 0 0 1-3-3l6.91-6.91a6 6 0 0 1 7.94-7.94z"/></symbol><symbol id="i-star" viewBox="0 0 24 24"><path d="M12 2.6l2.9 6 6.6.9-4.8 4.6 1.2 6.6L12 17.6 6.1 20.7l1.2-6.6L2.5 9.5l6.6-.9z"/></symbol></defs></svg>

<section class="hero">
    <div class="container">
        <span class="hero__eyebrow"><i></i>평균 32분 안에 기사님이 방문합니다</span>
        <h1>고장 났을 때<br><em>가장 빠른 방법.</em></h1>
        <p>증상만 남기면 가까운 수리 기사님이 직접 신청합니다.</p>
        <div class="hero__cta">
            <a class="btn btn--primary btn--xl" href="/request">
                <svg class="ico"><use href="#i-wrench"/></svg>수리 접수하기</a>
            <div class="hero__stat">
                <span>누적 수리 <b>12,400건</b></span><i></i>
                <span>등록 기사 <b>860명</b></span><i></i>
                <span>평균 별점 <b>4.9</b></span>
            </div>
        </div>
    </div>
</section>

<div class="container">
    <nav class="cats">
        <a href="/request?cat=lock"><span class="tile t-lock"><svg><use href="#i-lock"/></svg></span><span>도어락 · 잠금</span></a>
        <a href="/request?cat=fridge"><span class="tile t-frid"><svg><use href="#i-fridge"/></svg></span><span>냉장고 · 가전</span></a>
        <a href="/request?cat=pc"><span class="tile t-pc"><svg><use href="#i-pc"/></svg></span><span>PC · 노트북</span></a>
        <a href="/request?cat=pipe"><span class="tile t-drop"><svg><use href="#i-drop"/></svg></span><span>배관 · 누수</span></a>
        <a href="/request?cat=elec"><span class="tile t-bolt"><svg><use href="#i-bolt"/></svg></span><span>전기 · 조명</span></a>
        <a href="/request?cat=etc"><span class="tile t-tool"><svg><use href="#i-tools"/></svg></span><span>그 외 수리</span></a>
    </nav>
</div>

<section class="section">
    <div class="container">
        <div class="sec-head center">
            <h2>수릿은 이렇게 진행돼요</h2>
            <p>접수부터 수리까지 3단계면 끝납니다</p>
        </div>
        <div class="steps3">
            <div class="card">
                <span class="num">1</span>
                <span class="tile t-blue"><svg><use href="#i-chat"/></svg></span>
                <h3>증상만 남기세요</h3>
                <p>무엇이 어떻게 고장났는지 적고 사진을 올리면 접수가 끝납니다.</p>
            </div>
            <div class="card">
                <span class="num">2</span>
                <span class="tile t-blue"><svg><use href="#i-user"/></svg></span>
                <h3>기사님이 신청해요</h3>
                <p>주변 기사님이 직접 신청합니다. 보고 마음에 드는 분을 고르세요.</p>
            </div>
            <div class="card">
                <span class="num">3</span>
                <span class="tile t-blue"><svg><use href="#i-wrench"/></svg></span>
                <h3>방문해서 고쳐요</h3>
                <p>약속한 시간에 방문해 수리하고, 비용은 그 자리에서 직접 냅니다.</p>
            </div>
        </div>
    </div>
</section>

<section class="section section--gray">
    <div class="container">
        <div class="sec-head center">
            <h2>고객님이 남긴 후기</h2>
            <p>수릿이 직접 확인한 실제 수리 후기입니다</p>
        </div>
        <div class="reviews">
            <div class="review">
                <div class="review__top">
                    <span class="stars">
                        <svg><use href="#i-star"/></svg><svg><use href="#i-star"/></svg><svg><use href="#i-star"/></svg><svg><use href="#i-star"/></svg><svg><use href="#i-star"/></svg>
                    </span>
                    <span class="badge badge--primary">도어락 · 잠금</span>
                </div>
                <p class="review__text">밤 11시에 접수했는데 30분 만에 오셨어요. 문을 부수지 않고 열어주셔서 정말 감사합니다.</p>
                <div class="review__foot">
                    <span class="review__who">김＊연 고객님</span>
                    <span>2026.08.12</span>
                </div>
            </div>
            <div class="review">
                <div class="review__top">
                    <span class="stars">
                        <svg><use href="#i-star"/></svg><svg><use href="#i-star"/></svg><svg><use href="#i-star"/></svg><svg><use href="#i-star"/></svg><svg><use href="#i-star"/></svg>
                    </span>
                    <span class="badge badge--primary">냉장고 · 가전</span>
                </div>
                <p class="review__text">냉장실만 시원하지 않았는데 원인을 바로 찾아주셨어요. 부품 값도 미리 알려주셔서 믿음이 갔습니다.</p>
                <div class="review__foot">
                    <span class="review__who">이＊훈 고객님</span>
                    <span>2026.08.10</span>
                </div>
            </div>
            <div class="review">
                <div class="review__top">
                    <span class="stars">
                        <svg><use href="#i-star"/></svg><svg><use href="#i-star"/></svg><svg><use href="#i-star"/></svg><svg><use href="#i-star"/></svg><svg><use href="#i-star"/></svg>
                    </span>
                    <span class="badge badge--primary">PC · 노트북</span>
                </div>
                <p class="review__text">부팅이 안 되던 노트북을 살렸습니다. 자료도 그대로 남았고 설명을 천천히 해주셔서 좋았어요.</p>
                <div class="review__foot">
                    <span class="review__who">박＊아 고객님</span>
                    <span>2026.08.09</span>
                </div>
            </div>
        </div>
    </div>
</section>

<section class="section--tight">
    <div class="container">
        <div class="join-banner">
            <c:choose>
                <c:when test="${ not empty sessionScope.loginMember }">
                    <div>
                        <h2>오늘도 고장 났나요?</h2>
                        <p>지금 바로 접수하고 가까운 기사님을 만나보세요.</p>
                    </div>
                    <a class="btn btn--dark btn--lg" href="/request">수리 접수하기</a>
                </c:when>
                <c:otherwise>
                    <div>
                        <h2>고장은 갑자기, 수리는 수릿으로.</h2>
                        <p>회원가입하고 지금 바로 접수해 보세요.</p>
                    </div>
                    <a class="btn btn--dark btn--lg" href="/user/sign">회원가입하기</a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</section>
<script src="${pageContext.request.contextPath}/js/common.js"></script>
<jsp:include page="/WEB-INF/views/common/footer.jsp"/>