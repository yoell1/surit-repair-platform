package com.surit.fixer.block.service;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;

import com.surit.fixer.block.mapper.FixerBlockMapper;
import com.surit.fixer.block.model.dto.FixerBlockDTO;

@Service
@RequiredArgsConstructor
public class FixerBlockService {

    private final FixerBlockMapper blockMapper;

    public List<FixerBlockDTO> getBlockedCustomers(Long fixerNo) {
        return blockMapper.selectBlockedCustomers(fixerNo);
    }

    @Transactional
    public void unblockCustomer(Long fixerNo, Long blockId) {
        int result = blockMapper.deleteBlock(fixerNo, blockId);
        if (result == 0) {
            throw new RuntimeException("차단 해제에 실패했습니다. 유효하지 않은 요청입니다.");
        }
    }
}