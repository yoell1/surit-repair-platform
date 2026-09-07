package com.surit.chat.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.surit.chat.dto.ChatMessageDTO;

/**
 * 기존 평문 메시지를 암호문으로 바꾸는 1회용 Mapper.
 *
 * ★ 여기서는 일부러 TypeHandler 를 쓰지 않는다.
 *   자동 암복호화가 끼면 "평문을 읽어서 암호화" 하는 게 아니라
 *   "복호화 시도 -> 암호화" 가 되어 값이 망가진다.
 */
@Mapper
public interface ChatCryptoMigrationMapper {

	/** 아직 암호화되지 않은(enc:v1: 표시가 없는) 메시지 */
	List<ChatMessageDTO> selectPlainMessages();

	int updateContent(@Param("messageId") Long messageId,
	                  @Param("content")   String content);
}
