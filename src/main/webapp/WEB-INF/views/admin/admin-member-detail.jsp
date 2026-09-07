<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../common/admin-header.jsp" %>

<div class="container">

  <div class="page-head" style="display:flex;justify-content:space-between;align-items:center">
    <h1><c:out value="${fixer.name}"/>
      <c:choose>
        <c:when test="${fixer.userRole eq 'FIXER'}">
          <span class="badge badge--primary">기사</span>
        </c:when>
        <c:otherwise>
          <span class="badge badge--gray">회원</span>
        </c:otherwise>
      </c:choose>
      <c:if test="${fixer.approvalStatus eq 'PENDING'}">
        <span class="badge badge--warn">승인 대기</span>
      </c:if>
      <c:if test="${fixer.approvalStatus eq 'APPROVED'}">
        <span class="badge badge--ok">승인 완료</span>
      </c:if>
      <c:if test="${fixer.approvalStatus eq 'REJECTED'}">
        <span class="badge badge--danger">반려</span>
      </c:if>
    </h1>
    <a class="btn btn--ghost btn--sm"
       href="${pageContext.request.contextPath}/admin/members">목록으로</a>
  </div>

  <%-- ===== 기본 정보 ===== --%>
  <div class="sec-head"><h2>기본 정보</h2></div>
  <div class="card card--sm" style="margin-bottom:32px">
    <table class="tbl">
      <tr><th style="width:140px">아이디</th><td><c:out value="${fixer.userId}"/></td></tr>
      <tr><th>이름</th><td><c:out value="${fixer.name}"/></td></tr>
      <tr><th>전화번호</th><td><c:out value="${fixer.phone}"/></td></tr>
      <tr><th>이메일</th><td><c:out value="${fixer.email}"/></td></tr>
      <tr><th>계정 상태</th>
        <td>
          <c:choose>
            <c:when test="${fixer.status eq 'ACTIVE'}"><span class="badge badge--gray">정상</span></c:when>
            <c:when test="${fixer.status eq 'SUSPENDED'}"><span class="badge badge--warn">정지</span></c:when>
            <c:otherwise><span class="badge badge--danger">차단</span></c:otherwise>
          </c:choose>
        </td>
      </tr>
      <tr><th>가입일</th><td>${fn:substring(fixer.createdAt, 0, 10)}</td></tr>
    </table>
  </div>

  <%-- ===== 기사일 때만 ===== --%>
  <c:if test="${fixer.userRole eq 'FIXER'}">

    <%-- 기사 소개 --%>
    <div class="sec-head"><h2>기사 정보</h2></div>
    <div class="card card--sm" style="margin-bottom:32px">
      <table class="tbl">
        <tr><th style="width:140px">경력</th><td>${fixer.careerYears}년</td></tr>
        <tr><th>소개</th><td><c:out value="${fixer.intro}"/></td></tr>
      </table>
    </div>

    <%-- 자격증 --%>
    <div class="sec-head"><h2>제출한 자격증 ${fn:length(fixer.licenses)}건</h2></div>
    <div class="card card--sm" style="margin-bottom:32px">
      <c:forEach var="lic" items="${fixer.licenses}">
        <div class="list-card">
          <div class="list-card__body">
            <b><c:out value="${lic.licenseName}"/></b>
            <div class="muted" style="font-size:14.5px;margin-top:4px">
              취득일 ${fn:substring(lic.issuedAt, 0, 10)}
            </div>
          </div>
          <div class="btn-row">
            <a class="btn btn--ghost btn--sm" href="${fn:escapeXml(lic.uploadUrl)}" target="_blank" rel="noopener noreferrer">원본 보기</a>
          </div>
        </div>
      </c:forEach>
      <c:if test="${empty fixer.licenses}">
        <div style="text-align:center;padding:30px" class="muted">제출된 자격증이 없습니다.</div>
      </c:if>
    </div>

    <%-- 카테고리 · 지역 --%>
    <div class="sec-head"><h2>신청한 수리 정보</h2></div>
    <div class="card card--sm" style="margin-bottom:32px">
      <table class="tbl">
        <tr>
          <th style="width:140px">수리 가능 카테고리</th>
          <td>
            <c:forEach var="cat" items="${fixer.categories}">
              <span class="badge badge--gray"><c:out value="${cat}"/></span>
            </c:forEach>
            <c:if test="${empty fixer.categories}"><span class="muted">-</span></c:if>
          </td>
        </tr>
        <tr>
          <th>활동 가능 지역</th>
          <td>
            <c:forEach var="rg" items="${fixer.regions}">
              <span class="badge badge--gray"><c:out value="${rg}"/></span>
            </c:forEach>
            <c:if test="${empty fixer.regions}"><span class="muted">-</span></c:if>
          </td>
        </tr>
      </table>
    </div>

    <%--
      ===== 심사 처리 =====

      approvalStatus 가 비어(null) 있다 = FIXER_PROFILE 행이 아예 없다
      = 기사로 가입만 하고 /fixer/verify 에서 서류를 아직 안 냈다는 뜻이다.

      이때 승인 버튼을 보여주면 안 된다.
      눌러도 서비스가 "제출된 자격증이 없습니다" 로 막을 뿐이고,
      관리자는 "왜 승인이 안 되지?" 하고 헤매게 된다.
      심사할 서류가 없다는 사실을 화면에서 바로 알려주는 게 맞다.
    --%>
    <c:choose>

    <%-- ① 서류 미제출 : 안내만 보여주고 버튼은 아예 안 만든다 --%>
    <c:when test="${empty fixer.approvalStatus}">
      <div class="sec-head"><h2>심사 처리</h2></div>
      <div class="card card--sm" style="margin-bottom:32px;padding:32px;text-align:center">
        <b style="font-size:18px">아직 서류를 제출하지 않았습니다</b>
        <p class="muted" style="margin-top:10px;line-height:1.7">
          기사로 가입만 한 상태입니다. 심사할 자격증·수리 분야·활동 지역이 없어서
          승인하거나 반려할 수 없습니다.<br>
          본인이 <b>[마이페이지 &gt; 기사로 전환]</b> 에서 서류를 제출하면
          <b>기사 가입 승인 대기</b> 목록에 올라옵니다.
        </p>
      </div>
    </c:when>

    <%-- ② 서류를 냈고 아직 승인 전 : 승인 / 반려 처리 --%>
    <c:when test="${fixer.approvalStatus ne 'APPROVED'}">
      <div class="sec-head"><h2>심사 처리</h2></div>
      <div class="card card--sm" style="margin-bottom:32px">

        <c:if test="${not empty fixer.rejectReason}">
          <div class="alert" style="margin-bottom:16px">
            <b>이전 반려 사유</b><br><c:out value="${fixer.rejectReason}"/>
          </div>
        </c:if>

        <form method="post"
              action="${pageContext.request.contextPath}/admin/members/${fixer.userNo}/reject">
          <label><b>반려 사유</b> <span class="muted">(반려할 때만 입력)</span></label>
          <textarea name="reason" class="textarea" style="min-height:110px;width:100%;margin-top:8px"
                    placeholder="예) 자격증 사진의 발급번호가 보이지 않습니다. 다시 촬영해 제출해 주세요."></textarea>
          <p class="muted" style="font-size:14px;margin-top:6px">
            입력한 사유는 기사님의 [기사 인증] 화면에 그대로 표시되고, 재제출할 수 있습니다.
          </p>
          <div class="btn-row" style="margin-top:16px">
            <button type="submit" class="btn btn--danger">반려</button>
          </div>
        </form>

        <hr style="margin:20px 0">

        <form method="post"
              action="${pageContext.request.contextPath}/admin/members/${fixer.userNo}/approve">
          <p class="muted" style="font-size:14px">
            승인하면 <b>APPROVAL_STATUS = APPROVED</b> 로 바뀌어 접수 찾기와 견적 제출이 열립니다.
          </p>
          <div class="btn-row" style="margin-top:12px">
            <button type="submit" class="btn btn--ok">기사 승인</button>
          </div>
        </form>

      </div>
    </c:when>

    </c:choose>

  </c:if>

</div>

<%@ include file="../common/admin-footer.jsp" %>