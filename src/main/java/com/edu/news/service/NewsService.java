package com.edu.news.service;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.edu.news.dto.NewsQueryDTO;
import com.edu.news.entity.News;

/**
 * 资讯服务接口
 */
public interface NewsService {

    /** 多条件分页查询（使用 MyBatis 动态 SQL 联表查询） */
    IPage<News> page(NewsQueryDTO query, int pageNum, int pageSize);

    /** 资讯详情（浏览量 +1） */
    News detail(Integer id);

    /** 根据ID查询资讯（不累加浏览量，用于草稿编辑、审核详情等） */
    News getById(Integer id);

    /** 保存草稿（新增或更新），返回资讯ID */
    Integer saveDraft(News news);

    /** 提交审核：草稿/驳回 -> 待审核 */
    void submit(Integer id, Integer authorId);

    /** 审核通过：待审核 -> 已发布 */
    void approve(Integer id, Integer auditorId, String comment);

    /** 审核驳回：待审核 -> 已驳回 */
    void reject(Integer id, Integer auditorId, String comment);

    /** 设置/取消置顶头条 */
    void setTop(Integer id, Integer isTop);

    /** 删除资讯（仅作者或管理员） */
    void delete(Integer id, Integer operatorId);

    /** 我的资讯 */
    IPage<News> myNews(Integer authorId, int pageNum, int pageSize);
}
