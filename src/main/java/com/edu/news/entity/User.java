package com.edu.news.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * 用户实体类
 */
@Data
@TableName("tb_user")
public class User {

    @TableId(type = IdType.AUTO)
    private Integer id;

    /** 用户名 */
    private String username;

    /** 密码（MD5加密） */
    private String password;

    /** 昵称 */
    private String nickname;

    /** 邮箱 */
    private String email;

    /** 头像路径 */
    private String avatar;

    /** 角色：0-普通用户，1-管理员 */
    private Integer role;

    /** 状态：0-禁用，1-正常 */
    private Integer status;

    private LocalDateTime createTime;

    private LocalDateTime updateTime;
}
