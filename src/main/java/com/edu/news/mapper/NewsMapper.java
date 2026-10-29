package com.edu.news.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.edu.news.dto.NewsQueryDTO;
import com.edu.news.entity.News;
import org.apache.ibatis.annotations.Param;

/**
 * 资讯 Mapper
 * <p>
 * 除了继承 MyBatis-Plus 的 BaseMapper（自动获得单表 CRUD、分页插件能力）外，
 * 还定义了基于 XML 的动态 SQL 多条件联表查询方法，展示 MyBatis 动态 SQL 的运用。
 * </p>
 */
public interface NewsMapper extends BaseMapper<News> {

    /**
     * 多条件联表分页查询资讯（含分类名、作者昵称）。
     * SQL 在 resources/mapper/NewsMapper.xml 中编写，使用 <where>/<if> 动态拼接条件。
     *
     * @param page  分页参数
     * @param query 查询条件（标题关键词、分类ID、状态、是否置顶等，均可为空）
     * @return 分页结果
     */
    IPage<News> selectNewsPage(Page<News> page, @Param("q") NewsQueryDTO query);

    /**
     * 根据ID查询资讯详情（联表带出分类名、作者昵称）。
     *
     * @param id 资讯ID
     * @return 资讯详情
     */
    News selectNewsDetail(@Param("id") Integer id);
}
