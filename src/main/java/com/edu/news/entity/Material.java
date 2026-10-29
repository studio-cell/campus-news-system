package com.edu.news.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * 素材实体类
 */
@Data
@TableName("tb_material")
public class Material {

    @TableId(type = IdType.AUTO)
    private Integer id;

    /** 素材标题 */
    private String title;

    /** 素材存储路径 */
    private String filePath;

    /** 素材类型：image/video/audio */
    private String fileType;

    /** 素材大小（字节） */
    private Long fileSize;

    /** 上传者ID */
    private Integer uploaderId;

    private LocalDateTime createTime;

    /** 非表字段：上传者昵称 */
    @TableField(exist = false)
    private String uploaderName;

    /** 非表字段：格式化后的上传时间 */
    @TableField(exist = false)
    private String createTimeStr;
}
