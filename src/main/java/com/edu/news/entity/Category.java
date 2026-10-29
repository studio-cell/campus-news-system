package com.edu.news.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

/**
 * 资讯分类实体类
 */
@Data
@TableName("tb_category")
public class Category {

    @TableId(type = IdType.AUTO)
    private Integer id;

    /** 分类名称 */
    private String name;

    /** 分类描述 */
    private String description;

    /** 排序号 */
    private Integer sort;
}
