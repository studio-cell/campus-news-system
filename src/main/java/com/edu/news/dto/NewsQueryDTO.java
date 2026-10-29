package com.edu.news.dto;

import lombok.Data;

/**
 * 资讯多条件查询参数 DTO
 */
@Data
public class NewsQueryDTO {

    /** 标题关键词（模糊查询，可为空） */
    private String keyword;

    /** 分类ID（可为空） */
    private Integer categoryId;

    /** 资讯状态（可为空，0-草稿 1-待审核 2-已发布 3-已驳回） */
    private Integer status;

    /** 是否置顶头条（可为空） */
    private Integer isTop;

    /** 作者ID（查询某人发布的资讯时使用，可为空） */
    private Integer authorId;
}
