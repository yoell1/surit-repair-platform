package com.surit.fixer.block.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.util.List;
import com.surit.fixer.block.model.dto.FixerBlockDTO;

@Mapper
public interface FixerBlockMapper {
    List<FixerBlockDTO> selectBlockedCustomers(@Param("fixerNo") Long fixerNo);
    int deleteBlock(@Param("fixerNo") Long fixerNo, @Param("blockId") Long blockId);
}