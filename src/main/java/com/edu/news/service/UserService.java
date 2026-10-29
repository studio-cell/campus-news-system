package com.edu.news.service;

import com.edu.news.entity.User;

/**
 * 用户服务接口
 */
public interface UserService {

    /** 注册 */
    User register(User user);

    /** 登录：成功返回用户，失败抛出业务异常 */
    User login(String username, String password);

    /** 根据用户名查询 */
    User getByUsername(String username);

    /** 根据ID查询 */
    User getById(Integer id);

    /** 修改个人资料 */
    void updateProfile(User user);
}
