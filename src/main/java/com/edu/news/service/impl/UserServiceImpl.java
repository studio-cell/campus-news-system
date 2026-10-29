package com.edu.news.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.edu.news.common.BusinessException;
import com.edu.news.entity.User;
import com.edu.news.mapper.UserMapper;
import com.edu.news.service.UserService;
import com.edu.news.util.Md5Util;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * 用户服务实现
 */
@Service
public class UserServiceImpl implements UserService {

    @Autowired
    private UserMapper userMapper;

    @Override
    public User register(User user) {
        if (user.getUsername() == null || user.getUsername().trim().isEmpty()) {
            throw new BusinessException("用户名不能为空");
        }
        if (user.getPassword() == null || user.getPassword().trim().isEmpty()) {
            throw new BusinessException("密码不能为空");
        }
        // 用户名唯一性校验
        Long count = userMapper.selectCount(
                new LambdaQueryWrapper<User>().eq(User::getUsername, user.getUsername()));
        if (count > 0) {
            throw new BusinessException("用户名已存在");
        }
        // 密码 MD5 加密，默认普通用户、正常状态
        user.setPassword(Md5Util.md5(user.getPassword()));
        user.setRole(0);
        user.setStatus(1);
        userMapper.insert(user);
        user.setPassword(null); // 不回显密码
        return user;
    }

    @Override
    public User login(String username, String password) {
        User user = getByUsername(username);
        if (user == null || !Md5Util.matches(password, user.getPassword())) {
            throw new BusinessException("用户名或密码错误");
        }
        if (user.getStatus() != null && user.getStatus() == 0) {
            throw new BusinessException("账号已被禁用");
        }
        user.setPassword(null);
        return user;
    }

    @Override
    public User getByUsername(String username) {
        return userMapper.selectOne(
                new LambdaQueryWrapper<User>().eq(User::getUsername, username));
    }

    @Override
    public User getById(Integer id) {
        User user = userMapper.selectById(id);
        if (user != null) {
            user.setPassword(null);
        }
        return user;
    }

    @Override
    public void updateProfile(User user) {
        User exist = userMapper.selectById(user.getId());
        if (exist == null) {
            throw new BusinessException("用户不存在");
        }
        exist.setNickname(user.getNickname());
        exist.setEmail(user.getEmail());
        if (user.getAvatar() != null && !user.getAvatar().isEmpty()) {
            exist.setAvatar(user.getAvatar());
        }
        userMapper.updateById(exist);
    }
}
