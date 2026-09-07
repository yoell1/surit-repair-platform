<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>

<div class="auth">

    <div class="auth__side">
        <h2>수릿과 함께<br>믿을 수 있는 수리를 시작하세요</h2>
        <p>검증된 기사님과 투명한 견적으로<br>안심하고 맡길 수 있어요.</p>
        <ul>
            <li><svg viewBox="0 0 24 24"><path d="M20 6L9 17l-5-5"/></svg>검증된 기사 매칭</li>
            <li><svg viewBox="0 0 24 24"><path d="M20 6L9 17l-5-5"/></svg>투명한 견적 비교</li>
            <li><svg viewBox="0 0 24 24"><path d="M20 6L9 17l-5-5"/></svg>실시간 채팅 상담</li>
        </ul>
    </div>

    <div class="auth__form">
        <div class="auth__form-inner">
            <h1>회원가입</h1>
            <p>수릿 계정을 만들고 서비스를 이용해보세요</p>

            <c:if test="${ error != null }">
                <div class="note note--warn">
                    <svg viewBox="0 0 24 24"><path d="M12 9v4M12 17h.01M10.29 3.86l-8.18 14.14A2 2 0 0 0 3.82 21h16.36a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/></svg>
                    <p>${ error }</p>
                </div>
            </c:if>

            <form id="sign-form" action="/user/sign" method="post">

                <div class="form-sec">
                    <div class="form-sec__head">
                        <div class="form-sec__no">1</div>
                        <div>
                            <div class="form-sec__title">회원 정보</div>
                            <div class="form-sec__desc">로그인에 사용할 정보를 입력해주세요</div>
                        </div>
                    </div>

                    <div class="field">
                        <label class="field__label">회원 유형<span class="req">*</span></label>
                        <div class="opt-grid">
                            <button type="button" class="opt is-on" data-select="role" data-role="USER">
                                <span class="opt__radio"></span>
                                <span class="opt__body">
                                    <span class="opt__title">일반회원</span>
                                    <span class="opt__desc">수리를 맡길래요</span>
                                </span>
                            </button>
                            <button type="button" class="opt" data-select="role" data-role="FIXER">
                                <span class="opt__radio"></span>
                                <span class="opt__body">
                                    <span class="opt__title">수리기사</span>
                                    <span class="opt__desc">수리를 맡을래요</span>
                                </span>
                            </button>
                        </div>
                        <input type="hidden" id="user-role" name="userRole" value="USER">
                        <div class="note note--warn" style="margin-top:14px;font-size:15px;padding:14px 18px">
                            <svg class=""><use href="#i-alert"/></svg><span>수리 기사는 <b>가입 후 [기사 인증] 화면에서 자격증을 제출</b>해야 활동할 수 있습니다. 관리자 확인까지 1~2일 걸리며, 승인 전에는 견적을 보낼 수 없습니다.</span>
                        </div>
                    </div>

                    <div class="field">
                        <label class="field__label" for="user-id">아이디<span class="req">*</span></label>
                        <div class="field-row">
                            <input type="text" id="user-id" name="userId" class="input" required autocomplete="off">
                            <button type="button" id="check-id-btn" class="btn btn--ghost">중복확인</button>
                        </div>
                        <p id="check-id-result" class="field__help" aria-live="polite"></p>
                    </div>

                    <div class="field">
                        <label class="field__label" for="user-pwd">비밀번호<span class="req">*</span></label>
                        <input type="password" id="user-pwd" name="password" class="input" required>
                    </div>

                    <div class="field">
                        <label class="field__label" for="user-pwd-confirm">비밀번호 확인<span class="req">*</span></label>
                        <input type="password" id="user-pwd-confirm" class="input" required>
                        <p id="check-pwd-result" class="field__help" aria-live="polite"></p>
                    </div>

                    <div class="field">
                        <label class="field__label" for="user-name">이름<span class="req">*</span></label>
                        <input type="text" id="user-name" name="name" class="input" required>
                        <p id="check-name-result" class="field__help" aria-live="polite"></p>
                    </div>

                    <div class="field-row">
                        <div class="field">
                            <label class="field__label" for="phone">전화번호<span class="req">*</span></label>
                            <input type="text" id="phone" name="phone" class="input" placeholder="01012345678" maxlength="11" autocomplete="off" required>
                            <p id="check-phone-result" class="field__help" aria-live="polite"></p>
                        </div>
                        <div class="field">
                            <label class="field__label" for="user-email">이메일<span class="req">*</span></label>
                            <input type="email" id="user-email" name="email" class="input" required autocomplete="off">
                            <p id="check-email-ressult" class="field__help" aria-live="polite"></p>
                        </div>
                    </div>
                </div>

                <div class="form-sec">
                    <div class="form-sec__head">
                        <div class="form-sec__no">2</div>
                        <div>
                            <div class="form-sec__title">기본 주소</div>
                            <div class="form-sec__desc">수리 접수 시 방문지로 사용할 주소예요 (나중에 추가·변경 가능)</div>
                        </div>
                    </div>

                    <div class="field">
                        <label class="field__label">지역 선택<span class="req">*</span></label>
                        <button type="button" class="btn btn--ghost btn--block" id="region-toggle-btn" onclick="toggleRegionSelect()">
                            <span id="region-selected-label">지역을 선택해주세요</span>
                            <svg class="ico" style="margin-left:auto"><use href="#i-chevd"/></svg>
                        </button>
                        <div id="region-select-panel" style="display:none;margin-top:10px;padding:16px;border:1.5px solid var(--g-300);border-radius:var(--r-md);max-height:260px;overflow-y:auto">
                            <c:forEach var="region" items="${regionList}">
                                <label class="check" style="display:block;margin-bottom:12px">
                                    <input type="radio" name="regionRadio" value="${region.codeId}" data-region-name="${region.codeName}">
                                    <c:out value="${region.codeName}"/>
                                </label>
                            </c:forEach>
                        </div>
                    </div>

                    <div class="field">
                        <label class="field__label" for="address-detail">상세주소<span class="req">*</span></label>
                        <input type="text" id="address-detail" name="addressDetail" class="input" placeholder="예: 테헤란로 123, 101동 1502호" autocomplete="off" required>
                    </div>

                    <input type="hidden" id="address" name="address">

                    <div class="field">
                        <input type="hidden" id="is-default" name="isDefault" value="Y">
                        <label class="check" style="display:none;">
                            <input type="checkbox" id="is-default-checkbox" checked>기본 주소로 설정
                        </label>
                    </div>
                </div>

                <div class="card card--sm" style="box-shadow:none;background:var(--g-50);margin-bottom:26px">
                    <label class="check" style="font-weight:700;font-size:17px">
                        <input type="checkbox" id="agree-all" checked>전체 동의
                    </label>
                    <hr style="border:0;border-top:1px solid var(--g-200);margin:16px 0">
                    <div style="display:flex;flex-direction:column;gap:12px">
                        <label class="check"><input type="checkbox" class="agree-item" checked required>[필수] 만 14세 이상입니다</label>
                        <label class="check"><input type="checkbox" class="agree-item" checked required>[필수] 서비스 이용약관 동의</label>
                        <label class="check"><input type="checkbox" class="agree-item" checked required>[필수] 개인정보 수집 · 이용 동의</label>
                    </div>
                </div>

                <button type="submit" class="btn btn--primary btn--block btn--xl">가입하고 시작하기</button>
                <div class="field__help" style="text-align:center;margin-top:12px">
                    기사로 가입하셨다면 이어서 <b style="color:var(--p-600);">기사 인증</b> 화면으로 이동합니다.
                </div>
            </form>

            <div class="auth__bottom">
                이미 계정이 있으신가요?
                <a href="/user/login">로그인</a>
            </div>
        </div>
    </div>

</div>

<script src="/js/common.js"></script>
<script>
    // 전체 동의 체크박스 로직 연동
    const agreeAll = document.getElementById('agree-all');
    const agreeItems = document.querySelectorAll('.agree-item');

    agreeAll.addEventListener('change', (e) => {
        agreeItems.forEach(item => item.checked = e.target.checked);
    });

    agreeItems.forEach(item => {
        item.addEventListener('change', () => {
            agreeAll.checked = Array.from(agreeItems).every(i => i.checked);
        });
    });
</script>

<jsp:include page="/WEB-INF/views/common/footer.jsp"/>