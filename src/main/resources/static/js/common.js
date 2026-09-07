/* 수릿 공통 스크립트 — 프로토타입용 최소 동작만 */

/* 헤더 프로필 드롭다운 — 버튼 클릭 시 열고, 바깥을 누르면 닫힘 */
document.addEventListener('click', function (e) {
  var btn = e.target.closest('.profile__btn');
  document.querySelectorAll('.profile').forEach(function (p) {
    if (btn && p.contains(btn)) p.classList.toggle('is-open');
    else p.classList.remove('is-open');
  });
});

/* 접수 페이지 : 메인에서 넘어온 ?cat= 값으로 카테고리 미리 선택 */
(function () {
  var cat = (location.search.match(/[?&]cat=([^&]*)/) || [])[1];
  if (!cat) return;
  var target = document.querySelector('.cat[data-cat="' + decodeURIComponent(cat) + '"]');
  if (!target) return;
  document.querySelectorAll('.cat').forEach(function (c) { c.classList.remove('is-on'); });
  target.classList.add('is-on');
})();

/* 선택형 UI (카테고리 / 라디오 카드 / 칩) — 같은 그룹 안에서 하나만 선택 */
document.addEventListener('click', function (e) {
  var el = e.target.closest('[data-select]');
  if (!el) return;
  var group = el.getAttribute('data-select');
  document.querySelectorAll('[data-select="' + group + '"]').forEach(function (x) {
    x.classList.remove('is-on');
  });
  el.classList.add('is-on');
});

/* 다중 선택 칩 */
document.addEventListener('click', function (e) {
  var el = e.target.closest('[data-toggle]');
  if (!el) return;
  el.classList.toggle('chip--on');
});

/* 별점 입력 */
document.querySelectorAll('[data-star]').forEach(function (box) {
  var svgs = box.querySelectorAll('svg');
  svgs.forEach(function (s, i) {
    s.style.cursor = 'pointer';
    s.addEventListener('click', function () {
      svgs.forEach(function (t, j) { t.classList.toggle('off', j > i); });
      var out = document.querySelector(box.getAttribute('data-star'));
      if (out) out.textContent = (i + 1) + '.0';
    });
  });
});

/* FAQ 아코디언 */
document.addEventListener('click', function (e) {
  var q = e.target.closest('.faq__q');
  if (!q) return;
  q.parentElement.classList.toggle('is-open');
});

/* 회원가입 : 회원 유형(role) 선택 카드가 hidden input(userRole)에도 값을 반영 */
/* 카드 전환 자체는 위 [data-select] 핸들러가 처리, 여기서는 hidden input 동기화만 담당 */
document.addEventListener('click', function (e) {
  var el = e.target.closest('[data-select="role"]');
  if (!el) return;
  var roleInput = document.getElementById('user-role');
  if (roleInput) roleInput.value = el.dataset.role;
});

/* 회원가입 폼 유효성 검사 + 아이디 중복확인 */
(function () {
  var form = document.getElementById('sign-form');
  if (!form) return;

  var idChecked = false; // 중복확인 통과 여부 (true여야 제출 가능)

  var rules = [
    {
      inputId: 'user-id',
      resultId: 'check-id-result',
      validate: function (v) {
        if (!v.trim()) return '아이디를 입력해주세요';
        if (v.length < 4 || v.length > 20) return '아이디는 4~20자로 입력해주세요';
        if (!/^[a-zA-Z0-9]+$/.test(v)) return '아이디는 영문·숫자만 사용할 수 있어요';
        return null;
      }
    },
    {
      inputId: 'user-pwd',
      resultId: null,
      validate: function (v) {
        if (!v) return '비밀번호를 입력해주세요';
        if (v.length < 8) return '비밀번호는 8자 이상 입력해주세요';
        return null;
      }
    },
    {
      inputId: 'user-pwd-confirm',
      resultId: 'check-pwd-result',
      validate: function (v) {
        var pwd = document.getElementById('user-pwd').value;
        if (!v) return '비밀번호를 한 번 더 입력해주세요';
        if (v !== pwd) return '비밀번호가 일치하지 않습니다';
        return null;
      }
    },
    {
      inputId: 'user-name',
      resultId: 'check-name-result',
      validate: function (v) {
        if (!v.trim()) return '이름을 입력해주세요';
        return null;
      }
    },
    {
      inputId: 'user-email',
      resultId: 'check-email-result',
      validate: function (v) {
        if (!v) return '이메일을 입력해주세요'; // DB EMAIL 컬럼이 NOT NULL이라 필수로 변경
        var ok = /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(v);
        return ok ? null : '이메일 형식이 올바르지 않습니다';
      }
    },
    {
      inputId: 'phone',
      resultId: 'check-phone-result',
      validate: function (v) {
        if (!v) return '전화번호를 입력해주세요';
        if (!/^[0-9]+$/.test(v)) return '전화번호는 숫자만 입력해주세요';
        if (v.length < 9 || v.length > 11) return '전화번호 자리수를 확인해주세요';
        return null;
      }
    },
    {
      inputId: 'address',
      resultId: null,
      validate: function (v) {
        if (!v) return '지역과 상세주소를 모두 입력해주세요';
        return null;
      }
    }
  ];

  function showError(rule, message, colorVar) {
    var input = document.getElementById(rule.inputId);
    if (input) input.style.borderColor = message ? 'var(--danger)' : '';
    if (!rule.resultId) return;
    var out = document.getElementById(rule.resultId);
    if (!out) return;
    out.textContent = message || '';
    out.style.color = message ? (colorVar || 'var(--danger)') : '';
  }

  // 입력 중에는 실시간으로 에러 지우기
  rules.forEach(function (rule) {
    var input = document.getElementById(rule.inputId);
    if (!input) return;
    input.addEventListener('input', function () {
      var message = rule.validate(input.value);
      showError(rule, message);
      // 아이디를 다시 고치면 예전 중복확인 결과는 무효
      if (rule.inputId === 'user-id') idChecked = false;
    });
  });

  /* 아이디 중복확인 버튼 */
  var idRule = rules[0];
  var idInput = document.getElementById('user-id');
  var idResult = document.getElementById('check-id-result');
  var checkIdBtn = document.getElementById('check-id-btn');

  if (checkIdBtn && idInput && idResult) {
    checkIdBtn.addEventListener('click', function () {
      var value = idInput.value.trim();
      var formatMessage = idRule.validate(value);

      if (formatMessage) {
        showError(idRule, formatMessage);
        idChecked = false;
        return;
      }

      idResult.textContent = '확인 중...';
      idResult.style.color = '';
      idInput.style.borderColor = '';
      checkIdBtn.disabled = true;

      fetch('/user/checkId?userId=' + encodeURIComponent(value))
        .then(function (res) {
          if (!res.ok) throw new Error('request-failed');
          return res.json();
        })
        .then(function (result) {
          var isDuplicate = result.data; // true면 이미 사용중
          idChecked = !isDuplicate;
          idResult.textContent = result.message;
          idResult.style.color = isDuplicate ? 'var(--danger)' : 'var(--ok)';
          idInput.style.borderColor = isDuplicate ? 'var(--danger)' : '';
        })
        .catch(function () {
          idChecked = false;
          idResult.textContent = '중복확인 중 오류가 발생했습니다. 다시 시도해주세요';
          idResult.style.color = 'var(--danger)';
        })
        .finally(function () {
          checkIdBtn.disabled = false;
        });
    });
  }
  form.addEventListener('submit', function (e) {
    var firstInvalid = null;

    rules.forEach(function (rule) {
      var input = document.getElementById(rule.inputId);
      if (!input) return;
      var message = rule.validate(input.value);
      showError(rule, message);
      if (message && !firstInvalid) firstInvalid = input;
    });

    if (!firstInvalid && !idChecked && idInput && idResult) {   // ← idInput, idResult 존재 확인 추가
      idResult.textContent = '아이디 중복확인을 해주세요';
      idResult.style.color = 'var(--danger)';
      idInput.style.borderColor = 'var(--danger)';
      firstInvalid = idInput;
    }

    if (firstInvalid) {
      e.preventDefault();
      firstInvalid.focus();
    }
  });
})();

/* 마이페이지 : 상태 필터 칩 클릭 -> 접수 목록 테이블 행 필터링 */
(function () {
  var filterBar = document.getElementById('status-filter');
  if (!filterBar) return;

  filterBar.addEventListener('click', function (e) {
    var chip = e.target.closest('[data-status-filter]');
    if (!chip) return;

    filterBar.querySelectorAll('[data-status-filter]').forEach(function (c) {
      c.classList.remove('chip--dark');
    });
    chip.classList.add('chip--dark');

    var status = chip.getAttribute('data-status-filter');
    document.querySelectorAll('[data-status-row]').forEach(function (row) {
      var show = (status === 'all') || (row.getAttribute('data-status-row') === status);
      row.style.display = show ? '' : 'none';
    });
  });
})();

/* 기본 주소 체크박스 -> hidden input(isDefault)에 Y/N 반영 */
(function () {
  var checkbox = document.getElementById('is-default-checkbox');
  var hidden = document.getElementById('is-default');
  if (!checkbox || !hidden) return;

  checkbox.addEventListener('change', function () {
    hidden.value = checkbox.checked ? 'Y' : 'N';
  });
})();

/* 지역 선택 토글 + 지역명/상세주소 합쳐서 hidden input(address) 채우기
   -- 회원가입, 마이페이지 주소 추가 등 여러 화면에서 재사용하는 범용 함수 --
   panelId: 라디오 목록을 담은 패널 div id
   detailId: 상세주소 input id
   hiddenId: 최종 합쳐진 값이 들어갈 hidden input id
   labelId: 선택한 지역명을 보여줄 요소 id
   radioName: 그 패널 안 라디오들의 name 속성 (같은 페이지에 여러 세트 있을 때 구분용) */
function toggleRegionPanel(panelId) {
  var panel = document.getElementById(panelId);
  if (!panel) return;
  panel.style.display = (panel.style.display === 'none') ? 'block' : 'none';
}

function bindRegionSelect(panelId, detailId, hiddenId, labelId, radioName) {
  var panel = document.getElementById(panelId);
  var addressDetail = document.getElementById(detailId);
  var addressHidden = document.getElementById(hiddenId);
  var selectedLabel = document.getElementById(labelId);
  if (!panel || !addressHidden) return;

  var PLACEHOLDER = '지역을 선택해주세요';

  function currentRegionName() {
    if (!selectedLabel) return '';
    var text = selectedLabel.textContent.trim();
    return (text === PLACEHOLDER) ? '' : text;
  }

  function updateAddress() {
    // ★ ADDRESS 컬럼에는 "지역"만 넣는다.
    //   상세주소는 ADDRESS_DETAIL 이 따로 갖고 있다.
    //   여기에 또 붙이면 화면에 두 번 나오고,
    //   수정할 때마다 앞 값에 계속 덧붙어서 무한히 길어진다.
    addressHidden.value = currentRegionName();
  }

  panel.addEventListener('change', function (e) {
    if (e.target.name === radioName) {
      var regionName = e.target.dataset.regionName;
      if (selectedLabel) selectedLabel.textContent = regionName;
      updateAddress();
      panel.style.display = 'none';
    }
  });

  if (addressDetail) {
    addressDetail.addEventListener('input', updateAddress);
  }
}

/* 회원가입 폼에 적용 */
function toggleRegionSelect() {
  toggleRegionPanel('region-select-panel');
}
(function () {
  bindRegionSelect('region-select-panel', 'address-detail', 'address', 'region-selected-label', 'regionRadio');
})();

/* 마이페이지 : 새 주소 추가 폼에 적용 (같은 지역 토글 방식, id만 다름) */
function toggleNewAddressRegionSelect() {
  toggleRegionPanel('new-region-select-panel');
}
(function () {
  bindRegionSelect('new-region-select-panel', 'new-address-detail', 'new-address', 'new-region-selected-label', 'newRegionRadio');
})();

/* 수리 접수 : 카테고리 카드 선택 -> hidden input(categoryCode) 동기화 */
document.addEventListener('click', function (e) {
  var el = e.target.closest('[data-select="category"]');
  if (!el) return;
  var input = document.getElementById('category-code');
  if (input) input.value = el.dataset.categoryCode;
});

/* 수리 접수 : 긴급출동 체크박스 -> hidden input(useYn)에 Y/N 반영 */
(function () {
  var checkbox = document.getElementById('request-urgent-checkbox');
  var hidden = document.getElementById('request-urgent');
  if (!checkbox || !hidden) return;

  checkbox.addEventListener('change', function () {
    hidden.value = checkbox.checked ? 'Y' : 'N';
  });
})();

/* 사진 선택 후 브라우저에 미리보기 */
const photoInput = document.getElementById("request-photos");
const photoPreview = document.getElementById("photo-preview");

const selectedFiles = new DataTransfer();

if (photoInput && photoPreview) {

    photoInput.addEventListener("change", function () {

        const newFiles = Array.from(this.files);

        for (const file of newFiles) {

            if (!file.type.startsWith("image/")) {
                alert("이미지 파일만 첨부할 수 있습니다.");
                continue;
            }

            if (selectedFiles.files.length >= 5) {
                alert("사진은 최대 5장까지 첨부할 수 있습니다.");
                break;
            }

            selectedFiles.items.add(file);
        }

        photoInput.files = selectedFiles.files;

        renderPhotoPreview();
    });


    function renderPhotoPreview() {

        photoPreview.innerHTML = "";

        Array.from(selectedFiles.files).forEach(function (file, index) {

            const item = document.createElement("div");
            item.className = "photo-preview__item";

            const img = document.createElement("img");
            img.src = URL.createObjectURL(file);
            img.alt = "첨부 사진";

            const removeButton = document.createElement("button");
            removeButton.type = "button";
            removeButton.className = "photo-preview__remove";
            removeButton.innerHTML = "×";

            removeButton.addEventListener("click", function () {
                removePhoto(index);
            });

            item.appendChild(img);
            item.appendChild(removeButton);

            photoPreview.appendChild(item);
        });
    }


    function removePhoto(removeIndex) {

        const newTransfer = new DataTransfer();

        Array.from(selectedFiles.files).forEach(function (file, index) {

            if (index !== removeIndex) {
                newTransfer.items.add(file);
            }
        });

        selectedFiles.items.clear();

        Array.from(newTransfer.files).forEach(function (file) {
            selectedFiles.items.add(file);
        });

        photoInput.files = selectedFiles.files;

        renderPhotoPreview();
    }
}


// ========================================
// 접수 페이지 : 방문 주소 선택
// ========================================

const addressCards =
    document.querySelectorAll(".address-card");

const serviceAddress =
    document.getElementById("service-address");

addressCards.forEach(function (card) {

    card.addEventListener("click", function () {

        addressCards.forEach(function (item) {
            item.classList.remove("is-on");
        });

        this.classList.add("is-on");

        if (serviceAddress) {
            serviceAddress.value =
                this.dataset.address || "";
        }
    });
});


// 기본 주소가 있으면 자동으로 값 세팅
const defaultAddress =
    document.querySelector(".address-card.is-on");

if (defaultAddress && serviceAddress) {
    serviceAddress.value =
        defaultAddress.dataset.address || "";
}


// ========================================
// 주소 관리 페이지 : 수정
// ========================================

function toggleAddressEdit(addressId) {

    var view =
        document.getElementById(
            "address-view-" + addressId
        );

    var edit =
        document.getElementById(
            "address-edit-" + addressId
        );

    if (!view || !edit) {
        return;
    }

    var editing =
        edit.style.display !== "none";

    edit.style.display =
        editing ? "none" : "block";

    view.style.display =
        editing ? "flex" : "none";
}


// ========================================
// 주소 관리 페이지 : 새 주소 추가
// ========================================

function toggleAddressAdd() {

    var form =
        document.getElementById(
            "address-add-form"
        );

    var btn =
        document.getElementById(
            "add-address-btn"
        );

    if (!form || !btn) {
        return;
    }

    var opening =
        form.style.display === "none";

    form.style.display =
        opening ? "block" : "none";

    btn.style.display =
        opening ? "none" : "flex";
}


// ========================================
// 수리 접수 페이지 : 방문 일정 선택
// ========================================

(function () {

    const whenSelect =
        document.getElementById("when-select");

    const visitArea =
        document.getElementById("visit-option-area");

    const visitDate =
        document.getElementById("visit-date");

    const visitTimeCode =
        document.getElementById("visit-time-code");


    // 접수 페이지가 아니면 실행하지 않음
    if (
        !whenSelect ||
        !visitArea ||
        !visitDate ||
        !visitTimeCode
    ) {
        return;
    }


    // 오늘 이전 날짜 선택 금지
    const today = new Date();

    const yyyy = today.getFullYear();

    const mm =
        String(today.getMonth() + 1)
            .padStart(2, "0");

    const dd =
        String(today.getDate())
            .padStart(2, "0");

    visitDate.min =
        yyyy + "-" + mm + "-" + dd;


    // 지금 바로 / 날짜 지정 클릭
    whenSelect.addEventListener("click", function (event) {

        const button =
            event.target.closest(".opt");

        if (!button) {
            return;
        }


        // 기존 선택 제거
        whenSelect
            .querySelectorAll(".opt")
            .forEach(function (item) {

                item.classList.remove("is-on");

            });


        // 클릭한 카드 선택
        button.classList.add("is-on");

		// ================================
		// 날짜 지정
		// ================================

		if (button.dataset.useYn === "N") {

		    visitArea.style.display = "block";

		    visitDate.required = true;
		    visitTimeCode.required = true;

		    var urgentYnN = document.getElementById("urgent-yn");
		    if (urgentYnN) urgentYnN.value = "";

		}

		// ================================
		// 지금 바로
		// ================================

		else {

		    visitArea.style.display = "none";

		    visitDate.required = false;
		    visitTimeCode.required = false;

		    visitDate.value = "";
		    visitTimeCode.value = "";

		    var urgentYnY = document.getElementById("urgent-yn");
		    if (urgentYnY) urgentYnY.value = "Y";

		}
    });

})();


// ========================================
// 리뷰 작성 : 별점 클릭 -> hidden input(score) 반영
// ========================================

(function () {
  var box = document.getElementById('review-stars');
  var scoreInput = document.getElementById('review-score');
  var scoreLabel = document.getElementById('review-score-label');
  if (!box || !scoreInput) return;

  var svgs = box.querySelectorAll('svg');
  svgs.forEach(function (s, i) {
    s.addEventListener('click', function () {
      svgs.forEach(function (t, j) { t.classList.toggle('off', j > i); });
      scoreInput.value = i + 1;
      if (scoreLabel) scoreLabel.textContent = (i + 1) + '.0';
    });
  });
})();

// ========================================
// 리뷰 작성 : 태그 칩 선택 내용을 제출 시 content 앞에 붙이기
// ========================================

(function () {
  var form = document.getElementById('review-form');
  if (!form) return;

  form.addEventListener('submit', function (e) {

    var scoreInput = document.getElementById('review-score');
    if (!scoreInput.value) {
      e.preventDefault();
      alert('별점을 선택해주세요.');
      return;
    }

    var tags = Array.from(form.querySelectorAll('.chip--on'))
      .map(function (chip) { return chip.textContent.trim(); });

    var contentInput = document.getElementById('review-content');
    if (tags.length > 0) {
      var tagText = '[' + tags.join(', ') + '] ';
      if (contentInput.value.indexOf(tagText) !== 0) {
        contentInput.value = tagText + contentInput.value;
      }
    }
  });
})();

// ========================================
// 사진 확대 보기 (라이트박스)
// class="photo-zoom" 붙은 img 클릭 시 전체화면으로 확대
// ========================================

(function () {

    var overlay = null;

    function openLightbox(src) {

        if (overlay) return;

        overlay = document.createElement('div');
        overlay.style.cssText =
            'position:fixed;inset:0;background:rgba(0,0,0,.85);z-index:9999;' +
            'display:flex;align-items:center;justify-content:center;cursor:zoom-out;padding:24px';

        var img = document.createElement('img');
        img.src = src;
        img.style.cssText =
            'max-width:90vw;max-height:90vh;border-radius:12px;object-fit:contain;' +
            'box-shadow:0 10px 40px rgba(0,0,0,.5)';

        overlay.appendChild(img);
        document.body.appendChild(overlay);

        overlay.addEventListener('click', closeLightbox);
        document.addEventListener('keydown', onKeydown);
    }

    function closeLightbox() {
        if (!overlay) return;
        overlay.remove();
        overlay = null;
        document.removeEventListener('keydown', onKeydown);
    }

    function onKeydown(e) {
        if (e.key === 'Escape') closeLightbox();
    }

    document.addEventListener('click', function (e) {
        var img = e.target.closest('.photo-zoom');
        if (!img) return;
        openLightbox(img.src);
    });

})();


// ========================================
// 수리 접수 페이지 : 최종 제출 검증
// ========================================

(function () {

    const form =
        document.getElementById("request-form");

    // 접수 페이지가 아니면 실행하지 않음
    if (!form) {
        return;
    }


    form.addEventListener("submit", function (event) {

        const categoryCode =
            document.getElementById("category-code");

        const title =
            document.getElementById("request-title");

        const content =
            document.getElementById("request-content");

        const serviceAddress =
            document.getElementById("service-address");

        const selectedWhen =
            document.querySelector(
                "#when-select .opt.is-on"
            );

        const visitDate =
            document.getElementById("visit-date");

        const visitTimeCode =
            document.getElementById("visit-time-code");

        const agreeCheckbox =
            document.getElementById("agree-checkbox");


        // 카테고리
        if (
            !categoryCode ||
            !categoryCode.value.trim()
        ) {

            event.preventDefault();

            alert("수리 카테고리를 선택해주세요.");

            return;
        }


        // 제목
        if (
            !title ||
            !title.value.trim()
        ) {

            event.preventDefault();

            alert("제목을 입력해주세요.");

            if (title) {
                title.focus();
            }

            return;
        }


        // 증상
        if (
            !content ||
            !content.value.trim()
        ) {

            event.preventDefault();

            alert("증상을 입력해주세요.");

            if (content) {
                content.focus();
            }

            return;
        }


        // 주소
        if (
            !serviceAddress ||
            !serviceAddress.value.trim()
        ) {

            event.preventDefault();

            alert("방문 주소를 선택해주세요.");

            return;
        }


        // 방문 일정 미선택
        if (!selectedWhen) {

            event.preventDefault();

            alert("방문 일정을 선택해주세요.");

            return;
        }


        // 날짜 지정 선택
        if (selectedWhen.dataset.useYn === "N") {

            if (
                !visitDate ||
                !visitDate.value
            ) {

                event.preventDefault();

                alert(
                    "희망 방문 날짜를 선택해주세요."
                );

                if (visitDate) {
                    visitDate.focus();
                }

                return;
            }


            if (
                !visitTimeCode ||
                !visitTimeCode.value
            ) {

                event.preventDefault();

                alert(
                    "희망 시간대를 선택해주세요."
                );

                if (visitTimeCode) {
                    visitTimeCode.focus();
                }

                return;
            }
        }


        // 약관
        if (
            !agreeCheckbox ||
            !agreeCheckbox.checked
        ) {

            event.preventDefault();

            alert(
                "개인정보 제공 및 이용약관에 동의해주세요."
            );

            return;
        }

    });

})();
/* 내 정보 수정 폼 : 전화번호 숫자만 입력 검증 (editProfile.jsp, id="p-phone") */
(function () {
  var phoneInput = document.getElementById('p-phone');
  if (!phoneInput) return;

  var form = phoneInput.closest('form');
  if (!form) return;

  function validatePhone(v) {
    if (!v) return '전화번호를 입력해주세요';
    if (!/^[0-9]+$/.test(v)) return '전화번호는 숫자만 입력해주세요';
    if (v.length < 9 || v.length > 11) return '전화번호 자리수를 확인해주세요';
    return null;
  }

  function showPhoneError(message) {
    phoneInput.style.borderColor = message ? 'var(--danger)' : '';
    var out = document.getElementById('check-phone-result');
    if (out) {
      out.textContent = message || '';
      out.style.color = message ? 'var(--danger)' : '';
    }
  }

  phoneInput.addEventListener('input', function () {
    showPhoneError(validatePhone(phoneInput.value));
  });

  form.addEventListener('submit', function (e) {
    var message = validatePhone(phoneInput.value);
    showPhoneError(message);
    if (message) {
      e.preventDefault();
      phoneInput.focus();
    }
  });
})();
// ========================================
// 접수 페이지 : 새 주소 추가 박스 열기/닫기
// ========================================
(function () {

    const showBtn =
        document.getElementById("show-address-add-btn");

    const addBox =
        document.getElementById("address-add-box");

    const closeBtn =
        document.getElementById("address-add-close");

    const cancelBtn =
        document.getElementById("address-add-cancel");


    if (!showBtn || !addBox) {
        return;
    }


    showBtn.addEventListener("click", function () {

        addBox.style.display = "block";

        // 버튼은 그대로 두고 싶으면 이 줄은 안 써도 됨
        // showBtn.style.display = "none";

    });


    function closeAddressForm() {

        addBox.style.display = "none";

    }


    if (closeBtn) {
        closeBtn.addEventListener(
            "click",
            closeAddressForm
        );
    }


    if (cancelBtn) {
        cancelBtn.addEventListener(
            "click",
            closeAddressForm
        );
}
		})();
	/* 내 정보 수정 폼 : 비밀번호 변경 검증 (editProfile.jsp) */
	(function () {
	  var pwdInput = document.getElementById('p-pwd');
	  var pwdConfirmInput = document.getElementById('p-pwd-confirm');
	  if (!pwdInput || !pwdConfirmInput) return;

	  var form = pwdInput.closest('form');
	  if (!form) return;

	  function showConfirmError(message) {
	    pwdConfirmInput.style.borderColor = message ? 'var(--danger)' : '';
	    var out = document.getElementById('check-pwd-result');
	    if (out) {
	      out.textContent = message || '';
	      out.style.color = message ? 'var(--danger)' : '';
	    }
	  }

	  function validate() {
	    var pwd = pwdInput.value;
	    var confirm = pwdConfirmInput.value;
	    var lengthOut = document.getElementById('check-pwd-length-result');

	    function showLengthError(message) {
	      pwdInput.style.borderColor = message ? 'var(--danger)' : '';
	      if (lengthOut) {
	        lengthOut.textContent = message || '';
	        lengthOut.style.color = message ? 'var(--danger)' : '';
	      }
	    }

	    if (!pwd && !confirm) {
	      showLengthError(null);
	      showConfirmError(null);
	      return null;
	    }

	    if (pwd && pwd.length < 8) {
	      showLengthError('비밀번호는 8자 이상 입력해주세요');
	      return { input: pwdInput, message: '비밀번호는 8자 이상 입력해주세요' };
	    }
	    showLengthError(null);

	    if (!pwd && confirm) {
	      showConfirmError('새 비밀번호를 먼저 입력해주세요');
	      return { input: pwdConfirmInput, message: '새 비밀번호를 먼저 입력해주세요' };
	    }

	    if (pwd && !confirm) {
	      showConfirmError('비밀번호를 한 번 더 입력해주세요');
	      return { input: pwdConfirmInput, message: '비밀번호를 한 번 더 입력해주세요' };
	    }

	    if (pwd !== confirm) {
	      showConfirmError('비밀번호가 일치하지 않습니다');
	      return { input: pwdConfirmInput, message: '비밀번호가 일치하지 않습니다' };
	    }

	    showConfirmError(null);
	    return null;
	  }

	  // ↓↓↓ 이 3줄이 빠져있었어요 ↓↓↓
	  pwdInput.addEventListener('input', validate);
	  pwdConfirmInput.addEventListener('input', validate);

	  form.addEventListener('submit', function (e) {
	    var error = validate();
	    if (error) {
	      e.preventDefault();
	      error.input.focus();
	    }
	  });
	})();