package com.edu.news.controller;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.edu.news.common.Result;
import com.edu.news.dto.NewsQueryDTO;
import com.edu.news.entity.News;
import com.edu.news.entity.User;
import com.edu.news.mapper.CategoryMapper;
import com.edu.news.service.NewsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;

/**
 * 资讯模块控制器：首页浏览、详情、发布草稿、提交审核、我的资讯、删除
 */
@Controller
public class NewsController {

    @Autowired
    private NewsService newsService;

    @Autowired
    private CategoryMapper categoryMapper;

    /** 首页：展示已发布资讯（含置顶头条），支持分类与关键词筛选 */
    @GetMapping("/")
    public String index(@RequestParam(defaultValue = "1") int page,
                        @RequestParam(required = false) Integer categoryId,
                        @RequestParam(required = false) String keyword,
                        Model model) {
        NewsQueryDTO query = new NewsQueryDTO();
        query.setCategoryId(categoryId);
        query.setKeyword(keyword);
        query.setStatus(2); // 仅展示已发布
        IPage<News> result = newsService.page(query, page, 10);

        // 置顶头条
        NewsQueryDTO topQuery = new NewsQueryDTO();
        topQuery.setStatus(2);
        topQuery.setIsTop(1);
        model.addAttribute("topList", newsService.page(topQuery, 1, 5).getRecords());

        model.addAttribute("page", result);
        model.addAttribute("categories", categoryMapper.selectList(null));
        model.addAttribute("categoryId", categoryId);
        model.addAttribute("keyword", keyword);
        return "index";
    }

    /** 资讯详情 */
    @GetMapping("/news/{id}")
    public String detail(@PathVariable Integer id, Model model) {
        model.addAttribute("news", newsService.detail(id));
        return "news/detail";
    }

    /** 发布/编辑草稿页 */
    @GetMapping("/news/publish")
    public String publishPage(@RequestParam(required = false) Integer id, Model model) {
        if (id != null) {
            model.addAttribute("news", newsService.getById(id));
        }
        model.addAttribute("categories", categoryMapper.selectList(null));
        return "news/publish";
    }

    /** 保存草稿 */
    @PostMapping("/news/saveDraft")
    @ResponseBody
    public Result<Integer> saveDraft(News news, HttpSession session) {
        User loginUser = (User) session.getAttribute("loginUser");
        news.setAuthorId(loginUser.getId());
        Integer id = newsService.saveDraft(news);
        return Result.success(id);
    }

    /** 提交审核 */
    @PostMapping("/news/submit")
    @ResponseBody
    public Result<Void> submit(Integer id, HttpSession session) {
        User loginUser = (User) session.getAttribute("loginUser");
        newsService.submit(id, loginUser.getId());
        return Result.success();
    }

    /** 我的资讯 */
    @GetMapping("/news/my")
    public String myNews(@RequestParam(defaultValue = "1") int page, HttpSession session, Model model) {
        User loginUser = (User) session.getAttribute("loginUser");
        model.addAttribute("page", newsService.myNews(loginUser.getId(), page, 10));
        return "news/myNews";
    }

    /** 删除资讯 */
    @PostMapping("/news/delete")
    @ResponseBody
    public Result<Void> delete(Integer id, HttpSession session) {
        User loginUser = (User) session.getAttribute("loginUser");
        newsService.delete(id, loginUser.getId());
        return Result.success();
    }
}
