package com.surit.user.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.surit.common.model.mapper.CommonCodeMapper;
import com.surit.common.request.model.dto.RequestDTO;
import com.surit.common.request.service.RequestService;
import com.surit.user.address.service.UserAddressService;
import com.surit.user.model.dto.UserAddressDTO;
import com.surit.user.model.dto.UserDTO;
import com.surit.user.model.dto.UserReviewDTO;
import com.surit.user.review.service.UserReviewService;
import com.surit.user.service.UserService;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;

/**
 * 마이페이지 전용 컨트롤러.
 * 나의 접수 / 주소 관리 / 내 정보 수정 / 내가 쓴 리뷰
 *
 * 로그인 관련(가입, 로그인, 탈퇴)은 UserController 에 그대로 둔다.
 */
@Controller
@RequestMapping("/user/mypage")
@RequiredArgsConstructor
public class MypageController {

    private final UserService userService;
    private final RequestService requestService;
    private final UserReviewService reviewService;
    private final UserAddressService addressService;
    private final CommonCodeMapper codeMapper;
    /**
     * 나의 접수 목록
     * GET /user/mypage
     */
    @GetMapping
    public String myPage(HttpSession session, Model model) {

        UserDTO loginMember = (UserDTO) session.getAttribute("loginMember");

        if (loginMember == null) {
            return "redirect:/user/login?redirectURL=/user/mypage";
        }

        List<RequestDTO> requestList = requestService.getRequestsByUserId(loginMember.getUserNo());

        // 상태별 카운트 계산
        // REQ_01 접수대기 / REQ_02 견적중 / REQ_03 매칭완료 / REQ_04 수리완료
        // REQ_05 취소 / REQ_99 긴급접수
        //
        // REQ_99 는 2026-09-02 에 추가했다. 그전에는 default 로 빠져서 어느
        // 카운트에도 안 잡혔고, 칩 합계가 "전체" 건수와 어긋났다.
        int waitingCnt = 0, estimatingCnt = 0, matchedCnt = 0,
            doneCnt = 0, canceledCnt = 0, urgentCnt = 0;
        for (RequestDTO req : requestList) {
            String statusCode = req.getStatusCode();
            if (statusCode == null) continue;
            switch (statusCode) {
                case "REQ_01": waitingCnt++; break;
                case "REQ_02": estimatingCnt++; break;
                case "REQ_03": matchedCnt++; break;
                case "REQ_04": doneCnt++; break;
                case "REQ_05": canceledCnt++; break;
                case "REQ_99": urgentCnt++; break;
                default: break;
            }
        }

        model.addAttribute("user", loginMember);
        model.addAttribute("requestList", requestList);
        model.addAttribute("waitingCnt", waitingCnt);
        model.addAttribute("estimatingCnt", estimatingCnt);
        model.addAttribute("matchedCnt", matchedCnt);
        model.addAttribute("doneCnt", doneCnt);
        model.addAttribute("canceledCnt", canceledCnt);
        model.addAttribute("urgentCnt", urgentCnt);

        return "user/mypage";
    }

    /**
     * 내가 쓴 리뷰 목록
     * GET /user/mypage/reviews
     */
    @GetMapping("/reviews")
    public String myReviews(HttpSession session, Model model) {

        UserDTO loginMember = (UserDTO) session.getAttribute("loginMember");

        if (loginMember == null) {
            return "redirect:/user/login?redirectURL=/user/mypage/reviews";
        }

        List<UserReviewDTO> reviewList = reviewService.getReviewsByUserNo(loginMember.getUserNo());

        model.addAttribute("user", loginMember);
        model.addAttribute("reviewList", reviewList);

        return "user/reviews";
    }

    /**
     * 내 정보 수정 화면
     * GET /user/mypage/profile
     */
    @GetMapping("/profile")
    public String profileForm(HttpSession session, Model model) {

        UserDTO loginMember = (UserDTO) session.getAttribute("loginMember");

        if (loginMember == null) {
            return "redirect:/user/login?redirectURL=/user/mypage/profile";
        }

        model.addAttribute("user", loginMember);

        return "user/editProfile";
    }

    /**
     * 내 정보 저장
     * POST /user/mypage/profile
     */
    @PostMapping("/profile")
    public String updateProfile(UserDTO form, HttpSession session, RedirectAttributes ra) {

        UserDTO loginMember = (UserDTO) session.getAttribute("loginMember");

        if (loginMember == null) {
            return "redirect:/user/login?redirectURL=/user/mypage/profile";
        }

        form.setUserNo(loginMember.getUserNo());
        form.setUserId(loginMember.getUserId());

        try {
            UserDTO updated = userService.updateUserInfo(form);
            session.setAttribute("loginMember", updated);
            ra.addFlashAttribute("message", "내 정보가 수정되었습니다.");

        } catch (IllegalStateException e) {
            ra.addFlashAttribute("message", e.getMessage());
        }

        return "redirect:/user/mypage/profile";
    }

    /**
     * 주소 목록
     * GET /user/mypage/address
     */
    @GetMapping("/address")
    public String addressList(HttpSession session, Model model) {

        UserDTO loginMember = (UserDTO) session.getAttribute("loginMember");

        if (loginMember == null) {
            return "redirect:/user/login?redirectURL=/user/mypage/address";
        }

        model.addAttribute("user", loginMember);
        model.addAttribute("addressList", addressService.getAddressesByUserNo(loginMember.getUserNo()));
        // 새 주소 추가 폼에서 지역 선택 토글에 쓸 목록
        model.addAttribute("regionList", codeMapper.selectByGroup("REGION"));
        return "user/address";
    }

    /**
     * 주소 추가/수정 폼
     * GET /user/mypage/address/form?addressId=xxx (수정이면 파라미터 있음)
     */
    @GetMapping("/address/form")
    public String addressForm(@RequestParam(value = "addressId", required = false) Long addressId,
                               HttpSession session, Model model) {

        UserDTO loginMember = (UserDTO) session.getAttribute("loginMember");

        if (loginMember == null) {
            return "redirect:/user/login?redirectURL=/user/mypage/address/form";
        }

        if (addressId != null) {
            UserAddressDTO address = addressService.getAddress(addressId, loginMember.getUserNo());
            model.addAttribute("address", address);
        }

        return "user/addressForm";
    }

    /**
     * 주소 신규 등록
     * POST /user/mypage/address
     */
    @PostMapping("/address")
    public String createAddress(
            UserAddressDTO form,
            @RequestParam(value = "returnUrl", required = false) String returnUrl,
            HttpSession session,
            RedirectAttributes ra) {

        UserDTO loginMember =
                (UserDTO) session.getAttribute("loginMember");

        if (loginMember == null) {
            return "redirect:/user/login";
        }

        form.setUserNo(loginMember.getUserNo());

        addressService.insertAddress(form);

        ra.addFlashAttribute(
                "message",
                "주소가 등록되었습니다."
        );

        // 접수 페이지에서 등록한 경우
        if (returnUrl != null && !returnUrl.isBlank()) {
            return "redirect:" + returnUrl;
        }

        // 기존 주소관리 페이지에서 등록한 경우
        return "redirect:/user/mypage/address";
    }
    /**
     * 주소 수정
     * POST /user/mypage/address/{addressId}
     */
    @PostMapping("/address/{addressId}")
    public String updateAddress(@PathVariable("addressId") Long addressId,
                                 UserAddressDTO form,
                                 HttpSession session, RedirectAttributes ra) {

        UserDTO loginMember = (UserDTO) session.getAttribute("loginMember");

        if (loginMember == null) {
            return "redirect:/user/login?redirectURL=/user/mypage/address";
        }

        form.setAddressId(addressId);
        form.setUserNo(loginMember.getUserNo());

        try {
            addressService.updateAddress(form);
            ra.addFlashAttribute("message", "주소가 수정되었습니다.");
        } catch (IllegalStateException e) {
            ra.addFlashAttribute("message", e.getMessage());
        }

        return "redirect:/user/mypage/address";
    }

    /**
     * 주소 삭제
     * POST /user/mypage/address/{addressId}/delete
     */
    @PostMapping("/address/{addressId}/delete")
    public String deleteAddress(@PathVariable("addressId") Long addressId,
                                 HttpSession session, RedirectAttributes ra) {

        UserDTO loginMember = (UserDTO) session.getAttribute("loginMember");

        if (loginMember == null) {
            return "redirect:/user/login?redirectURL=/user/mypage/address";
        }

        try {
            addressService.deleteAddress(addressId, loginMember.getUserNo());
            ra.addFlashAttribute("message", "주소가 삭제되었습니다.");
        } catch (IllegalStateException e) {
            ra.addFlashAttribute("message", e.getMessage());
        }

        return "redirect:/user/mypage/address";
    }


    
}