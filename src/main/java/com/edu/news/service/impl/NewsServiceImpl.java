package com.edu.news.service.impl;

import com.baomidou.mybatisplus.core.conditions.update.LambdaUpdateWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.edu.news.common.BusinessException;
import com.edu.news.dto.NewsQueryDTO;
import com.edu.news.entity.News;
import com.edu.news.entity.User;
import com.edu.news.mapper.NewsMapper;
import com.edu.news.mapper.UserMapper;
import com.edu.news.service.NewsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Collections;
import java.util.List;

/**
 * 资讯服务实现
 * <p>
 * 审批、提交、发布等写操作均使用 Spring 声明式事务（@Transactional），
 * 保证状态变更与关联数据的一致性和原子性。
 * </p>
 */
@Service
public class NewsServiceImpl implements NewsService {

    @Autowired
    private NewsMapper newsMapper;

    @Autowired
    private UserMapper userMapper;

    private static final DateTimeFormatter DTF = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");

    @Override
    public IPage<News> page(NewsQueryDTO query, int pageNum, int pageSize) {
        if (query == null) {
            query = new NewsQueryDTO();
        }
        Page<News> page = new Page<>(pageNum, pageSize);
        IPage<News> result = newsMapper.selectNewsPage(page, query);
        fillCreateTime(result.getRecords());
        return result;
    }

    /** 填充格式化后的创建时间 */
    private void fillCreateTime(List<News> list) {
        if (list == null) {
            return;
        }
        list.forEach(n -> {
            if (n.getCreateTime() != null) {
                n.setCreateTimeStr(n.getCreateTime().format(DTF));
            }
        });
    }

    @Override
    public News detail(Integer id) {
        News news = newsMapper.selectNewsDetail(id);
        if (news == null) {
            throw new BusinessException("资讯不存在");
        }
        // 浏览量 +1（直接 SQL 累加，避免并发丢失更新）
        newsMapper.update(null, new LambdaUpdateWrapper<News>()
                .eq(News::getId, id)
                .setSql("view_count = view_count + 1"));
        news.setViewCount(news.getViewCount() + 1);
        fillCreateTime(Collections.singletonList(news));
        return news;
    }

    @Override
    public News getById(Integer id) {
        News news = newsMapper.selectNewsDetail(id);
        if (news == null) {
            throw new BusinessException("资讯不存在");
        }
        fillCreateTime(Collections.singletonList(news));
        return news;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Integer saveDraft(News news) {
        if (news.getTitle() == null || news.getTitle().trim().isEmpty()) {
            throw new BusinessException("资讯标题不能为空");
        }
        if (news.getContent() == null || news.getContent().trim().isEmpty()) {
            throw new BusinessException("资讯正文不能为空");
        }
        if (news.getCategoryId() == null) {
            throw new BusinessException("请选择资讯分类");
        }
        if (news.getId() == null) {
            // 新增草稿
            news.setStatus(0);
            news.setViewCount(0);
            news.setIsTop(0);
            newsMapper.insert(news);
            return news.getId();
        } else {
            // 更新草稿，仅允许状态为草稿或驳回时可编辑
            News exist = newsMapper.selectById(news.getId());
            if (exist == null) {
                throw new BusinessException("资讯不存在");
            }
            if (exist.getStatus() != 0 && exist.getStatus() != 3) {
                throw new BusinessException("当前状态不可编辑");
            }
            exist.setTitle(news.getTitle());
            exist.setContent(news.getContent());
            exist.setCategoryId(news.getCategoryId());
            exist.setCover(news.getCover());
            newsMapper.updateById(exist);
            return exist.getId();
        }
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void submit(Integer id, Integer authorId) {
        News news = requireNews(id);
        checkOwner(news, authorId);
        if (news.getStatus() != 0 && news.getStatus() != 3) {
            throw new BusinessException("当前状态不可提交审核");
        }
        news.setStatus(1); // 待审核
        newsMapper.updateById(news);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void approve(Integer id, Integer auditorId, String comment) {
        News news = requireNews(id);
        if (news.getStatus() != 1) {
            throw new BusinessException("该资讯不在待审核状态");
        }
        news.setStatus(2); // 已发布
        news.setPublishTime(LocalDateTime.now());
        newsMapper.updateById(news);
        // 审核记录由 AOP 切面 AuditLogAspect 统一写入 tb_audit_log
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void reject(Integer id, Integer auditorId, String comment) {
        News news = requireNews(id);
        if (news.getStatus() != 1) {
            throw new BusinessException("该资讯不在待审核状态");
        }
        news.setStatus(3); // 已驳回
        newsMapper.updateById(news);
        // 审核记录由 AOP 切面 AuditLogAspect 统一写入 tb_audit_log
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void setTop(Integer id, Integer isTop) {
        News news = requireNews(id);
        news.setIsTop(isTop);
        newsMapper.updateById(news);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void delete(Integer id, Integer operatorId) {
        News news = requireNews(id);
        User operator = userMapper.selectById(operatorId);
        boolean isAdmin = operator != null && operator.getRole() == 1;
        if (!isAdmin && !news.getAuthorId().equals(operatorId)) {
            throw new BusinessException("无权删除该资讯");
        }
        newsMapper.deleteById(id);
    }

    @Override
    public IPage<News> myNews(Integer authorId, int pageNum, int pageSize) {
        NewsQueryDTO query = new NewsQueryDTO();
        query.setAuthorId(authorId);
        return page(query, pageNum, pageSize);
    }

    // ==================== 私有辅助方法 ====================

    private News requireNews(Integer id) {
        News news = newsMapper.selectById(id);
        if (news == null) {
            throw new BusinessException("资讯不存在");
        }
        return news;
    }

    private void checkOwner(News news, Integer authorId) {
        if (!news.getAuthorId().equals(authorId)) {
            throw new BusinessException("无权操作他人资讯");
        }
    }
}
