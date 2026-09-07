package com.surit.fixer.verify.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.surit.fixer.estimate.model.dto.EstimateDTO;
import com.surit.fixer.verify.model.dto.FixerLicenseDTO;
import com.surit.fixer.verify.model.dto.FixerProfileDTO;
import com.surit.fixer.verify.model.mapper.FixerMapper;

import lombok.RequiredArgsConstructor;

/**
 * 고객이 보는 기사 공개 프로필.
 * 매칭 화면에서 특정 접수(requestId)에 대한 프로필로 들어오면,
 * 그 접수에 보낸 견적 정보까지 같이 보여준다.
 */
@Controller
@RequiredArgsConstructor
public class FixerPublicProfileController {

    private final FixerMapper mapper;

    /**
     * 기사 프로필 조회
     * GET /fixers/{fixerNo}
     * GET /fixers/{fixerNo}?requestId=79   (특정 접수 견적 컨텍스트로 볼 때)
     */
    @GetMapping("/fixers/{fixerNo}")
    public String profile(@PathVariable("fixerNo") Long fixerNo,
                           @RequestParam(value = "requestId", required = false) Long requestId,
                           Model model,
                           RedirectAttributes ra) {

        FixerProfileDTO profile = mapper.selectPublicProfile(fixerNo);

        if (profile == null) {
            ra.addFlashAttribute("message", "존재하지 않는 기사입니다.");
            return "redirect:/";
        }

        List<String> categoryNames = mapper.selectFixerCategoryNames(fixerNo);
        List<String> regionNames = mapper.selectFixerRegionNames(fixerNo);
        List<FixerLicenseDTO> licenses = mapper.selectLicensesByUserNo(fixerNo);
        Long completedJobCount = mapper.selectCompletedJobCount(fixerNo);

        model.addAttribute("profile", profile);
        model.addAttribute("categoryNames", categoryNames);
        model.addAttribute("regionNames", regionNames);
        model.addAttribute("licenses", licenses);
        model.addAttribute("completedJobCount", completedJobCount);

        // 특정 접수 컨텍스트(매칭 화면에서 넘어온 경우)면, 그 접수에 보낸 견적도 같이 보여줌
        if (requestId != null) {
            EstimateDTO estimate = mapper.selectEstimateByRequestAndFixer(requestId, fixerNo);
            model.addAttribute("requestId", requestId);
            model.addAttribute("estimate", estimate);
        }

        return "fixer/fixerProfile";
    }
}