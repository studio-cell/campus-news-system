package com.edu.news.controller;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.edu.news.common.Result;
import com.edu.news.dto.NewsQueryDTO;
import com.edu.news.entity.AuditLog;
import com.edu.news.entity.News;
import com.edu.news.entity.User;
import com.edu.news.mapper.AuditLogMapper;
import com.edu.news.mapper.NewsMapper;
import com.edu.news.service.NewsService;
import com.edu.news.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;

/**
 * 后台管理控制器（需管理员权限，由 AdminInterceptor 拦截校验）
 */
@Controller
@RequestMapping("/admin")
public class AdminController {

    @Autowired
    private NewsService newsService;

    @Autowired
    private AuditLogMapper auditLogMapper;

    @Autowired
    private NewsMapper newsMapper;

    @Autowired
    private UserService userService;

    /** 审核列表（默认展示待审核） */
    @GetMapping("/audit")
    public String auditList(@RequestParam(defaultValue = "1") int page,
                            @RequestParam(required = false) Integer status,
                            Model model) {
        int s = (status == null) ? 1 : status;
        NewsQueryDTO query = new NewsQueryDTO();
        query.setStatus(s);
        model.addAttribute("page", newsService.page(query, page, 10));
        model.addAttribute("status", s);
        return "admin/auditList";
    }

    /** 审核详情 */
    @GetMapping("/audit/detail")
    public String auditDetail(Integer id, Model model) {
        model.addAttribute("news", newsService.getById(id));
        return "admin/auditDetail";
    }

    /** 审核通过 */
    @PostMapping("/audit/approve")
    @ResponseBody
    public Result<String> approve(Integer id, String comment, HttpSession session) {
        User loginUser = (User) session.getAttribute("loginUser");
        newsService.approve(id, loginUser.getId(), comment);
        return Result.success("审核通过");
    }

    /** 审核驳回 */
    @PostMapping("/audit/reject")
    @ResponseBody
    public Result<String> reject(Integer id, String comment, HttpSession session) {
        User loginUser = (User) session.getAttribute("loginUser");
        newsService.reject(id, loginUser.getId(), comment);
        return Result.success("已驳回");
    }

    /** 设置/取消置顶头条 */
    @PostMapping("/news/top")
    @ResponseBody
    public Result<String> setTop(Integer id, Integer isTop) {
        newsService.setTop(id, isTop);
        return Result.success("操作成功");
    }

    /** 审核日志 */
    @GetMapping("/logs")
    public String logs(@RequestParam(defaultValue = "1") int page, Model model) {
        Page<AuditLog> p = new Page<>(page, 10);
        LambdaQueryWrapper<AuditLog> wrapper = new LambdaQueryWrapper<>();
        wrapper.orderByDesc(AuditLog::getAuditTime);
        IPage<AuditLog> result = auditLogMapper.selectPage(p, wrapper);
        result.getRecords().forEach(log -> {
            News news = newsMapper.selectById(log.getNewsId());
            if (news != null) {
                log.setNewsTitle(news.getTitle());
            }
            User auditor = userService.getById(log.getAuditorId());
            if (auditor != null) {
                log.setAuditorName(auditor.getNickname() != null ? auditor.getNickname() : auditor.getUsername());
            }
        });
        model.addAttribute("page", result);
        return "admin/logs";
    }
}
