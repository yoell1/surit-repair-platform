package com.surit.chat.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.messaging.simp.config.MessageBrokerRegistry;
import org.springframework.web.socket.config.annotation.EnableWebSocketMessageBroker;
import org.springframework.web.socket.config.annotation.StompEndpointRegistry;
import org.springframework.web.socket.config.annotation.WebSocketMessageBrokerConfigurer;
import org.springframework.web.socket.server.support.HttpSessionHandshakeInterceptor;

@Configuration
@EnableWebSocketMessageBroker
public class WebSocketConfig implements WebSocketMessageBrokerConfigurer {

	@Override
	public void configureMessageBroker(MessageBrokerRegistry config) {
		// 서버 -> 브라우저 (구독 경로)
		config.enableSimpleBroker("/sub");
		// 브라우저 -> 서버 (전송 경로)
		config.setApplicationDestinationPrefixes("/pub");
	}

	@Override
	public void registerStompEndpoints(StompEndpointRegistry registry) {
		registry.addEndpoint("/ws-chat")
				// ★ 로그인 세션을 WebSocket 쪽으로 넘겨준다.
				//   없으면 "누가 보냈는지"를 브라우저 말만 믿게 되어 위조가 가능해진다.
				.addInterceptors(new HttpSessionHandshakeInterceptor())
				.setAllowedOriginPatterns("*")
				.withSockJS();
	}
}