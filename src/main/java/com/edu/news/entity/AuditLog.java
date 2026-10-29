package com.edu.news.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * 审核记录实体类
 */
@Data
@TableName("tb_audit_log")
public class AuditLog {

    @TableId(type = IdType.AUTO)
    private Integer id;

    /** 资讯ID */
    private Integer newsId;

    /** 审核人ID */
    private Integer auditorId;

    /** 动作：APPROVE-通过，REJECT-驳回 */
    private String action;

    /** 审核意见 */
    private String comment;

    private LocalDateTime auditTime;

    // ========== 非表字段 ==========
    /** 资讯标题 */
    @TableField(exist = false)
    private String newsTitle;

    /** 审核人姓名 */
    @TableField(exist = false)
    private String auditorName;
}
