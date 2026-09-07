package com.surit.fixer.payment.controller;

import com.surit.user.model.dto.UserDTO; // 추가됨
import jakarta.servlet.http.HttpSession; // 추가됨
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import com.surit.fixer.payment.service.FixerPaymentService;
import com.surit.fixer.payment.service.FileUploadService;
import com.surit.fixer.payment.model.dto.PaymentDTO;
import com.surit.fixer.payment.model.dto.RepairPhotoDTO;
/*
    @Slf4j 어노테이션
    lombok에서 제공하는 어노테이션으로

 */


@Slf4j
@Controller
@RequestMapping("/fixer/payment")
@RequiredArgsConstructor
public class FixerPaymentController {

    private final FixerPaymentService paymentService;
    private final FileUploadService fileUploadService;

    @GetMapping
    public String showPaymentForm(@RequestParam("requestId") Long requestId, Model model) {

        PaymentDTO booking = new PaymentDTO();
        booking.setRequestId(requestId);

        model.addAttribute("booking", booking);

        // views/fixer/payment-form.jsp
        return "fixer/payment-form";
    }

    // 현장 결제 완료 및 사진 업로드 처리
    @PostMapping("/complete")
    public String completeJobAndPayment(
            HttpSession session,
            @ModelAttribute PaymentDTO paymentInfo,           // 영수증 데이터
            @RequestParam("beforePhoto") MultipartFile beforePhoto, // 수리 전 사진
            @RequestParam("afterPhoto") MultipartFile afterPhoto) { // 수리 후 사진


        UserDTO loginMember = (UserDTO) session.getAttribute("loginMember");
        if (loginMember == null) return "redirect:/user/login";
        Long fixerNo = loginMember.getUserNo();

        try {
            // 1. 수리 전 사진 저장
            if (!beforePhoto.isEmpty()) {
                String beforeUrl = fileUploadService.saveFile(beforePhoto);
                // TODO: 사진 경로를 DB에 INSERT 하는 Mapper 로직 호출 (paymentService 내부에 추가 필요)
            }

            // 2. 수리 후 사진 저장
            if (!afterPhoto.isEmpty()) {
                String afterUrl = fileUploadService.saveFile(afterPhoto);
                // TODO: 사진 경로를 DB에 INSERT 하는 Mapper 로직 호출
            }

            // 3. 결제 영수증 저장 및 예약 상태 '완료(COMPLETED)' 변경
            paymentInfo.setFixerNo(fixerNo);
            paymentService.processPaymentAndCompleteJob(paymentInfo);

            log.info("수리 완료 및 결제 처리 성공 - 요청번호: {}", paymentInfo.getRequestId());

        } catch (Exception e) {
            log.error("결제 처리 중 오류 발생", e);
            // 에러 발생 시 에러 페이지나 이전 화면으로 리다이렉트
            return "redirect:/fixer/jobs?error=true";
        }

        // 처리가 끝나면 기사의 '완료된 작업 목록' 화면으로 이동
        return "redirect:/fixer/jobs?tab=completed";
    }
}