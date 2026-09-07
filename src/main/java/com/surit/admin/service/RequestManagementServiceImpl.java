package com.surit.admin.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.surit.admin.model.dto.AdminRequestListDTO;
import com.surit.admin.model.dto.AdminRequestSearchCondition;
import com.surit.admin.model.dto.AdminStatusCountDTO;
import com.surit.admin.model.mapper.RequestManagementMapper;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class RequestManagementServiceImpl implements RequestManagementService {

	private final RequestManagementMapper requestMapper;

	@Override
	@Transactional(readOnly = true)
	public List<AdminStatusCountDTO> getStatusCounts() {
		return requestMapper.selectStatusCounts();
	}

	@Override
	@Transactional(readOnly = true)
	public List<AdminRequestListDTO> getRequestList(AdminRequestSearchCondition cond) {

		// 잘못된 페이지 번호 방어
		if (cond.getPage() < 1) {
			cond.setPage(1);
		}

		// 기간을 거꾸로 넣으면 결과가 0건이라 버그처럼 보인다 -> 바꿔준다
		if (cond.getFromDate() != null && !cond.getFromDate().isBlank()
		 && cond.getToDate()   != null && !cond.getToDate().isBlank()
		 && cond.getFromDate().compareTo(cond.getToDate()) > 0) {
			String tmp = cond.getFromDate();
			cond.setFromDate(cond.getToDate());
			cond.setToDate(tmp);
		}

		cond.setOffset((cond.getPage() - 1) * cond.getSize());
		return requestMapper.selectRequestList(cond);
	}

	@Override
	@Transactional(readOnly = true)
	public int getRequestCount(AdminRequestSearchCondition cond) {
		return requestMapper.selectRequestCount(cond);
	}
}