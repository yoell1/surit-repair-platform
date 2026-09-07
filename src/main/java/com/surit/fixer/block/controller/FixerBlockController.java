package com.surit.fixer.block.controller;

import com.surit.user.model.dto.UserDTO;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import com.surit.fixer.block.service.FixerBlockService;

@Slf4j
@Controller
@RequestMapping("/fixer/blocked")
@RequiredArgsConstructor
public class FixerBlockController {

    private final FixerBlockService blockService;

    /**
     * 차단 고객 목록 화면 조회
     */
    @GetMapping
    public String showBlockedList(HttpSession session, Model model) {
        // 팀 규칙 세션 꺼내기
        UserDTO loginMember = (UserDTO) session.getAttribute("loginMember");
        if (loginMember == null) return "redirect:/user/login";
        Long fixerNo = loginMember.getUserNo();

        log.info("차단 고객 목록 조회 - 기사번호: {}", fixerNo);

        model.addAttribute("blockedList", blockService.getBlockedCustomers(fixerNo));
        return "fixer/blocked"; // WEB-INF/views/fixer/blocked.jsp 로 이동
    }

    /**
     * 차단 해제 처리
     */
    @PostMapping("/{blockId}/unblock")
    public String unblockCustomer(
            HttpSession session,
            @PathVariable Long blockId) {

        // 팀 규칙 세션 꺼내기
        UserDTO loginMember = (UserDTO) session.getAttribute("loginMember");
        if (loginMember == null) return "redirect:/user/login";
        Long fixerNo = loginMember.getUserNo();

        log.info("차단 해제 요청 - 기사번호: {}, 차단ID: {}", fixerNo, blockId);

        blockService.unblockCustomer(fixerNo, blockId);

        // 차단 해제 후 다시 목록 화면으로 새로고침
        return "redirect:/fixer/blocked";
    }
}