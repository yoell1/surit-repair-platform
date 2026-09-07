<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<jsp:include page="/WEB-INF/views/common/header.jsp"/>

<div class="container" style="max-width:900px">
    <div class="page-head page-head--plain">
        <h1>수리 완료 처리</h1>
        <p>수리를 마치셨다면 여기에 현장 결제 내역을 남겨주세요.</p>
    </div>

    <!-- 진행 단계 (디자인 통일) -->
    <div style="margin-bottom:40px">
        <div class="steps">
            <div class="steps__item done"><div class="steps__dot"><svg><use href="#i-check"/></svg></div><div class="steps__label">접수 완료</div></div>
            <div class="steps__item done"><div class="steps__dot"><svg><use href="#i-check"/></svg></div><div class="steps__label">기사 매칭</div></div>
            <div class="steps__item done"><div class="steps__dot"><svg><use href="#i-check"/></svg></div><div class="steps__label">방문 · 수리</div></div>
            <div class="steps__item now"><div class="steps__dot">4</div><div class="steps__label">수리 완료</div></div>
        </div>
    </div>

    <form id="paymentForm" action="${pageContext.request.contextPath}/fixer/payment/complete" method="post" enctype="multipart/form-data">
        <input type="hidden" name="requestId" value="${booking.requestId}">

        <div class="card" style="border-color:var(--p-200)">
            <div class="card__head">
                <h2 class="card__title">현장 결제 · 최종 영수증</h2>
                <span class="muted" style="font-size:15px">접수번호 ${booking.requestId}</span>
            </div>

            <div class="note note--warn" style="margin-bottom:26px">
                <svg><use href="#i-alert"/></svg>
                <span>고객에게 보낸 <b>예상 견적과 금액이 달라졌다면</b> 반드시 사유를 설명하고 동의를 먼저 받아주세요.</span>
            </div>

            <!-- 수리 내역 입력 테이블 -->
            <table class="tbl" style="margin-bottom:12px;">
                <thead>
                <tr>
                    <th>수리 항목명</th>
                    <th style="width:100px" class="center">수량</th>
                    <th style="width:160px" class="right">단가 (원)</th>
                    <th style="width:180px" class="right">합계 (원)</th>
                    <th style="width:60px"></th>
                </tr>
                </thead>
                <tbody id="receiptBody">
                <tr class="receipt-row">
                    <td><input type="text" name="details[0].itemName" class="input" style="height:48px" placeholder="예: 부품 교체" required></td>
                    <td><input type="number" name="details[0].quantity" class="qty input" style="height:48px;text-align:center" value="1" min="1" onchange="calcTotal()"></td>
                    <td><input type="number" name="details[0].unitPrice" class="price input" style="height:48px;text-align:right" value="0" min="0" onchange="calcTotal()"></td>
                    <td class="row-total right" style="font-weight:700;font-size:17px;vertical-align:middle">0</td>
                    <td class="center"><button type="button" class="btn btn--ghost btn--sm" style="padding:0;width:40px;border:0" onclick="removeRow(this)"><svg class="ico"><use href="#i-trash"/></svg></button></td>
                </tr>
                </tbody>
            </table>

            <button type="button" class="btn btn--ghost btn--block" style="margin-bottom:26px" onclick="addRow()">
                <svg class="ico"><use href="#i-plus"/></svg>항목 추가
            </button>

            <!-- 총 결제 금액 계산 영역 -->
            <div style="display:flex;justify-content:space-between;align-items:center;padding:22px 0;border-top:2px solid var(--g-200);margin-bottom:26px">
                <span style="font-size:18px;font-weight:700">현장에서 받을 금액 (총액)</span>
                <span style="font-size:32px;font-weight:800;letter-spacing:-1.4px;color:var(--p-600)">
                    <span id="displayTotal">0</span>원
                </span>
                <input type="hidden" name="totalAmount" id="totalAmount" value="0">
            </div>

            <!-- 결제 수단 선택 -->
            <div class="field">
                <span class="field__label">결제 수단<span class="req">*</span></span>
                <div class="chip-row">
                    <!-- 라디오 버튼을 칩 UI 안에 숨겨서 연동 -->
                    <label class="check" style="margin:0"><input type="radio" name="paymentMethod" value="CARD" checked style="display:none"><span class="chip chip--on" onclick="selectPayMethod(this)">카드</span></label>
                    <label class="check" style="margin:0"><input type="radio" name="paymentMethod" value="CASH" style="display:none"><span class="chip" onclick="selectPayMethod(this)">현금</span></label>
                    <label class="check" style="margin:0"><input type="radio" name="paymentMethod" value="TRANSFER" style="display:none"><span class="chip" onclick="selectPayMethod(this)">계좌이체</span></label>
                </div>
                <div class="field__help">수릿은 결제를 대행하지 않습니다. 기록용 영수증으로만 발행됩니다.</div>
            </div>

            <!-- 수리 전/후 사진 -->
            <div class="field">
                <span class="field__label">수리 전 · 후 사진<span class="req">*</span></span>
                <div class="upload" style="margin-top:12px;gap:20px;">
                    <label class="upload__add" style="cursor:pointer">
                        <svg><use href="#i-camera"/></svg><span>수리 전 사진</span>
                        <input type="file" name="beforePhoto" accept="image/*" style="display:none;" required onchange="previewImg(this)">
                    </label>
                    <label class="upload__add" style="cursor:pointer">
                        <svg><use href="#i-camera"/></svg><span>수리 후 사진</span>
                        <input type="file" name="afterPhoto" accept="image/*" style="display:none;" required onchange="previewImg(this)">
                    </label>
                </div>
            </div>

            <div class="note note--gray" style="margin-bottom:22px">
                <svg><use href="#i-doc"/></svg>
                <span>보내면 <b>결제한 금액 그대로</b> 고객에게 영수증 겸 견적서로 발행되고 접수 상태가 <b>수리 완료</b>로 바뀝니다.</span>
            </div>

            <div class="btn-row">
                <a href="${pageContext.request.contextPath}/fixer/jobs/${booking.requestId}" class="btn btn--ghost btn--xl">취소</a>
                <button type="button" class="btn btn--primary btn--xl" style="flex:1" onclick="submitPayment()">
                    <svg class="ico"><use href="#i-send"/></svg>영수증 보내고 수리 완료
                </button>
            </div>
        </div>
    </form>
</div>

<script>
    let rowIndex = 1;

    function addRow() {
        const tbody = document.getElementById('receiptBody');
        const tr = document.createElement('tr');
        tr.className = 'receipt-row';
        tr.innerHTML = `
            <td><input type="text" name="details[${rowIndex}].itemName" class="input" style="height:48px" placeholder="예: 추가 작업비" required></td>
            <td><input type="number" name="details[${rowIndex}].quantity" class="qty input" style="height:48px;text-align:center" value="1" min="1" onchange="calcTotal()"></td>
            <td><input type="number" name="details[${rowIndex}].unitPrice" class="price input" style="height:48px;text-align:right" value="0" min="0" onchange="calcTotal()"></td>
            <td class="row-total right" style="font-weight:700;font-size:17px;vertical-align:middle">0</td>
            <td class="center"><button type="button" class="btn btn--ghost btn--sm" style="padding:0;width:40px;border:0" onclick="removeRow(this)"><svg class="ico"><use href="#i-trash"/></svg></button></td>
        `;
        tbody.appendChild(tr);
        rowIndex++;
        calcTotal();
    }

    function removeRow(btn) {
        const tr = btn.closest('tr');
        if(document.querySelectorAll('.receipt-row').length > 1) {
            tr.remove();
            calcTotal();
        } else {
            alert('최소 1개의 결제 내역이 필요합니다.');
        }
    }

    function calcTotal() {
        let total = 0;
        const rows = document.querySelectorAll('.receipt-row');
        rows.forEach(row => {
            const qty = parseInt(row.querySelector('.qty').value) || 0;
            const price = parseInt(row.querySelector('.price').value) || 0;
            const rowTotal = qty * price;
            row.querySelector('.row-total').innerText = rowTotal.toLocaleString();
            total += rowTotal;
        });
        document.getElementById('displayTotal').innerText = total.toLocaleString();
        document.getElementById('totalAmount').value = total;
    }

    function selectPayMethod(element) {
        document.querySelectorAll('input[name="paymentMethod"]').forEach(el => {
            el.nextElementSibling.classList.remove('chip--on');
        });
        element.classList.add('chip--on');
        element.previousElementSibling.checked = true;
    }

    function previewImg(input) {
        if (input.files && input.files[0]) {
            const reader = new FileReader();
            reader.onload = function(e) {
                const label = input.closest('label');
                label.style.backgroundImage = 'url(' + e.target.result + ')';
                label.style.backgroundSize = 'cover';
                label.style.backgroundPosition = 'center';
                label.querySelector('svg').style.display = 'none';
                label.querySelector('span').style.background = 'rgba(0,0,0,0.6)';
                label.querySelector('span').style.color = '#fff';
                label.querySelector('span').style.padding = '2px 8px';
                label.querySelector('span').style.borderRadius = '4px';
            }
            reader.readAsDataURL(input.files[0]);
        }
    }

    function submitPayment() {
        const total = document.getElementById('totalAmount').value;
        if (total == 0) {
            alert("총 결제 금액이 0원입니다. 단가를 입력해 주세요.");
            return;
        }
        if(confirm("이대로 수리를 완료하고 결제 영수증을 발행하시겠습니까?\n(발행 후에는 취소할 수 없습니다.)")) {
            document.getElementById('paymentForm').submit();
        }
    }
</script>

<jsp:include page="/WEB-INF/views/common/footer.jsp"/>