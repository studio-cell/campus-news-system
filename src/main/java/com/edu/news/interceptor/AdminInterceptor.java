package com.edu.news.interceptor;

import com.edu.news.entity.User;
import org.springframework.web.servlet.HandlerInterceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * 管理员权限拦截器（SpringMVC 拦截器）
 * <p>
 * 拦截 /admin/** 后台管理路径，仅允许角色为管理员（role=1）的用户访问。
 * 由于 /admin/** 同时注册了登录拦截器，能走到这里说明已登录，此处只需校验角色。
 * </p>
 */
public class AdminInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
            throws Exception {
        User user = (User) request.getSession().getAttribute("loginUser");
        if (user == null || user.getRole() == null || user.getRole() != 1) {
            response.sendRedirect(request.getContextPath() + "/");
            return false;
        }
        return true;
    }
}
