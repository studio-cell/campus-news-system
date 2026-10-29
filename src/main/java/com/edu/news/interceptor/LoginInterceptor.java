package com.edu.news.interceptor;

import com.edu.news.entity.User;
import org.springframework.web.servlet.HandlerInterceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * 登录拦截器（SpringMVC 拦截器）
 * <p>
 * 拦截需要登录的访问路径，校验 Session 中是否存在登录用户；未登录时，
 * 对 AJAX 请求返回 JSON 提示，对普通页面请求重定向到登录页。
 * </p>
 */
public class LoginInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
            throws Exception {
        User user = (User) request.getSession().getAttribute("loginUser");
        if (user != null) {
            return true;
        }
        // 判断是否为 AJAX 请求
        String requestedWith = request.getHeader("X-Requested-With");
        if ("XMLHttpRequest".equals(requestedWith)) {
            response.setContentType("application/json;charset=UTF-8");
            response.getWriter().write("{\"code\":401,\"message\":\"请先登录\"}");
        } else {
            response.sendRedirect(request.getContextPath() + "/login");
        }
        return false;
    }
}
