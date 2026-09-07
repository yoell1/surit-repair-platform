<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"  uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!doctype html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>채팅 | 수릿 Surit</title>
<link rel="stylesheet" href="/css/style.css">
<link rel="stylesheet" href="/css/pages.css">
<style>
/* ══════════════════════════════════════════════════
   채팅 화면 전용 스타일.
   다른 페이지와 겹치지 않게 클래스 앞에 cx- 를 붙였다.
   ══════════════════════════════════════════════════ */

.cx-wrap      { display:grid; grid-template-columns:340px 1fr; gap:24px;
                align-items:start; }
/* 왼쪽 목록이 없는 화면(관리자 문의응대)에서는 한 칸짜리로 --*/
.cx-wrap--solo{ grid-template-columns:1fr; max-width:820px; margin:0 auto; }

/* 뒤로가기 줄 (관리자 화면처럼 헤더 메뉴가 없는 곳에서 길을 잃지 않게) */
.cx-back      { margin-bottom:16px; }
.cx-back a    { display:inline-flex; align-items:center; gap:6px;
                font-size:14px; color:#4B5563; text-decoration:none;
                padding:8px 14px; border:1px solid #E5E7EB; border-radius:10px;
                background:#fff; }
.cx-back a:hover { background:#F9FAFB; color:#111827; }
.cx-back svg  { width:16px; height:16px; stroke:currentColor; fill:none;
                stroke-width:2; stroke-linecap:round; stroke-linejoin:round; }

/* ── 왼쪽 : 채팅방 목록 ── */
.cx-side      { border:1px solid #E5E7EB; border-radius:16px; overflow:hidden;
                background:#fff; }

.cx-side__top { display:flex; gap:14px; align-items:center; padding:20px;
                background:#EEF4FF; text-decoration:none; color:inherit; }
.cx-side__top:hover { background:#E4EDFF; }
.cx-side__top .ic   { flex:none; width:44px; height:44px; border-radius:12px;
                      background:#2F6BFF; display:flex; align-items:center;
                      justify-content:center; }
.cx-side__top .ic svg { width:22px; height:22px; stroke:#fff; fill:none;
                        stroke-width:2; stroke-linecap:round; stroke-linejoin:round; }
.cx-side__top b     { display:block; font-size:16px; }
.cx-side__top span  { display:block; font-size:13px; color:#6B7280; margin-top:3px; }

.cx-item      { display:flex; gap:12px; padding:16px 20px; text-decoration:none;
                color:inherit; border-top:1px solid #F1F3F5; }
.cx-item:hover      { background:#F9FAFB; }
.cx-item.is-active  { background:#F5F8FF; box-shadow:inset 3px 0 0 #2F6BFF; }

.cx-avatar    { flex:none; width:40px; height:40px; border-radius:50%;
                background:#EEF2F7; display:flex; align-items:center;
                justify-content:center; }
.cx-avatar svg{ width:20px; height:20px; stroke:#8A94A6; fill:none; stroke-width:2; }

.cx-item__body { flex:1; min-width:0; }
.cx-item__row  { display:flex; align-items:center; gap:8px; }
.cx-item__name { font-weight:700; font-size:15px; flex:1; min-width:0;
                 overflow:hidden; text-overflow:ellipsis; white-space:nowrap; }
.cx-item__time { flex:none; font-size:12px; color:#9CA3AF; }
.cx-item__sub  { font-size:12.5px; color:#9CA3AF; margin-top:3px;
                 overflow:hidden; text-overflow:ellipsis; white-space:nowrap; }
.cx-item__last { font-size:13.5px; color:#4B5563; margin-top:6px;
                 overflow:hidden; text-overflow:ellipsis; white-space:nowrap; }

.cx-badge     { flex:none; min-width:20px; height:20px; padding:0 6px;
                border-radius:10px; background:#FF7A1A; color:#fff;
                font-size:11px; font-weight:700; line-height:20px;
                text-align:center; }

.cx-empty     { padding:40px 20px; text-align:center; color:#9CA3AF;
                font-size:14px; border-top:1px solid #F1F3F5; }

/* ── 오른쪽 : 대화창 ── */
.cx-main      { border:1px solid #E5E7EB; border-radius:16px; background:#fff;
                overflow:hidden; display:flex; flex-direction:column; }

.cx-head      { display:flex; align-items:center; gap:14px; padding:18px 22px;
                border-bottom:1px solid #EEF0F3; }
.cx-head__ttl { font-size:17px; font-weight:800; margin:0; }
.cx-head__sub { font-size:13px; color:#9CA3AF; margin-top:3px; }
.cx-head__right { margin-left:auto; display:flex; gap:8px; align-items:center; }

.cx-body      { height:56vh; min-height:380px; overflow-y:auto; padding:22px; }

/* 날짜 구분선 */
.cx-date      { text-align:center; margin:6px 0 20px; }
.cx-date span { display:inline-block; font-size:12.5px; color:#9CA3AF; }

/* 말풍선 한 줄 */
.cx-msg       { display:flex; gap:10px; margin-bottom:18px; align-items:flex-end; }
.cx-msg__box  { max-width:66%; }
.cx-msg__who  { font-size:12px; color:#9CA3AF; margin-bottom:5px; }
.cx-bubble    { padding:12px 16px; border-radius:14px; line-height:1.55;
                font-size:14.5px; word-break:break-word; white-space:pre-wrap;
                background:#F1F5F9; color:#111827; }
.cx-msg__time { font-size:11.5px; color:#9CA3AF; flex:none; padding-bottom:2px; }

/* 내가 보낸 것은 오른쪽 정렬 + 파란 말풍선 */
.cx-msg.mine           { flex-direction:row-reverse; }
.cx-msg.mine .cx-bubble{ background:#2F6BFF; color:#fff; }
.cx-msg.mine .cx-msg__who { text-align:right; }

.cx-foot      { display:flex; gap:10px; padding:16px 22px;
                border-top:1px solid #EEF0F3; }
.cx-foot input{ flex:1; }

/* 화면이 좁아지면 목록을 위로 내린다 */
@media (max-width: 960px) {
	.cx-wrap { grid-template-columns:1fr; }
	.cx-body { height:50vh; }
}
</style>
</head>
<body>

	<%-- 헤더는 화면 주인에 맞춰 고른다.
	     관리자 문의응대(adminView)면 관리자 헤더, 아니면 고객·기사용 헤더.
	     둘 다 마지막에 <main> 을 열어두므로 푸터에서 </main> 으로 닫아야 한다. --%>
	<c:choose>
		<c:when test="${adminView}">
			<jsp:include page="/WEB-INF/views/common/admin-header.jsp" />
		</c:when>
		<c:otherwise>
			<jsp:include page="/WEB-INF/views/common/header.jsp" />
		</c:otherwise>
	</c:choose>

<div class="container">

	<c:choose>
		<c:when test="${adminView}">
			<div class="page-head">
				<h1>문의 응대</h1>
				<p>고객이 보낸 1:1 문의입니다. 답변을 남기면 고객 화면에 바로 표시됩니다.</p>
			</div>
		</c:when>
		<c:otherwise>
			<div class="page-head">
				<h1>채팅</h1>
				<p>수리 전후 궁금한 점을 여기서 물어보세요. 전화번호는 서로에게 공개되지 않습니다.</p>
			</div>
		</c:otherwise>
	</c:choose>

<c:set var="hasSide" value="${not empty sideRooms or not empty showSide}"/>

<%-- ══════════ 돌아가기 ══════════
     관리자 문의응대 화면에는 고객용 헤더가 없어서
     이 버튼이 없으면 뒤로가기 말고는 나갈 길이 없다. --%>
<c:if test="${not empty backUrl}">
	<div class="cx-back">
		<a href="${fn:escapeXml(backUrl)}">
			<svg viewBox="0 0 24 24"><path d="M15 18l-6-6 6-6"/></svg>
			<c:out value="${empty backText ? '목록으로 돌아가기' : backText}"/>
		</a>
	</div>
</c:if>

<div class="cx-wrap ${hasSide ? '' : 'cx-wrap--solo'}">

	<%-- ══════════ 왼쪽 : 채팅방 목록 ══════════
	     sideRooms 를 안 넘겨준 화면(관리자 등)에서는 목록 자체를 그리지 않는다. --%>
	<c:if test="${hasSide}">
	<aside class="cx-side">

		<%-- 고객센터 1:1 문의 바로가기 --%>
		<a class="cx-side__top" href="/user/mypage/support">
			<span class="ic">
				<svg viewBox="0 0 24 24"><path d="M4 6.5A2.5 2.5 0 0 1 6.5 4h11A2.5 2.5 0 0 1 20 6.5v8a2.5 2.5 0 0 1-2.5 2.5H9.5L4 21.5z"/></svg>
			</span>
			<span>
				<b>수릿 문의하기</b>
				<span>서비스 이용 중 궁금한 점을 물어보세요</span>
			</span>
		</a>

		<c:choose>
			<c:when test="${empty sideRooms}">
				<div class="cx-empty">아직 대화 중인 채팅이 없습니다.</div>
			</c:when>
			<c:otherwise>
				<c:forEach var="r" items="${sideRooms}">

					<%-- REQUEST_ID 가 있으면 기사와의 접수 채팅, 없으면 고객센터 문의방 --%>
					<c:set var="isSupport" value="${empty r.requestId}"/>
					<c:choose>
						<c:when test="${isSupport}">
							<c:set var="href" value="/user/mypage/support/${r.roomId}"/>
						</c:when>
						<c:otherwise>
							<c:set var="href" value="/orders/${r.requestId}/chat"/>
						</c:otherwise>
					</c:choose>

					<a class="cx-item ${r.roomId eq room.roomId ? 'is-active' : ''}"
					   href="${href}">

						<span class="cx-avatar">
							<svg viewBox="0 0 24 24"><circle cx="12" cy="8" r="4"/><path d="M4.5 20.5a7.5 7.5 0 0 1 15 0"/></svg>
						</span>

						<span class="cx-item__body">
							<span class="cx-item__row">
								<span class="cx-item__name">
									<c:choose>
										<c:when test="${isSupport}">수릿 고객센터</c:when>
										<c:when test="${myNo eq r.userNo}"><c:out value="${r.fixerName}"/> 기사님</c:when>
										<c:otherwise><c:out value="${r.userName}"/> 고객님</c:otherwise>
									</c:choose>
								</span>
								<span class="cx-item__time"><c:out value="${r.createdAt}"/></span>
								<c:if test="${r.unreadCount > 0}">
									<span class="cx-badge">${r.unreadCount}</span>
								</c:if>
							</span>

							<span class="cx-item__sub">
								<c:out value="${isSupport ? '1:1 문의' : r.requestTitle}"/>
							</span>

							<%-- ★ lastMessage 는 복호화된 평문. 반드시 c:out (XSS 방지) --%>
							<span class="cx-item__last">
								<c:out value="${empty r.lastMessage ? '아직 대화가 없습니다.' : r.lastMessage}"/>
							</span>
						</span>
					</a>
				</c:forEach>
			</c:otherwise>
		</c:choose>
	</aside>
	</c:if>


	<%-- ══════════ 오른쪽 : 대화창 ══════════ --%>
	<section class="cx-main">
	<c:choose>

		<%-- 방이 없거나 권한이 없을 때 : 이유를 그대로 보여준다 --%>
		<c:when test="${empty room}">
			<div style="padding:60px 24px;text-align:center">
				<p class="muted" style="font-size:15px"><c:out value="${msg}"/></p>
				<c:if test="${not empty backUrl}">
					<a class="btn btn--ghost" style="margin-top:18px"
					   href="${fn:escapeXml(backUrl)}">목록으로</a>
				</c:if>
			</div>
		</c:when>

		<c:otherwise>

			<div class="cx-head">
				<span class="cx-avatar">
					<svg viewBox="0 0 24 24"><circle cx="12" cy="8" r="4"/><path d="M4.5 20.5a7.5 7.5 0 0 1 15 0"/></svg>
				</span>
				<div>
					<h2 class="cx-head__ttl">
						<c:choose>
							<c:when test="${not empty roomTitle}"><c:out value="${roomTitle}"/></c:when>
							<c:when test="${myNo == room.userNo}"><c:out value="${room.fixerName}"/> 기사님</c:when>
							<c:otherwise><c:out value="${room.userName}"/> 고객님</c:otherwise>
						</c:choose>
					</h2>
					<div class="cx-head__sub">
						<c:out value="${empty roomSub ? room.requestTitle : roomSub}"/>
					</div>
				</div>

				<div class="cx-head__right">
					<%-- 접수 채팅방일 때만 접수 상세로 갈 수 있다 --%>
					<c:if test="${not empty room.requestId}">
						<a class="btn btn--ghost btn--sm"
						   href="/request/${room.requestId}">접수 상세</a>
					</c:if>
					<span class="badge badge--gray" id="connState">연결 중…</span>
				</div>
			</div>

			<div class="cx-body" id="chatBody">
				<%-- 날짜가 바뀌는 지점마다 구분선을 넣는다.
				     sentAt 은 "MM-dd HH:mm" 형태라 앞 5글자가 날짜다. --%>
				<c:set var="prevDate" value=""/>
				<c:forEach var="m" items="${history}">

					<c:set var="curDate" value="${fn:substring(m.sentAt, 0, 5)}"/>
					<c:if test="${curDate ne prevDate}">
						<div class="cx-date">
							<span>${fn:substring(curDate,0,2)}월 ${fn:substring(curDate,3,5)}일</span>
						</div>
						<c:set var="prevDate" value="${curDate}"/>
					</c:if>

					<div class="cx-msg ${m.senderNo == myNo ? 'mine' : ''}">
						<c:if test="${m.senderNo != myNo}">
							<span class="cx-avatar" style="width:34px;height:34px">
								<svg viewBox="0 0 24 24"><circle cx="12" cy="8" r="4"/><path d="M4.5 20.5a7.5 7.5 0 0 1 15 0"/></svg>
							</span>
						</c:if>
						<div class="cx-msg__box">
							<div class="cx-msg__who"><c:out value="${m.senderName}"/></div>
							<%-- ★ ${m.content} 로 쓰면 XSS 로 뚫린다. 반드시 c:out --%>
							<div class="cx-bubble"><c:out value="${m.content}"/></div>
						</div>
						<span class="cx-msg__time"><c:out value="${fn:substring(m.sentAt, 6, 11)}"/></span>
					</div>
				</c:forEach>
			</div>

			<div class="cx-foot">
				<input type="text" id="msgInput" class="input"
				       placeholder="메시지를 입력하세요" maxlength="988" autocomplete="off">
				<button type="button" id="sendBtn" class="btn btn--primary">전송</button>
			</div>

			<script src="https://cdn.jsdelivr.net/npm/sockjs-client@1.6.1/dist/sockjs.min.js"></script>
			<script src="https://cdn.jsdelivr.net/npm/stompjs@2.3.3/lib/stomp.min.js"></script>
			<script>
			(function () {

				var roomId = ${room.roomId};
				var myNo   = ${myNo};

				var body      = document.getElementById('chatBody');
				var input     = document.getElementById('msgInput');
				var sendBtn   = document.getElementById('sendBtn');
				var connState = document.getElementById('connState');

				var stomp = null;

				var AVATAR =
					'<svg viewBox="0 0 24 24"><circle cx="12" cy="8" r="4"/>' +
					'<path d="M4.5 20.5a7.5 7.5 0 0 1 15 0"/></svg>';

				// ★ innerHTML 로 남의 메시지를 넣으면 스크립트 태그가 그대로 실행된다.
				//   글자는 반드시 textContent 로만 넣는다.
				function appendMessage(m) {
					var mine = Number(m.senderNo) === myNo;

					var row = document.createElement('div');
					row.className = 'cx-msg' + (mine ? ' mine' : '');

					if (!mine) {
						var av = document.createElement('span');
						av.className = 'cx-avatar';
						av.style.width = '34px';
						av.style.height = '34px';
						av.innerHTML = AVATAR;          // 고정된 아이콘이라 안전
						row.appendChild(av);
					}

					var box = document.createElement('div');
					box.className = 'cx-msg__box';

					var who = document.createElement('div');
					who.className = 'cx-msg__who';
					who.textContent = m.senderName || '';

					var bubble = document.createElement('div');
					bubble.className = 'cx-bubble';
					bubble.textContent = m.content || '';

					box.appendChild(who);
					box.appendChild(bubble);
					row.appendChild(box);

					var time = document.createElement('span');
					time.className = 'cx-msg__time';
					time.textContent = (m.sentAt || '').substring(6);
					row.appendChild(time);

					body.appendChild(row);
					body.scrollTop = body.scrollHeight;
				}

				function setState(text, cls) {
					connState.textContent = text;
					connState.className = 'badge ' + cls;
				}

				function connect() {
					var sock = new SockJS('/ws-chat');
					stomp = Stomp.over(sock);
					stomp.debug = null;

					stomp.connect({},
						function () {
							setState('연결됨', 'badge--ok');
							stomp.subscribe('/sub/chat/room/' + roomId, function (frame) {
								appendMessage(JSON.parse(frame.body));
							});
						},
						function () {
							setState('재연결 중…', 'badge--warn');
							setTimeout(connect, 3000);
						}
					);
				}

				function send() {
					var text = input.value.trim();
					if (text === '')                { return; }
					if (!stomp || !stomp.connected) { return; }

					stomp.send('/pub/chat/' + roomId, {}, JSON.stringify({ content: text }));
					input.value = '';
					input.focus();
				}

				sendBtn.addEventListener('click', send);
				input.addEventListener('keydown', function (e) {
					if (e.key === 'Enter' && !e.shiftKey) {
						e.preventDefault();
						send();
					}
				});

				connect();
				body.scrollTop = body.scrollHeight;
			})();
			</script>

		</c:otherwise>
	</c:choose>
	</section>

</div>
</div>

<%-- 헤더와 짝을 맞춘다.
     admin-header.jsp / header.jsp 둘 다 마지막에 <main> 을 열어두므로
     반드시 짝이 되는 푸터가 </main> 으로 닫아줘야 한다. --%>
<c:choose>
	<c:when test="${adminView}">
		<jsp:include page="/WEB-INF/views/common/admin-footer.jsp" />
	</c:when>
	<c:otherwise>
		<jsp:include page="/WEB-INF/views/common/footer.jsp" />
	</c:otherwise>
</c:choose>

</body>
</html>
