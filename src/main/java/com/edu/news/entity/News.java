package com.edu.news.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * 资讯实体类
 */
@Data
@TableName("tb_news")
public class News {

    @TableId(type = IdType.AUTO)
    private Integer id;

    /** 资讯标题 */
    private String title;

    /** 资讯正文 */
    private String content;

    /** 封面图路径 */
    private String cover;

    /** 所属分类ID */
    private Integer categoryId;

    /** 作者ID */
    private Integer authorId;

    /** 状态：0-草稿，1-待审核，2-已发布，3-已驳回 */
    private Integer status;

    /** 浏览量 */
    private Integer viewCount;

    /** 是否置顶头条：0-否，1-是 */
    private Integer isTop;

    /** 发布时间 */
    private LocalDateTime publishTime;

    private LocalDateTime createTime;

    private LocalDateTime updateTime;

    // ========== 非表字段（关联查询使用） ==========
    /** 分类名称 */
    @TableField(exist = false)
    private String categoryName;

    /** 作者昵称 */
    @TableField(exist = false)
    private String authorName;

    /** 格式化后的创建时间（yyyy-MM-dd HH:mm） */
    @TableField(exist = false)
    private String createTimeStr;
}
