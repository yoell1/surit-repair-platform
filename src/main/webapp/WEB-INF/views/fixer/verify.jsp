<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!doctype html>
<html lang="ko">
<head>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<title>기사 인증 | 수릿 Surit</title>
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/pages.css">
</head>
<body>

<svg width="0" height="0" style="position:absolute" aria-hidden="true"><defs><symbol id="i-tools" viewBox="0 0 24 24"><path d="M14.7 6.3a1 1 0 0 0 0 1.4l1.6 1.6a1 1 0 0 0 1.4 0l3.77-3.77a6 6 0 0 1-7.94 7.94l-6.91 6.91a2.12 2.12 0 0 1-3-3l6.91-6.91a6 6 0 0 1 7.94-7.94z"/></symbol><symbol id="i-refresh" viewBox="0 0 24 24"><path d="M20 11a8 8 0 0 0-13.7-5.3L3 9"/><path d="M4 13a8 8 0 0 0 13.7 5.3L21 15"/><path d="M3 4v5h5"/><path d="M21 20v-5h-5"/></symbol><symbol id="i-user" viewBox="0 0 24 24"><circle cx="12" cy="8" r="4"/><path d="M4.5 20.5a7.5 7.5 0 0 1 15 0"/></symbol><symbol id="i-list" viewBox="0 0 24 24"><path d="M8 6h13"/><path d="M8 12h13"/><path d="M8 18h13"/><path d="M3.5 6h.01"/><path d="M3.5 12h.01"/><path d="M3.5 18h.01"/></symbol><symbol id="i-home" viewBox="0 0 24 24"><path d="M4 11.5 12 4l8 7.5"/><path d="M6.5 10.5V20h11v-9.5"/></symbol><symbol id="i-wrench" viewBox="0 0 24 24"><path d="M14.7 6.3a1 1 0 0 0 0 1.4l1.6 1.6a1 1 0 0 0 1.4 0l3.77-3.77a6 6 0 0 1-7.94 7.94l-6.91 6.91a2.12 2.12 0 0 1-3-3l6.91-6.91a6 6 0 0 1 7.94-7.94z"/></symbol><symbol id="i-shield" viewBox="0 0 24 24"><path d="M12 3l7 3v5.5c0 4.4-3 8-7 9.5-4-1.5-7-5.1-7-9.5V6z"/><path d="M9.2 12l2 2 3.6-3.8"/></symbol><symbol id="i-chat" viewBox="0 0 24 24"><path d="M4 6.5A2.5 2.5 0 0 1 6.5 4h11A2.5 2.5 0 0 1 20 6.5v8a2.5 2.5 0 0 1-2.5 2.5H9.5L4 21.5z"/></symbol><symbol id="i-alert" viewBox="0 0 24 24"><circle cx="12" cy="12" r="9"/><path d="M12 7.5v5.5"/><circle cx="12" cy="16.5" r="1.1" fill="currentColor" stroke="none"/></symbol><symbol id="i-bell" viewBox="0 0 24 24"><path d="M18 15V10a6 6 0 1 0-12 0v5l-1.6 2.5h15.2z"/><path d="M10 20.5a2.2 2.2 0 0 0 4 0"/></symbol><symbol id="i-clock" viewBox="0 0 24 24"><circle cx="12" cy="12" r="9"/><path d="M12 7v5l3.5 2"/></symbol><symbol id="i-check" viewBox="0 0 24 24"><path d="M4.5 12.5 9.5 17.5 19.5 6.5"/></symbol><symbol id="i-doc" viewBox="0 0 24 24"><path d="M14 3H7a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h10a2 2 0 0 0 2-2V8z"/><path d="M14 3v5h5"/><path d="M9 13h6"/><path d="M9 17h6"/></symbol><symbol id="i-send" viewBox="0 0 24 24"><path d="M21 3 10.5 13.5"/><path d="M21 3l-7 18-3.5-7.5L3 10z"/></symbol><symbol id="i-search" viewBox="0 0 24 24"><circle cx="11" cy="11" r="7"/><path d="M16.2 16.2 21 21"/></symbol></defs></svg>

<jsp:include page="/WEB-INF/views/common/header.jsp"/>

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
				<%-- 2026-09-03 추가. 이 두 줄이 없어서 내 작업 / 기사 인증 화면에서는
				     접수 찾기와 견적 확인으로 갈 방법이 없었다. 주소창을 직접 쳐야 했다. --%>
				<a href="${pageContext.request.contextPath}/fixer/requests"><svg class="ico"><use href="#i-search"/></svg>내 주변 새 접수</a>
				<a href="${pageContext.request.contextPath}/fixer/estimates"><svg class="ico"><use href="#i-doc"/></svg>내 견적</a>
				<a href="${pageContext.request.contextPath}/fixer/jobs"><svg class="ico"><use href="#i-list"/></svg>내 작업</a>
				<a href="${pageContext.request.contextPath}/fixer/verify" class="is-active"><svg class="ico"><use href="#i-shield"/></svg>기사 인증</a>
				<a href="${pageContext.request.contextPath}/fixer/mypage"><svg class="ico"><use href="#i-wrench"/></svg>수리 정보 관리</a>
				<a href="${pageContext.request.contextPath}/fixer/mypage/address"><svg class="ico"><use href="#i-home"/></svg>주소 관리</a>
				<a href="${pageContext.request.contextPath}/fixer/mypage/profile"><svg class="ico"><use href="#i-user"/></svg>내 정보 수정</a>
				<a href="${pageContext.request.contextPath}/support"><svg class="ico"><use href="#i-chat"/></svg>고객센터</a>
			</nav>

			<div>
				<div class="sec-head sec-head--row" style="margin-bottom:20px">
					<div>
						<h2>기사 인증</h2>
						<p>자격증을 제출하면 관리자가 확인 후 승인합니다. 승인 전에는 견적을 보낼 수 없습니다.</p>
					</div>
				</div>

				<c:if test="${not empty message}">
					<c:choose>
						<c:when test="${messageType eq 'error'}">
							<div class="note note--warn" style="margin-bottom:24px">
								<svg><use href="#i-alert"/></svg>
								<span><b><c:out value="${message}"/></b><br><span class="muted">신청이 저장되지 않았습니다. 입력값을 다시 확인해주세요.</span></span>
							</div>
						</c:when>
						<c:otherwise>
							<div class="note note--blue" style="margin-bottom:24px">
								<svg><use href="#i-bell"/></svg>
								<span><c:out value="${message}"/></span>
							</div>
						</c:otherwise>
					</c:choose>
				</c:if>

				<c:choose>
					<c:when test="${profile.approvalStatus eq 'PENDING'}">
						<div class="note note--warn">
							<svg><use href="#i-clock"/></svg>
							<span><b>자격 심사가 진행 중입니다.</b> 보통 1~2일 걸립니다.<br>승인되면 알림을 보내드립니다.</span>
						</div>
					</c:when>
					<c:when test="${profile.approvalStatus eq 'APPROVED'}">
						<div class="note note--ok" style="margin-bottom:24px">
							<svg><use href="#i-check"/></svg>
							<span><b>인증이 완료된 기사입니다.</b> 이제 접수를 보고 견적을 보낼 수 있습니다.</span>
						</div>
					</c:when>
					<c:otherwise>
						<c:if test="${profile.approvalStatus eq 'REJECTED'}">
							<div class="note note--warn" style="margin-bottom:24px">
								<svg><use href="#i-alert"/></svg>
								<span><b>이전 신청이 거절되었습니다.</b> 내용을 보완해서 다시 신청해주세요.<br><br><b>거절 사유</b><br><span style="display:block; white-space:pre-wrap;"><c:out value="${profile.rejectReason}"/></span></span>
							</div>
						</c:if>

						<form action="${pageContext.request.contextPath}/fixer/verify" method="post" enctype="multipart/form-data" novalidate>
							<c:if test="${not empty _csrf}">
								<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
							</c:if>

							<div class="card">
								<div class="card__head"><h2 class="card__title">기본 정보</h2></div>
								<div class="field">
									<label class="field__label" for="intro">자기소개</label>
									<textarea class="textarea" id="intro" name="intro" rows="4"><c:out value="${profile.intro}"/></textarea>
									<div class="field__help">한글은 1자가 3바이트입니다.<b id="introCount" style="float:right"></b></div>
								</div>
								<div class="field" style="margin-bottom:0">
									<label class="field__label" for="careerYears">경력 (년)<span class="req">*</span></label>
									<input class="input" id="careerYears" type="number" name="careerYears" required value="${profile.careerYears}" style="max-width:220px">
								</div>
							</div>

							<div class="card">
								<div class="card__head"><h2 class="card__title">본인 확인용 사진<span class="req">*</span></h2></div>
								<div class="field" style="margin-bottom:0">
									<input class="input" type="file" name="photoFile" accept=".jpg,.jpeg,.png" required>
									<div class="field__help">고객에게 공개되는 사진입니다. (10MB 이하)</div>
								</div>
							</div>

							<div class="card">
								<div class="card__head"><h2 class="card__title">활동 지역<span class="req">*</span></h2></div>
								<div class="chip-row">
									<c:forEach var="region" items="${regionList}">
										<label class="check" style="min-width:190px">
											<input type="checkbox" name="regionCodes" value="${region.codeId}">
											<c:out value="${region.codeName}"/>
										</label>
									</c:forEach>
								</div>
							</div>

							<div class="card">
								<div class="card__head"><h2 class="card__title">수리 가능 분야<span class="req">*</span></h2></div>
								<div class="chip-row">
									<c:forEach var="category" items="${categoryList}">
										<label class="check" style="min-width:190px">
											<input type="checkbox" name="categoryCodes" value="${category.codeId}">
											<c:out value="${category.codeName}"/>
										</label>
									</c:forEach>
								</div>
							</div>

							<div class="card">
								<div class="card__head"><h2 class="card__title">자격증<span class="req">*</span></h2></div>
								<c:forEach var="i" begin="1" end="3">
									<div class="list-card" style="align-items:flex-start">
										<span class="tile tile--sm t-blue"><svg><use href="#i-doc"/></svg></span>
										<div class="list-card__body">
											<div class="field__label" style="margin-bottom:12px">자격증 ${i}</div>
											<div class="field-row">
												<div class="field">
													<label class="field__label">자격증명</label>
													<input class="input" type="text" name="licenseNames" maxlength="100">
												</div>
												<div class="field">
													<label class="field__label">발급일</label>
													<input class="input" type="date" name="licenseIssuedAts">
												</div>
											</div>
											<div class="field" style="margin-bottom:0">
												<label class="field__label">증빙파일</label>
												<input class="input" type="file" name="licenseFiles" accept=".jpg,.jpeg,.png,.pdf">
											</div>
										</div>
									</div>
								</c:forEach>
							</div>

							<div class="card card--flat">
								<div id="formAlert" class="note note--warn" style="display:none; margin-bottom:22px">
									<svg><use href="#i-alert"/></svg><span id="formAlertText"></span>
								</div>
								<button type="submit" class="btn btn--primary btn--xl btn--block">
									<svg class="ico"><use href="#i-send"/></svg>인증 신청하기
								</button>
							</div>
						</form>

						<!-- 검증 로직 JS 뼈대 -->
						<script>
			(function () {
				'use strict';

				// ── 서버와 반드시 같아야 하는 값들 ──
				// application.properties : spring.servlet.multipart.max-file-size
				var MAX_MB    = 10;
				var MAX_BYTES = MAX_MB * 1024 * 1024;

				// FIXER_PROFILE.INTRO 가 VARCHAR2(4000) — 글자 수가 아니라 "바이트" 기준이다.
				// FixerServiceImpl.validate() 도 같은 값으로 다시 검사한다.
				var INTRO_MAX_BYTES = 4000;

				var PHOTO_EXT   = ['jpg', 'jpeg', 'png'];
				var LICENSE_EXT = ['jpg', 'jpeg', 'png', 'pdf'];

				var form = document.querySelector('form[action$="/fixer/verify"]');
				if (!form) return;

				var box        = document.getElementById('formAlert');
				var text       = document.getElementById('formAlertText');
				var intro      = document.getElementById('intro');
				var introCount = document.getElementById('introCount');

				// 제출을 한 번이라도 시도했는가.
				// 시도 전에는 "아직 안 채운 칸"까지 빨갛게 지적하면 잔소리로 느껴지므로,
				// 즉시 알 수 있는 문제(파일 확장자·용량)만 미리 알려준다.
				var tried = false;

				// ---------- 도우미 ----------

				// UTF-8 바이트 수. 한글 1자 = 3바이트라서 글자 수와 다르다.
				function byteLength(s) {
					if (!s) return 0;
					if (window.TextEncoder) return new TextEncoder().encode(s).length;
					return unescape(encodeURIComponent(s)).length;   // 구형 브라우저 대비
				}

				// "사진.PNG" → "png". 점이 없거나 점으로 끝나면 빈 문자열.
				// 서버 FileUploadUtil.extensionOf() 와 같은 규칙이다.
				function extOf(name) {
					if (!name) return '';
					var dot = name.lastIndexOf('.');
					if (dot < 0 || dot === name.length - 1) return '';
					return name.substring(dot + 1).toLowerCase();
				}

				function fileOf(input) {
					return (input && input.files && input.files[0]) ? input.files[0] : null;
				}

				function mb(bytes) {
					return (bytes / 1024 / 1024).toFixed(1) + 'MB';
				}

				// 파일 이름은 사용자가 정하는 값이라 그대로 innerHTML 에 넣으면 XSS 가 된다.
				function esc(s) {
					return String(s).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
				}

				// ---------- 자기소개 바이트 카운터 ----------

				function updateIntroCount() {
					if (!intro || !introCount) return;
					var n = byteLength(intro.value);
					introCount.textContent = n + ' / ' + INTRO_MAX_BYTES + ' 바이트';
					introCount.style.color = (n > INTRO_MAX_BYTES) ? '#b45309' : '';
				}

				if (intro) {
					intro.addEventListener('input', updateIntroCount);
					updateIntroCount();
				}

				// ---------- 검사 본체 ----------
				// 걸린 항목을 전부 모아서 한 번에 보여준다.
				// 하나씩 알려주면 "고치고 제출" 을 여러 번 반복하게 된다.

				function collect() {
					var list     = [];
					var firstBad = null;

					// kind 'file' : 파일을 고르는 순간 바로 알 수 있는 문제
					// kind 'need' : 아직 안 채운 항목 — 제출을 시도한 뒤에만 알린다
					function add(kind, msg, el) {
						list.push({ kind: kind, msg: msg });
						if (!firstBad && el) firstBad = el;
					}

					// 1) 자기소개 길이 (바이트 기준)
					if (intro) {
						var n = byteLength(intro.value);
						if (n > INTRO_MAX_BYTES) {
							add('need', '자기소개가 너무 깁니다. 현재 ' + n + '바이트 / 최대 '
								+ INTRO_MAX_BYTES + '바이트 (한글은 1자당 3바이트)', intro);
						}
					}

					// 2) 경력
					var career = document.getElementById('careerYears');
					if (career) {
						var v = (career.value || '').trim();
						if (v === '' || isNaN(v) || Number(v) < 0 || Number(v) > 70) {
							add('need', '경력(년)을 0 ~ 70 사이 숫자로 입력해주세요.', career);
						}
					}

					// 3) 본인 확인용 사진
					var photoInput = form.querySelector('input[name=photoFile]');
					var photo      = fileOf(photoInput);
					if (!photo) {
						add('need', '본인 확인용 사진을 첨부해주세요.', photoInput);
					} else if (PHOTO_EXT.indexOf(extOf(photo.name)) < 0) {
						add('file', '본인 확인용 사진은 jpg, png 만 올릴 수 있습니다. (선택한 파일: '
							+ esc(photo.name) + ')', photoInput);
					} else if (photo.size > MAX_BYTES) {
						add('file', '본인 확인용 사진이 ' + MAX_MB + 'MB를 넘습니다. ('
							+ mb(photo.size) + ')', photoInput);
					}

					// 4) 활동 지역
					if (form.querySelectorAll('input[name=regionCodes]:checked').length === 0) {
						add('need', '활동 지역을 최소 1개 선택해주세요.',
							form.querySelector('input[name=regionCodes]'));
					}

					// 5) 수리 가능 분야
					if (form.querySelectorAll('input[name=categoryCodes]:checked').length === 0) {
						add('need', '수리 가능 분야를 최소 1개 선택해주세요.',
							form.querySelector('input[name=categoryCodes]'));
					}

					// 6) 자격증
					// 자격증명이 적힌 줄만 한 건으로 센다 — 서버 saveLicenses() 와 같은 규칙이다.
					var names = form.querySelectorAll('input[name=licenseNames]');
					var dates = form.querySelectorAll('input[name=licenseIssuedAts]');
					var files = form.querySelectorAll('input[name=licenseFiles]');

					var filled = 0;
					var today  = new Date();
					today.setHours(0, 0, 0, 0);

					for (var i = 0; i < names.length; i++) {
						var nm   = (names[i].value || '').trim();
						var dEl  = dates[i];
						var fEl  = files[i];
						var file = fileOf(fEl);
						var no   = (i + 1);

						if (nm === '') {
							// 이름 없이 날짜나 파일만 넣으면 서버가 그 줄을 통째로 건너뛴다.
							// 조용히 버려지면 사용자는 저장된 줄 알기 때문에 미리 알려준다.
							if ((dEl && dEl.value) || file) {
								add('need', '자격증 ' + no + ' : 자격증명을 입력하지 않으면 저장되지 않습니다.', names[i]);
							}
							continue;
						}
						filled++;

						// 발급일 : "2023-13-45" 같은 값을 넣으면 브라우저가 값을 비우고
						// validity.badInput 을 세운다. value 만 보면 "안 적었다" 와 구별이 안 된다.
						if (dEl && dEl.validity && dEl.validity.badInput) {
							add('need', '자격증 ' + no + ' : 발급일이 올바르지 않습니다. 달력에서 다시 골라주세요.', dEl);
						} else if (dEl && dEl.value) {
							var d = new Date(dEl.value);
							if (isNaN(d.getTime())) {
								add('need', '자격증 ' + no + ' : 발급일 형식이 올바르지 않습니다.', dEl);
							} else if (d > today) {
								add('need', '자격증 ' + no + ' : 발급일이 오늘 이후입니다. 다시 확인해주세요.', dEl);
							}
						}

						if (file) {
							if (LICENSE_EXT.indexOf(extOf(file.name)) < 0) {
								add('file', '자격증 ' + no + ' : 증빙파일은 jpg, png, pdf 만 올릴 수 있습니다. (선택한 파일: '
									+ esc(file.name) + ')', fEl);
							} else if (file.size > MAX_BYTES) {
								add('file', '자격증 ' + no + ' : 증빙파일이 ' + MAX_MB + 'MB를 넘습니다. ('
									+ mb(file.size) + ')', fEl);
							}
						}
					}

					if (filled === 0) {
						add('need', '자격증을 최소 1개 입력해주세요. (자격증명을 적은 칸만 저장됩니다)',
							names.length ? names[0] : null);
					}

					return { list: list, firstBad: firstBad };
				}

				// ---------- 화면 표시 ----------

				function render(result, onlyFile) {
					if (!box || !text) return;

					var shown = [];
					for (var i = 0; i < result.list.length; i++) {
						if (!onlyFile || result.list[i].kind === 'file') {
							shown.push(result.list[i].msg);
						}
					}

					if (shown.length === 0) {
						box.style.display = 'none';
						return false;
					}

					var html = '<b>아래 항목을 확인해주세요.</b><br>';
					for (var j = 0; j < shown.length; j++) {
						html += '· ' + shown[j] + '<br>';
					}
					html += '<span class="muted">입력하신 내용은 그대로 남아 있습니다. 해당 항목만 고쳐서 다시 눌러주세요.</span>';

					text.innerHTML = html;
					box.style.display = '';
					return true;
				}

				// 값이 바뀌면 즉시 다시 검사한다. 제출까지 기다리게 하지 않는다.
				form.addEventListener('change', function (e) {
					var t = e.target;
					if (!t) return;
					if (t.type === 'file' || t.type === 'checkbox' || t.type === 'date' || t.type === 'number') {
						render(collect(), !tried);
					}
				});

				form.addEventListener('input', function (e) {
					if (tried && e.target && e.target.type === 'text') render(collect(), false);
				});

				form.addEventListener('submit', function (e) {
					tried = true;

					var result = collect();
					if (result.list.length === 0) {
						if (box) box.style.display = 'none';
						return;                       // 통과 — 서버로 보낸다
					}

					// 여기서 멈추므로 화면이 새로 그려지지 않는다 → 입력값이 그대로 남는다
					e.preventDefault();

					render(result, false);
					if (box) box.scrollIntoView({ behavior: 'smooth', block: 'center' });

					if (result.firstBad && result.firstBad.focus) {
						try { result.firstBad.focus({ preventScroll: true }); } catch (err) { /* 무시 */ }
					}
				});
			})();
			</script>
					</c:otherwise>
				</c:choose>
			</div>
		</div>
	</div>
</main>

<jsp:include page="/WEB-INF/views/common/footer.jsp"/>
<script src="${pageContext.request.contextPath}/js/common.js"></script>
</body>
</html>