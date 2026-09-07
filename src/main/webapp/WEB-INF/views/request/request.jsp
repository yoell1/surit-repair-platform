<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>

<svg width="0" height="0" style="position:absolute" aria-hidden="true">
    <defs>

        <!-- 도어락 · 잠금 -->
        <symbol id="i-lock" viewBox="0 0 24 24">
            <rect x="5" y="10" width="14" height="10" rx="2"/>
            <path d="M8 10V7a4 4 0 0 1 8 0v3"/>
            <circle cx="12" cy="15" r="1.4" fill="currentColor" stroke="none"/>
        </symbol>

        <!-- 냉장고 -->
        <symbol id="i-fridge" viewBox="0 0 24 24">
            <rect x="6" y="3" width="12" height="18" rx="2"/>
            <path d="M6 10h12"/>
            <path d="M9 6v2"/>
            <path d="M9 13v2.5"/>
        </symbol>

        <!-- PC · 노트북 -->
        <symbol id="i-pc" viewBox="0 0 24 24">
            <rect x="3" y="5" width="18" height="12" rx="2"/>
            <path d="M9 21h6"/>
            <path d="M12 17v4"/>
        </symbol>

        <!-- 배관 · 누수 -->
        <symbol id="i-drop" viewBox="0 0 24 24">
            <path d="M12 3c4 4.5 6 7 6 9a6 6 0 0 1-12 0c0-2 2-4.5 6-9z"/>
        </symbol>

        <!-- 전기 · 조명 -->
        <symbol id="i-bolt" viewBox="0 0 24 24">
            <path d="M13 2 5 14h6l-1 8 8-12h-6l1-8z"/>
        </symbol>

        <!-- 세탁기 · 건조기 -->
        <symbol id="i-washer" viewBox="0 0 24 24">
            <rect x="5" y="3" width="14" height="18" rx="2"/>
            <circle cx="12" cy="14" r="4"/>
            <path d="M8 6.5h2"/>
        </symbol>

        <!-- 에어컨 · 보일러 -->
        <symbol id="i-ac" viewBox="0 0 24 24">
            <rect x="3" y="5" width="18" height="7" rx="2"/>
            <path d="M8 15q2 2 0 4"/>
            <path d="M12 15q2 2 0 4"/>
            <path d="M16 15q2 2 0 4"/>
        </symbol>

        <!-- 가구 · 조립 -->
        <symbol id="i-chair" viewBox="0 0 24 24">
            <rect x="6" y="3" width="12" height="8" rx="2"/>
            <path d="M5 13h14"/>
            <path d="M7 21v-4"/>
            <path d="M17 21v-4"/>
        </symbol>

        <!-- TV · 모니터 -->
        <symbol id="i-tv" viewBox="0 0 24 24">
            <rect x="3" y="5" width="18" height="12" rx="2"/>
            <path d="M9 21h6"/>
            <path d="M12 17v4"/>
        </symbol>

        <!-- 기타 -->
        <symbol id="i-dots" viewBox="0 0 24 24">
            <circle cx="5" cy="12" r="1.6" fill="currentColor" stroke="none"/>
            <circle cx="12" cy="12" r="1.6" fill="currentColor" stroke="none"/>
            <circle cx="19" cy="12" r="1.6" fill="currentColor" stroke="none"/>
        </symbol>

        <!-- 사진 첨부 -->
        <symbol id="i-camera" viewBox="0 0 24 24">
            <path d="M4 8h3l1.5-2h7L17 8h3a1 1 0 0 1 1 1v9a1 1 0 0 1-1 1H4a1 1 0 0 1-1-1V9a1 1 0 0 1 1-1z"/>
            <circle cx="12" cy="13.5" r="3.6"/>
        </symbol>

        <!-- 이미지 -->
        <symbol id="i-image" viewBox="0 0 24 24">
            <rect x="3" y="5" width="18" height="14" rx="2"/>
            <circle cx="8.5" cy="10" r="1.6"/>
            <path d="M4 17l5-5 4 4 3-2 4 4"/>
        </symbol>

        <!-- 플러스 -->
        <symbol id="i-plus" viewBox="0 0 24 24">
            <path d="M12 5v14"/>
            <path d="M5 12h14"/>
        </symbol>

        <!-- 방패 -->
        <symbol id="i-shield" viewBox="0 0 24 24">
            <path d="M12 3l7 3v5.5c0 4.4-3 8-7 9.5-4-1.5-7-5.1-7-9.5V6z"/>
            <path d="M9.2 12l2 2 3.6-3.8"/>
        </symbol>

    </defs>
</svg>

<main>
<div class="container">
    <div class="page-head">
        <h1><c:choose><c:when test="${editMode}">수리 접수 수정</c:when><c:otherwise>수리 접수</c:otherwise></c:choose></h1>
        <p>증상만 남겨주시면 주변 기사님이 직접 견적을 신청합니다.</p>
    </div>

    <div class="card" style="max-width:840px;margin:0 auto">
		<form id="request-form"
		      action="<c:choose>
		                  <c:when test='${editMode}'>${pageContext.request.contextPath}/request/${request.requestId}/edit</c:when>
		                  <c:otherwise>${pageContext.request.contextPath}/request/request</c:otherwise>
		              </c:choose>"
		      method="post"
		      enctype="multipart/form-data">

		    <c:if test="${editMode}">
		        <input type="hidden" name="requestId" value="${request.requestId}">
		    </c:if>

            <div class="form-sec">
                <div class="form-sec__head">
                    <span class="form-sec__no">1</span>
                    <div><div class="form-sec__title">무엇이 고장났나요?</div></div>
                </div>

				<div class="cat-grid">

				    <c:forEach var="cat" items="${categoryList}" varStatus="status">

				        <button type="button"
				               class="cat${cat.codeId eq selectedCategoryCode ? ' is-on' : ''}"
				                data-select="category"
				                data-category-code="${cat.codeId}">

								<c:choose>

								    <c:when test="${cat.codeId eq 'CAT_10'}">
								        <span class="tile t-lock">
								            <svg><use href="#i-lock"/></svg>
								        </span>
								        <span>도어락 · 잠금</span>
								    </c:when>

								    <c:when test="${cat.codeId eq 'CAT_02'}">
								        <span class="tile t-fridge">
								            <svg><use href="#i-fridge"/></svg>
								        </span>
								        <span>냉장고</span>
								    </c:when>

								    <c:when test="${cat.codeId eq 'CAT_01'}">
								        <span class="tile t-pc">
								            <svg><use href="#i-pc"/></svg>
								        </span>
								        <span>PC · 노트북</span>
								    </c:when>

								    <c:when test="${cat.codeId eq 'CAT_05'}">
								        <span class="tile t-drop">
								            <svg><use href="#i-drop"/></svg>
								        </span>
								        <span>배관 · 누수</span>
								    </c:when>

								    <c:when test="${cat.codeId eq 'CAT_06'}">
								        <span class="tile t-bolt">
								            <svg><use href="#i-bolt"/></svg>
								        </span>
								        <span>전기 · 조명</span>
								    </c:when>

								    <c:when test="${cat.codeId eq 'CAT_03'}">
								        <span class="tile t-washer">
								            <svg><use href="#i-washer"/></svg>
								        </span>
								        <span>세탁기 · 건조기</span>
								    </c:when>

								    <c:when test="${cat.codeId eq 'CAT_09'}">
								        <span class="tile t-ac">
								            <svg><use href="#i-ac"/></svg>
								        </span>
								        <span>에어컨 · 보일러</span>
								    </c:when>

								    <c:when test="${cat.codeId eq 'CAT_04'}">
								        <span class="tile t-chair">
								            <svg><use href="#i-chair"/></svg>
								        </span>
								        <span>가구 · 조립</span>
								    </c:when>

								    <c:when test="${cat.codeId eq 'CAT_08'}">
								        <span class="tile t-tv">
								            <svg><use href="#i-tv"/></svg>
								        </span>
								        <span>TV · 모니터</span>
								    </c:when>

								    <c:when test="${cat.codeId eq 'CAT_07'}">
								        <span class="tile t-dots">
								            <svg><use href="#i-dots"/></svg>
								        </span>
								        <span>기타</span>
								    </c:when>

								</c:choose>

				        </button>

				    </c:forEach>

				</div>

				<input type="hidden"
				       id="category-code"
				       name="categoryCode"
				       value="${not empty selectedCategoryCode
				                ? selectedCategoryCode
				                : categoryList[0].codeId}">

            </div>

            <div class="form-sec">
                <div class="form-sec__head">
                    <span class="form-sec__no">2</span>
                    <div>
                        <div class="form-sec__title">어떤 증상인가요?</div>
                        <div class="form-sec__desc">자세히 적을수록 기사님이 빠르게 판단할 수 있어요</div>
                    </div>
                </div>

                <div class="field">
                    <label class="field__label" for="request-title">제목<span class="req">*</span></label>
                    <input type="text" id="request-title" name="title" class="input"
                        value="${request.title}"
                        placeholder="예: 현관 도어락이 반응이 없어요" required>
                </div>

                <textarea id="request-content" name="content" class="textarea"
                    placeholder="예) 현관 도어락 버튼을 눌러도 반응이 없고 삐 소리만 납니다.&#10;건전지는 어제 새로 갈았습니다.">${request.content}</textarea>

					<div class="field__label" style="margin:26px 0 12px">
					    사진 첨부
					    <span class="muted" style="font-weight:400">
					        (선택 · 최대 5장)
					    </span>
					</div>

					<div class="upload">

					    <!-- 사진 추가 버튼 -->
					    <label for="request-photos" class="upload__add">
					        <svg>
					            <use href="#i-camera"/>
					        </svg>
					        <span>사진 추가</span>
					    </label>

					    <!-- 실제 파일 선택 -->
					    <input type="file"
					           id="request-photos"
					           name="photoFiles"
					           accept="image/*"
					           multiple
					           style="display:none;">

					    <!-- 선택한 사진들이 여기에 좌르륵 나옴 -->
					    <div id="photo-preview" class="photo-preview"></div>
					</div>
					</div>

					<!-- 3. 방문 주소 -->
					<div class="form-sec">

					    <div class="form-sec__head">
					        <span class="form-sec__no">3</span>

					        <div>
					            <div class="form-sec__title">
					                어디로 방문할까요?
					            </div>
					        </div>
					    </div>

						<div class="address-list">

							<c:forEach var="addr" items="${addressList}" varStatus="status">

							<%-- ── 평소 화면 : 주소 카드 (수정/삭제는 카드 안 오른쪽) ──
							     카드를 <button> 이 아니라 <div> 로 만들었다.
							     HTML 은 버튼 안에 버튼을 넣을 수 없기 때문이다.
							     클릭으로 주소를 고르는 동작은 common.js 가 .address-card 클래스로
							     잡고 있어서 div 여도 그대로 동작한다. --%>
							<div id="addr-view-${addr.addressId}">

								<div class="address-card ${addr.isDefault eq 'Y' ? 'is-on' : ''}"
								     role="button" tabindex="0" style="cursor:pointer"
								     data-address="${fn:escapeXml(addr.address)} ${fn:escapeXml(addr.addressDetail)}">

									<span class="address-radio"></span>

									<span class="address-card__body" style="flex:1;min-width:0">
										<strong>
											<c:choose>
												<c:when test="${not empty addr.addressName}">
													<c:out value="${addr.addressName}"/>
												</c:when>
												<c:when test="${addr.isDefault eq 'Y'}">
													기본 주소
												</c:when>
												<c:otherwise>
													주소 ${status.index + 1}
												</c:otherwise>
											</c:choose>
											<c:if test="${not empty addr.addressName and addr.isDefault eq 'Y'}">
												<span class="badge badge--primary"
												      style="margin-left:6px;font-size:12px">기본</span>
											</c:if>
										</strong>

										<span class="address-card__text">
											<c:out value="${addr.address}"/> <c:out value="${addr.addressDetail}"/>
										</span>
									</span>

									<%-- ★ event.stopPropagation() 필수.
									     없으면 수정/삭제를 눌렀을 때 카드 클릭까지 같이 실행돼서
									     엉뚱한 주소가 선택된다. --%>
									<span style="margin-left:auto;display:flex;gap:8px;flex-shrink:0">
										<button type="button" class="btn btn--ghost btn--sm"
										        onclick="event.stopPropagation(); toggleReqAddressEdit(${addr.addressId})">수정</button>
										<button type="button" class="btn btn--danger btn--sm"
										        onclick="event.stopPropagation(); deleteReqAddress(${addr.addressId})">삭제</button>
									</span>

								</div>
							</div>

								<%-- ── "수정" 누르면 나오는 폼 ──
								     name 속성 없음. 있으면 접수 폼이 같이 제출해버린다. --%>
								<div class="card card--sm" id="addr-edit-${addr.addressId}"
								     style="display:none;margin-bottom:14px">

									<div class="field">
										<label class="field__label">별명</label>
										<input type="text" class="input" id="ed-name-${addr.addressId}"
										       value="${fn:escapeXml(addr.addressName)}" placeholder="예: 집, 사무실">
									</div>

									<div class="field">
										<label class="field__label">지역 선택<span class="req">*</span></label>
										<button type="button" class="btn btn--ghost btn--block"
										        onclick="toggleRegionPanel('ed-panel-${addr.addressId}')">
											<span id="ed-label-${addr.addressId}"><c:out value="${addr.address}"/></span>
											<svg class="ico" style="margin-left:auto"><use href="#i-chevd"/></svg>
										</button>

										<div id="ed-panel-${addr.addressId}" style="display:none;margin-top:10px;padding:16px;
										     border:1.5px solid var(--g-300);border-radius:var(--r-md);
										     max-height:220px;overflow-y:auto">
											<c:forEach var="region" items="${regionList}">
												<label class="check" style="display:block;margin-bottom:12px">
													<input type="radio" name="edRadio${addr.addressId}" value="${region.codeId}"
													       data-region-name="${region.codeName}">
													<c:out value="${region.codeName}"/>
												</label>
											</c:forEach>
										</div>
									</div>

									<div class="field">
										<label class="field__label">상세주소<span class="req">*</span></label>
										<input type="text" class="input" id="ed-detail-${addr.addressId}"
										       value="${fn:escapeXml(addr.addressDetail)}">
									</div>

									<input type="hidden" id="ed-address-${addr.addressId}"
									       value="${fn:escapeXml(addr.address)}">

									<div class="field">
										<label class="field__label">기본 주소 설정</label>
										<select class="select" id="ed-default-${addr.addressId}">
											<option value="N" ${addr.isDefault eq 'N' ? 'selected' : ''}>일반 주소</option>
											<option value="Y" ${addr.isDefault eq 'Y' ? 'selected' : ''}>기본 주소로 설정</option>
										</select>
									</div>

									<div class="btn-row">
										<button type="button" class="btn btn--ghost"
										        onclick="toggleReqAddressEdit(${addr.addressId})">취소</button>
										<button type="button" class="btn btn--primary"
										        onclick="saveReqAddress(${addr.addressId})">저장</button>
									</div>

									<script>
									document.addEventListener('DOMContentLoaded', function () {
									  bindRegionSelect('ed-panel-${addr.addressId}',   'ed-detail-${addr.addressId}',
									                   'ed-address-${addr.addressId}', 'ed-label-${addr.addressId}',
									                   'edRadio${addr.addressId}');
									});
									</script>
								</div>

							</c:forEach>

						</div>

								    <input type="hidden" id="service-address" name="serviceAddress"
								           value="${request.serviceAddress}">
								</div>                                              

								<c:if test="${fn:length(addressList) < 3}">
								       <button type="button" class="address-add" id="add-address-btn"
								               onclick="toggleAddressAdd()">
								           + 새 주소 추가하기
								       </button>

					<!-- 새 주소 추가 (접수 폼과는 별개의 form. AJAX로 제출 후 목록만 갱신) -->
					<div class="card card--sm" id="address-add-form" style="display:none;margin:14px 0">
					  <div id="inline-address-form">
					    <div class="field">
					      <label class="field__label">별명</label>
					      <input type="text" name="addressName" class="input" placeholder="예: 집, 사무실, 부모님댁">
					    </div>

					    <div class="field">
					      <label class="field__label">지역 선택<span class="req">*</span></label>

					      <button type="button" class="btn btn--ghost btn--block" id="new-region-toggle-btn"
					              onclick="toggleNewAddressRegionSelect()">
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
					             placeholder="예: 테헤란로 123, 101동 1502호">
					    </div>

					    <input type="hidden" id="new-address" name="address">

					    <div class="field">
					      <label class="field__label">기본 주소 설정</label>
					      <select name="isDefault" class="select">
					        <option value="N">일반 주소</option>
					        <option value="Y" selected>기본 주소로 설정</option>
					      </select>
					    </div>

					    <div class="btn-row">
					      <button type="button" class="btn btn--ghost" onclick="toggleAddressAdd()">취소</button>
					      <button type="button" class="btn btn--primary" id="inline-address-submit">추가하기</button>
					    </div>
					  </div>
					</div>
					<script>
					document.addEventListener('DOMContentLoaded', function() {
					  bindRegionSelect('new-region-select-panel', 'new-address-detail', 'new-address', 'new-region-selected-label', 'newRegionRadio');

					  var submitBtn = document.getElementById('inline-address-submit');
					  if (!submitBtn) return;

					  submitBtn.addEventListener('click', function () {

					    var addressValue = document.getElementById('new-address').value;
					    if (!addressValue) {
					      alert('지역과 상세주소를 모두 입력해주세요.');
					      return;
					    }

					    var wrap = document.getElementById('inline-address-form');
					    var formData = new URLSearchParams();
					    formData.set('addressName', wrap.querySelector('[name="addressName"]').value);
					    formData.set('address', document.getElementById('new-address').value);
					    formData.set('addressDetail', document.getElementById('new-address-detail').value);
					    formData.set('isDefault', wrap.querySelector('[name="isDefault"]').value);

					    fetch('${pageContext.request.contextPath}/user/mypage/address', {
					      method: 'POST',
					      headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
					      body: formData
					    })
					    .then(function (res) {
					      if (!res.ok) throw new Error('실패');
					      location.reload();   // 새 주소 목록 반영을 위해 새로고침
					                            // (작성 중인 접수 내용은 새로고침 전에 유지 안 됨 — 필요하면 임시저장 로직 추가 가능)
					    })
					    .catch(function () {
					      alert('주소 추가 중 오류가 발생했습니다. 다시 시도해주세요.');
					    });
					  });
					});
					</script>
					</c:if>
					
					<%-- ══════════ 접수 페이지 주소 수정·삭제 ══════════
					     ★ 반드시 위 <c:if> 바깥에 둔다.
					       안에 넣으면 주소가 3개일 때 이 스크립트가 아예 안 실려서
					       수정·삭제 버튼이 먹통이 된다.

					     ★ 이 영역은 접수 <form> 안이라 form 을 또 만들 수 없다(HTML 규칙).
					       그래서 폼 전송 대신 fetch 로 마이페이지 주소 API 를 직접 부른다. --%>
					<script>
					(function () {
					  var CTX = '${pageContext.request.contextPath}';

					  window.toggleReqAddressEdit = function (id) {
					    var view = document.getElementById('addr-view-' + id);
					    var edit = document.getElementById('addr-edit-' + id);
					    if (!view || !edit) return;

					    var opening = (edit.style.display === 'none');
					    edit.style.display = opening ? 'block' : 'none';
					    view.style.display = opening ? 'none' : 'block';
					  };

					  window.saveReqAddress = function (id) {
					    var address = document.getElementById('ed-address-' + id).value;
					    var detail  = document.getElementById('ed-detail-'  + id).value;

					    if (!address || !detail.trim()) {
					      alert('지역과 상세주소를 모두 입력해주세요.');
					      return;
					    }

					    var body = new URLSearchParams();
					    body.set('addressName',   document.getElementById('ed-name-'    + id).value);
					    body.set('address',       address);
					    body.set('addressDetail', detail);
					    body.set('isDefault',     document.getElementById('ed-default-' + id).value);

					    fetch(CTX + '/user/mypage/address/' + id, {
					      method:  'POST',
					      headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
					      body:    body
					    })
					    .then(function (res) {
					      if (!res.ok) throw new Error('실패');
					      location.reload();
					    })
					    .catch(function () { alert('주소 수정 중 오류가 발생했습니다.'); });
					  };

					  window.deleteReqAddress = function (id) {
					    if (!confirm('이 주소를 삭제할까요?')) return;

					    fetch(CTX + '/user/mypage/address/' + id + '/delete', { method: 'POST' })
					    .then(function (res) {
					      if (!res.ok) throw new Error('실패');
					      location.reload();
					    })
					    .catch(function () { alert('주소 삭제 중 오류가 발생했습니다.'); });
					  };
					})();
					</script>

			<!-- 4. 방문 날짜 / 시간 -->
			<div class="form-sec">

			    <div class="form-sec__head">
			        <span class="form-sec__no">4</span>

			        <div>
			            <div class="form-sec__title">
			                언제 방문할까요?
			            </div>
			        </div>
			    </div>



			    <!-- 지금 바로 / 날짜 지정 -->
			    <div class="opt-grid" id="when-select">

			        <!-- 지금 바로 -->
			        <button type="button"
			                class="opt opt--accent is-on"
			                data-use-yn="Y">

			            <span class="opt__radio"></span>

			            <span class="opt__body">
			                <span class="opt__title">
			                   긴급 접수
			                </span>

			                <span class="opt__desc">
			                    가장 먼저 신청한 기사님과 연결
			                </span>
			            </span>

			        </button>

			        <!-- 날짜 지정 -->
			        <button type="button"
			                class="opt"
			                data-use-yn="N">

			            <span class="opt__radio"></span>

			            <span class="opt__body">
			                <span class="opt__title">
			                    날짜 지정
			                </span>

			                <span class="opt__desc">
			                    원하는 날짜와 시간대 선택
			                </span>
			            </span>

			        </button>

			    </div>
				<input type="hidden" id="urgent-yn" name="urgentYn" value="Y">
			    <!-- 날짜 지정 선택 시 표시 -->
			    <div id="visit-option-area"
			         style="display:none; margin-top:20px;">

			        <!-- 날짜 -->
			        <div class="field">

			            <label class="field__label"
			                   for="visit-date">
			                희망 방문 날짜
			            </label>

			            <input type="date"
			                   id="visit-date"
			                   name="visitDate"
			                   class="input">

			        </div>

			        <!-- 시간대 -->
					<div class="field" style="margin-top:20px;">
					    <label class="field__label" for="visit-time-code">
					        희망 시간대
					    </label>

					    <div style="position: relative; width: 100%;">

					        <select id="visit-time-code"
					                name="visitTimeCode"
					                class="input"
					                style="
					                    width: 100%;
					                    appearance: none;
					                    -webkit-appearance: none;
					                    -moz-appearance: none;
					                    padding-right: 55px;
					                ">

					            <option value="">시간대를 선택해주세요</option>

					            <c:forEach var="time" items="${visitTimeList}">
					                <option value="${time.codeId}">
					                    ${time.codeName}
					                </option>
					            </c:forEach>

					        </select>

					        <!-- 직접 만든 화살표 -->
					        <span style="
					            position: absolute;
					            right: 20px;
					            top: 50%;
					            transform: translateY(-50%);
					            pointer-events: none;
					            font-size: 13px;
					            color: #222;
					        ">
					            ▼
					        </span>

					    </div>
					</div>

			    </div>

			</div>

            <div class="form-sec">
                <label class="check" style="margin-bottom:26px">
                    <input type="checkbox" id="agree-checkbox" required>
                    개인정보 제3자 제공 및 이용약관에 동의합니다. (필수)
                </label>

                <button type="submit" class="btn btn--primary btn--xl btn--block">
                    <c:choose><c:when test="${editMode}">수정 완료</c:when><c:otherwise>접수하고 기사님 찾기</c:otherwise></c:choose>
                </button>

                <div class="note note--gray" style="margin-top:20px">
                    <svg><use href="#i-shield"/></svg>
                    <p>기사님을 수락하기 전까지는 어떤 비용도 발생하지 않습니다.
                    수리비는 작업이 끝난 뒤 <b>현장에서 직접</b> 결제합니다.</p>
                </div>
            </div>

        </form>
    </div>
</div>
</main>

<jsp:include page="/WEB-INF/views/common/footer.jsp"/>