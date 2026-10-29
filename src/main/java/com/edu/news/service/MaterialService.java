package com.edu.news.service;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.edu.news.entity.Material;
import org.springframework.web.multipart.MultipartFile;

/**
 * 素材服务接口
 */
public interface MaterialService {

    /** 上传素材（文件存储 + 记录入库） */
    Material upload(MultipartFile file, Integer uploaderId, String title);

    /** 分页查询素材（管理员查全部，普通用户查自己的） */
    IPage<Material> page(Integer userId, boolean isAdmin, int pageNum, int pageSize);

    /** 删除素材（仅上传者或管理员） */
    void delete(Integer id, Integer userId);
}
