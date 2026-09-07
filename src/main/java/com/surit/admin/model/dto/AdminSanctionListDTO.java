package com.surit.admin.model.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/** SANCTION 한 줄 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class AdminSanctionListDTO {
	private Long    sanctionId;
	private Long    targetNo;
	private String  targetName;
	private String  userRole;
	private String  sanctionType;    // WARNING / SUSPEND / PERMANENT
	private String  sanctionReason;
	private String  startAt;
	private String  endAt;
	private String  releasedAt;
	private String  adminId;
	private Integer daysLeft;        // 남은 일수 (영구면 null)
}