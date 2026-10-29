package com.edu.news.controller;

import com.edu.news.common.BusinessException;
import com.edu.news.entity.User;
import com.edu.news.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import javax.servlet.http.HttpSession;

/**
 * 用户模块控制器：注册、登录、登出、个人中心
 */
@Controller
public class UserController {

    @Autowired
    private UserService userService;

    /** 登录页 */
    @GetMapping("/login")
    public String loginPage() {
        return "login";
    }

    /** 注册页 */
    @GetMapping("/register")
    public String registerPage() {
        return "register";
    }

    /** 处理登录 */
    @PostMapping("/user/login")
    public String login(String username, String password, HttpSession session, Model model) {
        try {
            User user = userService.login(username, password);
            session.setAttribute("loginUser", user);
            return "redirect:/";
        } catch (BusinessException e) {
            model.addAttribute("error", e.getMessage());
            model.addAttribute("username", username);
            return "login";
        }
    }

    /** 处理注册 */
    @PostMapping("/user/register")
    public String register(User user, Model model) {
        try {
            userService.register(user);
            return "redirect:/login";
        } catch (BusinessException e) {
            model.addAttribute("error", e.getMessage());
            return "register";
        }
    }

    /** 登出 */
    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/";
    }

    /** 个人中心 */
    @GetMapping("/user/profile")
    public String profile(HttpSession session, Model model) {
        User loginUser = (User) session.getAttribute("loginUser");
        model.addAttribute("user", userService.getById(loginUser.getId()));
        return "user/profile";
    }

    /** 修改个人资料 */
    @PostMapping("/user/profile")
    public String updateProfile(User user, HttpSession session, Model model) {
        User loginUser = (User) session.getAttribute("loginUser");
        user.setId(loginUser.getId());
        userService.updateProfile(user);
        User updated = userService.getById(loginUser.getId());
        session.setAttribute("loginUser", updated);
        model.addAttribute("user", updated);
        model.addAttribute("msg", "资料保存成功");
        return "user/profile";
    }
}
