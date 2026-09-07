<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<div class="container">
    <h2>차단 고객 관리</h2>
    <p style="color: gray;">기사님이 직접 차단한 고객 목록입니다. 차단을 해제하면 다시 매칭될 수 있습니다.</p>

    <hr>

    <!-- 1. 차단한 고객이 없을 때 -->
    <c:if test="${empty blockedList}">
        <div style="text-align: center; padding: 60px 0; color: #999;">
            <div style="font-size: 40px; margin-bottom: 15px;">🚫</div>
            <p>현재 차단한 고객이 없습니다.</p>
        </div>
    </c:if>

    <!-- 2. 차단 고객 리스트 -->
    <c:if test="${not empty blockedList}">
        <div class="blocked-list" style="display: flex; flex-direction: column; gap: 15px;">

            <c:forEach var="block" items="${blockedList}">
                <div class="blocked-card" style="display: flex; justify-content: space-between; align-items: center; padding: 20px; border: 1px solid #ddd; border-radius: 8px;">

                    <!-- 고객 정보 -->
                    <div>
                        <h4 style="margin: 0 0 5px 0; color: #333;">${block.customerName} 고객님</h4>
                        <span style="font-size: 13px; color: #777;">차단일: ${block.createdAt}</span>
                    </div>

                    <!-- 차단 해제 버튼 -->
                    <form id="unblockForm_${block.blockId}" action="/fixer/blocked/${block.blockId}/unblock" method="post" style="margin: 0;">
                        <button type="button" class="btn btn-outline-secondary btn-sm"
                                onclick="confirmUnblock('${block.blockId}', '${block.customerName}')">
                            차단 해제
                        </button>
                    </form>

                </div>
            </c:forEach>

        </div>
    </c:if>
</div>


<script>
    // 차단 해제 버튼 클릭
    function confirmUnblock(blockId, customerName) {

        // JS confirm 창으로 이름까지 넣어서 친절하게 물어봅니다.
        const isConfirmed = confirm(`[\${customerName}] 고객님의 차단을 정말 해제하시겠습니까?\n해제 시 접수 목록에 해당 고객의 요청이 다시 노출됩니다.`);

        if (isConfirmed) {
            // 동적으로 폼 ID를 찾아서 서버로 전송합니다.
            document.getElementById('unblockForm_' + blockId).submit();
        }
    }
</script>