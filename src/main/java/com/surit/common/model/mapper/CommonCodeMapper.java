package com.surit.common.model.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.surit.common.model.dto.CommonCodeDTO;

@Mapper
public interface CommonCodeMapper {

    List<CommonCodeDTO> selectByGroup(
            @Param("codeGroup") String codeGroup
        );
}
