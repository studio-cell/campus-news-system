package com.edu.news.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.edu.news.common.BusinessException;
import com.edu.news.entity.Material;
import com.edu.news.entity.User;
import com.edu.news.mapper.MaterialMapper;
import com.edu.news.mapper.UserMapper;
import com.edu.news.service.MaterialService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.util.Arrays;
import java.util.List;

/**
 * 素材服务实现（含文件上传）
 */
@Service
public class MaterialServiceImpl implements MaterialService {

    /** 支持的文件类型 */
    private static final List<String> IMAGE_TYPES = Arrays.asList("jpg", "jpeg", "png", "gif", "bmp", "webp");
    private static final List<String> VIDEO_TYPES = Arrays.asList("mp4", "avi", "mov", "mkv", "webm");
    private static final List<String> AUDIO_TYPES = Arrays.asList("mp3", "wav", "flac", "aac");

    @Autowired
    private MaterialMapper materialMapper;

    @Autowired
    private UserMapper userMapper;

    /** 上传文件保存目录（由配置文件注入） */
    @Value("${upload.dir}")
    private String uploadDir;

    @Override
    public Material upload(MultipartFile file, Integer uploaderId, String title) {
        if (file == null || file.isEmpty()) {
            throw new BusinessException("请选择要上传的文件");
        }
        String original = file.getOriginalFilename() == null ? "file" : file.getOriginalFilename();
        String ext = original.contains(".")
                ? original.substring(original.lastIndexOf('.') + 1).toLowerCase()
                : "";

        String type;
        if (IMAGE_TYPES.contains(ext)) {
            type = "image";
        } else if (VIDEO_TYPES.contains(ext)) {
            type = "video";
        } else if (AUDIO_TYPES.contains(ext)) {
            type = "audio";
        } else {
            throw new BusinessException("不支持的文件类型");
        }

        // 生成防冲突文件名并保存到本地目录
        String newName = System.currentTimeMillis() + "_" + (System.nanoTime() % 10000) + "." + ext;
        File dir = new File(uploadDir);
        if (!dir.exists() && !dir.mkdirs()) {
            throw new BusinessException("上传目录创建失败");
        }
        try {
            file.transferTo(new File(dir, newName));
        } catch (IOException e) {
            throw new BusinessException("文件保存失败");
        }

        Material material = new Material();
        material.setTitle(title == null || title.trim().isEmpty() ? original : title);
        material.setFilePath("/upload/" + newName);
        material.setFileType(type);
        material.setFileSize(file.getSize());
        material.setUploaderId(uploaderId);
        materialMapper.insert(material);
        return material;
    }

    @Override
    public IPage<Material> page(Integer userId, boolean isAdmin, int pageNum, int pageSize) {
        Page<Material> page = new Page<>(pageNum, pageSize);
        LambdaQueryWrapper<Material> wrapper = new LambdaQueryWrapper<>();
        if (!isAdmin) {
            wrapper.eq(Material::getUploaderId, userId);
        }
        wrapper.orderByDesc(Material::getCreateTime);
        IPage<Material> result = materialMapper.selectPage(page, wrapper);
        // 填充上传者昵称与格式化时间
        result.getRecords().forEach(m -> {
            if (m.getCreateTime() != null) {
                m.setCreateTimeStr(m.getCreateTime()
                        .format(java.time.format.DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm")));
            }
            User u = userMapper.selectById(m.getUploaderId());
            if (u != null) {
                m.setUploaderName(u.getNickname() != null ? u.getNickname() : u.getUsername());
            }
        });
        return result;
    }

    @Override
    public void delete(Integer id, Integer userId) {
        Material material = materialMapper.selectById(id);
        if (material == null) {
            throw new BusinessException("素材不存在");
        }
        User user = userMapper.selectById(userId);
        boolean isAdmin = user != null && user.getRole() == 1;
        if (!isAdmin && !material.getUploaderId().equals(userId)) {
            throw new BusinessException("无权删除该素材");
        }
        // 删除本地文件
        File f = new File(uploadDir, new File(material.getFilePath()).getName());
        if (f.exists()) {
            f.delete();
        }
        materialMapper.deleteById(id);
    }
}
