<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<c:set var="loginUser" value="${sessionScope.loginUser}"/>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${empty pageTitle ? '校园头条新闻资讯系统' : pageTitle}</title>
    <link rel="stylesheet" href="https://cdn.bootcdn.net/ajax/libs/twitter-bootstrap/4.6.2/css/bootstrap.min.css">
    <script src="https://cdn.bootcdn.net/ajax/libs/jquery/3.6.4/jquery.min.js"></script>
    <style>
        body { background:#f5f6f8; font-family:"Microsoft YaHei","PingFang SC",sans-serif; }
        .navbar { background:#1e6feb; box-shadow:0 2px 8px rgba(0,0,0,.12); }
        .navbar .navbar-brand { color:#fff; font-weight:700; font-size:20px; }
        .navbar .nav-link, .navbar .dropdown-toggle { color:#fff !important; }
        .navbar .nav-link:hover { color:#ffd !important; }
        .dropdown-menu .dropdown-item:hover { background:#eaf2ff; }
        .content-wrap { min-height:calc(100vh - 130px); padding:20px 0 40px; }
        .footer { background:#1f2a3a; color:#9aa5b1; text-align:center; padding:18px 0; font-size:13px; }
        .card { border:none; border-radius:10px; box-shadow:0 1px 4px rgba(0,0,0,.08); }
        .card:hover { box-shadow:0 4px 16px rgba(30,111,235,.15); transform:translateY(-2px); transition:.25s; }
        .news-cover { height:160px; object-fit:cover; width:100%; border-radius:10px 10px 0 0; }
        .badge-status { font-weight:400; }
    </style>
</head>
<body>
<nav class="navbar navbar-expand-lg">
    <div class="container">
        <a class="navbar-brand" href="${ctx}/">校园头条</a>
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#mainNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="mainNav">
            <ul class="navbar-nav mr-auto">
                <li class="nav-item"><a class="nav-link" href="${ctx}/">首页</a></li>
                <c:if test="${not empty loginUser}">
                    <li class="nav-item"><a class="nav-link" href="${ctx}/news/publish">发布资讯</a></li>
                    <li class="nav-item"><a class="nav-link" href="${ctx}/material">素材管理</a></li>
                </c:if>
            </ul>
            <ul class="navbar-nav">
                <c:choose>
                    <c:when test="${empty loginUser}">
                        <li class="nav-item"><a class="nav-link" href="${ctx}/login">登录</a></li>
                        <li class="nav-item"><a class="nav-link" href="${ctx}/register">注册</a></li>
                    </c:when>
                    <c:otherwise>
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle" data-toggle="dropdown" href="#">
                                ${loginUser.nickname}（${loginUser.role==1 ? '管理员' : '用户'}）
                            </a>
                            <div class="dropdown-menu dropdown-menu-right">
                                <a class="dropdown-item" href="${ctx}/user/profile">个人中心</a>
                                <a class="dropdown-item" href="${ctx}/news/my">我的资讯</a>
                                <a class="dropdown-item" href="${ctx}/material">素材管理</a>
                                <c:if test="${loginUser.role==1}">
                                    <div class="dropdown-divider"></div>
                                    <a class="dropdown-item" href="${ctx}/admin/audit">资讯审核</a>
                                    <a class="dropdown-item" href="${ctx}/admin/logs">审核日志</a>
                                </c:if>
                                <div class="dropdown-divider"></div>
                                <a class="dropdown-item" href="${ctx}/logout">退出登录</a>
                            </div>
                        </li>
                    </c:otherwise>
                </c:choose>
            </ul>
        </div>
    </div>
</nav>
<div class="content-wrap">
