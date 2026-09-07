package com.surit.fixer.job.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.surit.fixer.common.FixerGuard;
import com.surit.fixer.job.model.dto.JobDTO;
import com.surit.fixer.job.model.mapper.JobMapper;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class JobServiceImpl implements JobService {

	private final JobMapper  mapper;
	private final FixerGuard fixerGuard;	

	@Override
	@Transactional(readOnly = true)

	public List<JobDTO> getMyJobs(Long fixerNo, String statusCode) {

		fixerGuard.requireApprovedFixer(fixerNo);

		return mapper.selectMyJobs(fixerNo, trimToNull(statusCode));
	}

	@Override
	@Transactional(readOnly = true)

	public JobDTO getMyJob(Long fixerNo, Long requestId) {


		fixerGuard.requireApprovedFixer(fixerNo);

		JobDTO job = mapper.selectMyJob(fixerNo, requestId);

		if (job == null) {
			throw new IllegalStateException("내 작업이 아닙니다.");
		}
		return job;
	}

	@Override
	@Transactional(rollbackFor = Exception.class)

	public void complete(Long fixerNo, Long requestId) {


		fixerGuard.requireApprovedFixer(fixerNo);

		// 여기서 조회해서 if 로 검사하지 않는다.
		// 조회한 뒤 UPDATE 하기 전에 상태가 바뀔 수 있기 때문(TOCTOU).
		// 조건은 전부 UPDATE 의 WHERE 에 들어있고, 결과 건수로 판단한다.
		Long updated = mapper.completeJob(fixerNo, requestId);

		if (updated == 0) {
			throw new IllegalStateException(
					"완료 처리할 수 없습니다. 내 작업이 아니거나 이미 완료된 건입니다.");
		}
	}

	private String trimToNull(String s) {
		if (s == null || s.isBlank()) {
			return null;
		}
		return s.trim();
	}


}
