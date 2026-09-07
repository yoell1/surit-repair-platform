<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../common/admin-header.jsp" %>

<style>
	/* 표 안에 폼이 들어가는 화면이라 여기서만 쓰는 보정 */
	.blk-kpis      { margin-bottom: 8px; }
	.blk-sec       { margin-top: 44px; }
	.blk-sec--first{ margin-top: 28px; }

	.blk-form      { display:flex; gap:6px; align-items:center; flex-wrap:nowrap; }
	.blk-form .input { height:34px; padding:6px 10px; font-size:13px; margin:0; }
	.blk-form select.input { width:106px; flex:0 0 auto; }
	.blk-form input.input  { flex:1 1 auto; min-width:160px; }
	.blk-form .btn { flex:0 0 auto; }

	.tbl th, .tbl td { vertical-align: middle; }
	.blk-nowrap    { white-space: nowrap; }
	.blk-col-act   { width: 400px; }
	.blk-col-sm    { width: 90px; }

	.blk-empty     { padding: 24px 0; }
</style>

<div class="container container--wide">

	<div class="page-head">
		<h1>블랙리스트 관리</h1>
		<p class="muted">
			경고 ${threshold}회 이상 누적된 회원을 확인하고, 관리자가 직접 정지 여부를 판단합니다.
			자동 정지는 하지 않습니다.
		</p>
	</div>

	<div class="kpis blk-kpis">
		<div class="kpi kpi--accent">
			<div class="kpi__label">정지 검토 대상</div>
			<div class="kpi__value">${fn:length(warnTargets)}</div>
		</div>
		<div class="kpi kpi--blue">
			<div class="kpi__label">현재 정지 중</div>
			<div class="kpi__value">${fn:length(actives)}</div>
		</div>
		<div class="kpi kpi--ok">
			<div class="kpi__label">제재 이력</div>
			<div class="kpi__value">${fn:length(history)}</div>
		</div>
	</div>

	<%-- ═══════ 1. 경고 누적 대상 ═══════ --%>

	<div class="sec-head sec-head--row blk-sec blk-sec--first">
		<h2>경고 ${threshold}회 이상</h2>
		<span class="muted">사유 입력은 필수입니다</span>
	</div>

	<c:if test="${empty warnTargets}">
		<p class="empty blk-empty">경고가 ${threshold}회 이상 누적된 회원이 없습니다.</p>
	</c:if>

	<c:if test="${not empty warnTargets}">
	<table class="tbl">
		<thead>
			<tr>
				<th class="num blk-col-sm">회원번호</th>
				<th>이름</th>
				<th class="blk-col-sm">구분</th>
				<th class="center blk-col-sm">경고</th>
				<th class="blk-nowrap">최근 경고</th>
				<th class="center blk-col-sm">상태</th>
				<th class="blk-col-act">정지 처리</th>
			</tr>
		</thead>
		<tbody>
			<c:forEach var="w" items="${warnTargets}">
				<c:set var="stCls" value="${w.status eq 'SUSPEND' ? 'badge--danger' : (w.status eq 'LEAVED' ? 'badge--gray' : 'badge--ok')}" />
				<c:set var="stTxt" value="${w.status eq 'SUSPEND' ? '정지중' : (w.status eq 'LEAVED' ? '탈퇴' : '정상')}" />
				<tr>
					<td class="num">${w.userNo}</td>
					<td class="blk-nowrap"><c:out value="${w.name}" /> <span class="muted"><c:out value="${w.userId}" /></span></td>
					<td><span class="badge badge--gray">${w.userRole eq 'FIXER' ? '기사' : '일반'}</span></td>
					<td class="center"><span class="badge badge--danger">${w.warnCount}회</span></td>
					<td class="blk-nowrap"><c:out value="${w.lastWarnAt}" /></td>
					<td class="center"><span class="badge ${stCls}">${stTxt}</span></td>
					<td>
						<c:if test="${w.status eq 'ACTIVE'}">
							<form method="post" action="/admin/blacklist/suspend" class="blk-form">
								<input type="hidden" name="targetNo" value="${w.userNo}" />
								<select name="days" class="input">
									<option value="3">3일</option>
									<option value="7" selected>7일</option>
									<option value="30">30일</option>
									<option value="0">영구</option>
								</select>
								<input type="text" name="reason" class="input" placeholder="정지 사유 (필수)" maxlength="500" required />
								<button type="submit" class="btn btn--danger btn--sm">정지</button>
							</form>
						</c:if>
						<c:if test="${w.status ne 'ACTIVE'}">
							<span class="muted">처리 불가</span>
						</c:if>
					</td>
				</tr>
			</c:forEach>
		</tbody>
	</table>
	</c:if>

	<%-- ═══════ 2. 현재 정지 중 ═══════ --%>

	<div class="sec-head sec-head--row blk-sec">
		<h2>현재 정지 중</h2>
		<span class="muted">기간이 끝나면 1시간 이내에 자동 해제됩니다</span>
	</div>

	<c:if test="${empty actives}">
		<p class="empty blk-empty">현재 정지 중인 계정이 없습니다.</p>
	</c:if>

	<c:if test="${not empty actives}">
	<table class="tbl">
		<thead>
			<tr>
				<th class="num blk-col-sm">번호</th>
				<th>대상</th>
				<th class="blk-col-sm">유형</th>
				<th class="ttl">사유</th>
				<th class="blk-nowrap">시작</th>
				<th class="blk-nowrap">종료</th>
				<th class="center blk-col-sm">남은 기간</th>
				<th>처리자</th>
				<th class="center blk-col-sm">해제</th>
			</tr>
		</thead>
		<tbody>
			<c:forEach var="s" items="${actives}">
				<c:set var="tyTxt" value="${s.sanctionType eq 'PERMANENT' ? '영구' : '기간'}" />
				<c:set var="tyCls" value="${s.sanctionType eq 'PERMANENT' ? 'badge--danger badge--solid' : 'badge--warn'}" />
				<tr>
					<td class="num">${s.sanctionId}</td>
					<td class="blk-nowrap"><c:out value="${s.targetName}" /> <span class="muted">${s.userRole eq 'FIXER' ? '기사' : '일반'}</span></td>
					<td><span class="badge ${tyCls}">${tyTxt}</span></td>
					<td class="ttl"><c:out value="${s.sanctionReason}" /></td>
					<td class="blk-nowrap"><c:out value="${s.startAt}" /></td>
					<td class="blk-nowrap">${empty s.endAt ? '-' : s.endAt}</td>
					<td class="center">${empty s.daysLeft ? '-' : s.daysLeft}</td>
					<td><c:out value="${s.adminId}" /></td>
					<td class="center">
						<form method="post" action="/admin/blacklist/release" onsubmit="return confirm('이 제재를 해제할까요?');">
							<input type="hidden" name="sanctionId" value="${s.sanctionId}" />
							<button type="submit" class="btn btn--ghost btn--sm">해제</button>
						</form>
					</td>
				</tr>
			</c:forEach>
		</tbody>
	</table>
	</c:if>

	<%-- ═══════ 3. 제재 이력 ═══════ --%>

	<div class="sec-head sec-head--row blk-sec">
		<h2>제재 이력</h2>
		<span class="muted">경고·정지·해제 전체 기록 (최근 100건)</span>
	</div>

	<c:if test="${empty history}">
		<p class="empty blk-empty">제재 이력이 없습니다.</p>
	</c:if>

	<c:if test="${not empty history}">
	<table class="tbl">
		<thead>
			<tr>
				<th class="num blk-col-sm">번호</th>
				<th>대상</th>
				<th class="blk-col-sm">유형</th>
				<th class="ttl">사유</th>
				<th class="blk-nowrap">시작</th>
				<th class="blk-nowrap">종료</th>
				<th class="blk-nowrap">해제</th>
				<th class="center blk-col-sm">상태</th>
				<th>처리자</th>
			</tr>
		</thead>
		<tbody>
			<c:forEach var="s" items="${history}">
				<c:set var="hTxt" value="${s.sanctionType eq 'WARNING' ? '경고' : (s.sanctionType eq 'PERMANENT' ? '영구정지' : '정지')}" />
				<c:set var="hCls" value="${s.sanctionType eq 'WARNING' ? 'badge--warn' : 'badge--danger'}" />
				<c:set var="rTxt" value="${not empty s.releasedAt ? '해제됨' : (s.sanctionType eq 'WARNING' ? '기록' : '유효')}" />
				<c:set var="rCls" value="${not empty s.releasedAt ? 'badge--gray' : (s.sanctionType eq 'WARNING' ? 'badge--gray' : 'badge--primary')}" />
				<tr>
					<td class="num">${s.sanctionId}</td>
					<td class="blk-nowrap"><c:out value="${s.targetName}" /></td>
					<td><span class="badge ${hCls}">${hTxt}</span></td>
					<td class="ttl"><c:out value="${s.sanctionReason}" /></td>
					<td class="blk-nowrap"><c:out value="${s.startAt}" /></td>
					<td class="blk-nowrap">${empty s.endAt ? '-' : s.endAt}</td>
					<td class="blk-nowrap">${empty s.releasedAt ? '-' : s.releasedAt}</td>
					<td class="center"><span class="badge ${rCls}">${rTxt}</span></td>
					<td><c:out value="${s.adminId}" /></td>
				</tr>
			</c:forEach>
		</tbody>
	</table>
	</c:if>

</div>

<%@ include file="../common/admin-footer.jsp" %>