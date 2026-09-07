<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
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

<%-- header.jsp 에 없을 수 있는 아이콘만 추가로 정의 (중복 정의돼도 문제없음) --%>
<svg width="0" height="0" style="position:absolute" aria-hidden="true">
<defs>
<symbol id="i-edit" viewBox="0 0 24 24"><path d="M4 20h4L19 9l-4-4L4 16z"/><path d="M14.5 5.5l4 4"/></symbol>
<symbol id="i-trash" viewBox="0 0 24 24"><path d="M4 7h16"/><path d="M9 7V5h6v2"/><path d="M6 7l1 13h10l1-13"/></symbol>
<symbol id="i-plus" viewBox="0 0 24 24"><path d="M12 5v14"/><path d="M5 12h14"/></symbol>
<symbol id="i-refresh" viewBox="0 0 24 24"><path d="M20 11a8 8 0 0 0-13.7-5.3L3 9"/><path d="M4 13a8 8 0 0 0 13.7 5.3L21 15"/><path d="M3 4v5h5"/><path d="M21 20v-5h-5"/></symbol>
<symbol id="i-chevd" viewBox="0 0 24 24"><path d="M6 9.5 12 15.5 18 9.5"/></symbol>
</defs>
</svg>

<jsp:include page="/WEB-INF/views/common/header.jsp" />

<main>
<div class="container">

  <div class="page-head page-head--plain"><h1>주소 관리</h1></div>

  <div class="profile-box">
    <span class="avatar avatar--xl"><svg><use href="#i-user"/></svg></span>
    <div>
      <div class="profile-box__name"><c:out value="${user.name}"/> 고객님</div>
      <div class="profile-box__mail"><c:out value="${user.email}"/></div>
    </div>
    <div class="btn-row">
      <a class="btn btn--ghost" href="${pageContext.request.contextPath}/user/mypage/profile">내 정보 수정</a>
      <a class="btn btn--dark" href="${pageContext.request.contextPath}/fixer/verify">
        <svg class="ico"><use href="#i-refresh"/></svg>기사로 전환
      </a>
    </div>
  </div>

  <div class="with-side">
    <nav class="side-nav">
      <a href="${pageContext.request.contextPath}/user/mypage">
        <svg class="ico"><use href="#i-list"/></svg>나의 접수
      </a>
      <a href="${pageContext.request.contextPath}/user/mypage/address" class="is-active">
        <svg class="ico"><use href="#i-home"/></svg>주소 관리
      </a>
      <a href="${pageContext.request.contextPath}/user/mypage/profile">
        <svg class="ico"><use href="#i-user"/></svg>내 정보 수정
      </a>
      <a href="${pageContext.request.contextPath}/user/mypage/reviews">
        <svg class="ico"><use href="#i-star"/></svg>내가 쓴 리뷰
      </a>
      <a href="${pageContext.request.contextPath}/user/mypage/support">
        <svg class="ico"><use href="#i-chat"/></svg>고객센터
      </a>
    </nav>

    <div>
      <div class="sec-head sec-head--row" style="margin-bottom:24px">
        <div>
          <h2>주소 관리</h2>
          <p>주소는 최대 3개까지 등록할 수 있습니다. (${fn:length(addressList)} / 3)</p>
        </div>
      </div>

      <c:choose>
        <c:when test="${empty addressList}">
          <div class="empty">
            <svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><use href="#i-home"/></svg>
            <p>등록된 주소가 없습니다.</p>
          </div>
        </c:when>
        <c:otherwise>
          <c:forEach var="addr" items="${addressList}">

            <%-- 평소엔 보이는 조회 화면 --%>
            <div class="list-card" id="address-view-${addr.addressId}">
              <span class="tile tile--sm t-blue"><svg><use href="#i-home"/></svg></span>
              <div class="list-card__body">
                <div style="display:flex;align-items:center;gap:10px">
                  <b style="font-size:19px">
                    <c:choose>
                      <c:when test="${not empty addr.addressName}"><c:out value="${addr.addressName}"/></c:when>
                      <c:otherwise><c:out value="${addr.address}"/></c:otherwise>
                    </c:choose>
                  </b>
                  <c:if test="${addr.isDefault == 'Y'}">
                    <span class="badge badge--primary">기본 주소</span>
                  </c:if>
                </div>
                <div class="list-card__meta" style="margin-top:6px">
                  <c:if test="${not empty addr.addressName}">
                    <c:out value="${addr.address}"/><br>
                  </c:if>
                  <c:out value="${addr.addressDetail}"/>
                </div>
              </div>
              <div class="btn-row">
                <button type="button" class="btn btn--ghost btn--sm" onclick="toggleAddressEdit(${addr.addressId})">
                  <svg class="ico"><use href="#i-edit"/></svg>수정
                </button>
                <form method="post" action="${pageContext.request.contextPath}/user/mypage/address/${addr.addressId}/delete" style="display:inline">
                  <button type="submit" class="btn btn--danger btn--sm">
                    <svg class="ico"><use href="#i-trash"/></svg>삭제
                  </button>
                </form>
              </div>
            </div>

            <%-- "수정" 누르면 위 조회 화면 대신 이게 보임 --%>
            <div class="card card--sm" id="address-edit-${addr.addressId}" style="display:none">
              <form method="post" action="${pageContext.request.contextPath}/user/mypage/address/${addr.addressId}">
                <div class="field">
                  <label class="field__label">별명</label>
                  <input type="text" name="addressName" class="input" value="${addr.addressName}" placeholder="예: 집, 사무실, 부모님댁">
                </div>

                <div class="field">
                  <label class="field__label">지역 선택<span class="req">*</span></label>

                  <button type="button" class="btn btn--ghost btn--block" id="edit-region-toggle-btn-${addr.addressId}"
                          onclick="toggleRegionPanel('edit-region-panel-${addr.addressId}')">
                    <span id="edit-region-label-${addr.addressId}"><c:out value="${addr.address}"/></span>
                    <svg class="ico" style="margin-left:auto"><use href="#i-chevd"/></svg>
                  </button>

                  <div id="edit-region-panel-${addr.addressId}" style="display:none;margin-top:10px;padding:16px;
                       border:1.5px solid var(--g-300);border-radius:var(--r-md);
                       max-height:220px;overflow-y:auto">
                    <c:forEach var="region" items="${regionList}">
                      <label class="check" style="display:block;margin-bottom:12px">
                        <input type="radio" name="editRegionRadio${addr.addressId}" value="${region.codeId}"
                               data-region-name="${region.codeName}">
                        <c:out value="${region.codeName}"/>
                      </label>
                    </c:forEach>
                  </div>
                </div>

                <div class="field">
                  <label class="field__label">상세주소<span class="req">*</span></label>
                  <input type="text" id="edit-address-detail-${addr.addressId}" name="addressDetail" class="input"
                         value="${addr.addressDetail}" required>
                </div>

                <!-- 실제 제출되는 최종 주소. 지역을 안 바꾸면 기존 주소 그대로 유지됨 -->
                <input type="hidden" id="edit-address-${addr.addressId}" name="address" value="${addr.address}">
				<script>
				document.addEventListener('DOMContentLoaded', function() {
				  bindRegionSelect('edit-region-panel-${addr.addressId}', 'edit-address-detail-${addr.addressId}', 'edit-address-${addr.addressId}', 'edit-region-label-${addr.addressId}', 'editRegionRadio${addr.addressId}');
				});
				</script>
                <div class="field">
                  <label class="field__label">기본 주소 설정</label>
                  <select name="isDefault" class="select">
                    <option value="N" ${addr.isDefault == 'N' ? 'selected' : ''}>일반 주소</option>
                    <option value="Y" ${addr.isDefault == 'Y' ? 'selected' : ''}>기본 주소로 설정</option>
                  </select>
                </div>
                <div class="btn-row">
                  <button type="button" class="btn btn--ghost" onclick="toggleAddressEdit(${addr.addressId})">취소</button>
                  <button type="submit" class="btn btn--primary">저장</button>
                </div>
              </form>
            </div>

          </c:forEach>
        </c:otherwise>
      </c:choose>

      <c:if test="${fn:length(addressList) < 3}">
        <button type="button" class="btn btn--ghost btn--block btn--lg" style="margin-top:18px" id="add-address-btn"
                onclick="toggleAddressAdd()">
          <svg class="ico"><use href="#i-plus"/></svg>새 주소 추가하기
        </button>

        <div class="card card--sm" id="address-add-form" style="display:none;margin-top:14px">
          <form method="post" action="${pageContext.request.contextPath}/user/mypage/address">
            <div class="field">
              <label class="field__label">별명</label>
              <input type="text" name="addressName" class="input" placeholder="예: 집, 사무실, 부모님댁">
            </div>

            <div class="field">
              <label class="field__label">지역 선택<span class="req">*</span></label>

              <button type="button" class="btn btn--ghost btn--block" id="new-region-toggle-btn" onclick="toggleNewAddressRegionSelect()">
                <span id="new-region-selected-label">지역을 선택해주세요</span>
                <svg class="ico" style="margin-left:auto"><use href="#i-chevd"/></svg>
              </button>

              <div id="new-region-select-panel" style="display:none;margin-top:10px;padding:16px;
                   border:1.5px solid var(--g-300);border-radius:var(--r-md);
                   max-height:220px;overflow-y:auto">
                <c:forEach var="region" items="${regionList}">
                  <label class="check" style="display:block;margin-bottom:12px">
                    <input type="radio" name="newRegionRadio" value="${region.codeId}"
                           data-region-name="${region.codeName}">
                    <c:out value="${region.codeName}"/>
                  </label>
                </c:forEach>
              </div>
            </div>

            <div class="field">
              <label class="field__label">상세주소<span class="req">*</span></label>
              <input type="text" id="new-address-detail" name="addressDetail" class="input"
                     placeholder="예: 테헤란로 123, 101동 1502호" required>
            </div>

            <!-- 실제 제출되는 최종 주소 (지역명 + 상세주소를 JS로 합쳐서 채움) -->
            <input type="hidden" id="new-address" name="address">

            <div class="field">
              <label class="field__label">기본 주소 설정</label>
              <select name="isDefault" class="select">
                <option value="N">일반 주소</option>
                <option value="Y">기본 주소로 설정</option>
              </select>
            </div>
            <div class="btn-row">
              <button type="button" class="btn btn--ghost" onclick="toggleAddressAdd()">취소</button>
              <button type="submit" class="btn btn--primary">추가하기</button>
            </div>
          </form>
        </div>
      </c:if>
    </div>
  </div>
</div>

</main>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />

</body>
</html>