package com.edu.news.controller;

import com.edu.news.common.Result;
import com.edu.news.entity.Material;
import com.edu.news.entity.User;
import com.edu.news.service.MaterialService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpSession;

/**
 * 素材模块控制器：上传、分页浏览、删除
 */
@Controller
@RequestMapping("/material")
public class MaterialController {

    @Autowired
    private MaterialService materialService;

    /** 素材管理页 */
    @GetMapping("")
    public String page(@RequestParam(defaultValue = "1") int page, HttpSession session, Model model) {
        User loginUser = (User) session.getAttribute("loginUser");
        boolean isAdmin = loginUser.getRole() != null && loginUser.getRole() == 1;
        model.addAttribute("page", materialService.page(loginUser.getId(), isAdmin, page, 12));
        return "user/material";
    }

    /** 上传素材 */
    @PostMapping("/upload")
    @ResponseBody
    public Result<Material> upload(@RequestParam("file") MultipartFile file,
                               @RequestParam(required = false) String title,
                               HttpSession session) {
        User loginUser = (User) session.getAttribute("loginUser");
        Material material = materialService.upload(file, loginUser.getId(), title);
        return Result.success(material, "上传成功");
    }

    /** 删除素材 */
    @PostMapping("/delete")
    @ResponseBody
    public Result<String> delete(Integer id, HttpSession session) {
        User loginUser = (User) session.getAttribute("loginUser");
        materialService.delete(id, loginUser.getId());
        return Result.success("删除成功");
    }
}
