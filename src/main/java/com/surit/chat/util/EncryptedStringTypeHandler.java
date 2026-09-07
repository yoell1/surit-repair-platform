package com.surit.chat.util;

import java.sql.CallableStatement;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import org.apache.ibatis.type.BaseTypeHandler;
import org.apache.ibatis.type.JdbcType;

/**
 * DB에 넣을 때 자동 암호화, 꺼낼 때 자동 복호화하는 MyBatis 부품.
 *
 * 덕분에 Service · Controller · JSP 는 한 줄도 안 바꿔도 된다.
 * 바뀌는 곳은 ChatMapper.xml 의 CONTENT 부분뿐이다.
 *
 * ※ 주의 : application.properties 에 mybatis.type-handlers-package 를 설정하면
 *   이 클래스가 "모든 String 컬럼"에 적용되어 DB 전체가 암호화된다.
 *   반드시 XML 에서 CONTENT 에만 지정해서 쓸 것.
 */
public class EncryptedStringTypeHandler extends BaseTypeHandler<String> {

	@Override
	public void setNonNullParameter(PreparedStatement ps, int i, String parameter, JdbcType jdbcType)
			throws SQLException {
		ps.setString(i, ChatCrypto.get().encrypt(parameter));
	}

	@Override
	public String getNullableResult(ResultSet rs, String columnName) throws SQLException {
		return ChatCrypto.get().decrypt(rs.getString(columnName));
	}

	@Override
	public String getNullableResult(ResultSet rs, int columnIndex) throws SQLException {
		return ChatCrypto.get().decrypt(rs.getString(columnIndex));
	}

	@Override
	public String getNullableResult(CallableStatement cs, int columnIndex) throws SQLException {
		return ChatCrypto.get().decrypt(cs.getString(columnIndex));
	}
}
