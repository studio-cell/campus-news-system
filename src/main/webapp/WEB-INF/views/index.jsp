<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="pageTitle" value="校园头条 - 首页"/>
<%@include file="common/header.jsp" %>

<div class="container">
    <!-- 搜索栏 -->
    <form class="row mb-3" action="${ctx}/" method="get">
        <input type="hidden" name="categoryId" value="${categoryId}">
        <div class="col-md-5 offset-md-2">
            <input type="text" class="form-control" name="keyword" value="${keyword}"
                   placeholder="搜索资讯标题...">
        </div>
        <div class="col-md-3">
            <button type="submit" class="btn btn-primary btn-block">搜索</button>
        </div>
    </form>

    <!-- 分类导航 -->
    <div class="mb-3">
        <a class="btn btn-sm ${empty categoryId ? 'btn-primary' : 'btn-light border'}"
           href="${ctx}/">全部</a>
        <c:forEach items="${categories}" var="cat">
            <a class="btn btn-sm ${categoryId==cat.id ? 'btn-primary' : 'btn-light border'}"
               href="${ctx}/?categoryId=${cat.id}">${cat.name}</a>
        </c:forEach>
    </div>

    <!-- 置顶头条 -->
    <c:if test="${not empty topList}">
        <div class="card mb-4 p-3" style="border-left:5px solid #1e6feb;">
            <div class="d-flex align-items-center mb-2">
                <span class="badge badge-danger mr-2">置顶头条</span>
                <span class="text-muted small">今日要闻</span>
            </div>
            <div class="row">
                <c:forEach items="${topList}" var="top">
                    <div class="col-md-6 col-lg-4 mb-2">
                        <a href="${ctx}/news/${top.id}" class="text-dark">
                            <strong>${top.title}</strong>
                        </a>
                        <div class="small text-muted">${top.categoryName} · ${top.viewCount} 浏览</div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </c:if>

    <!-- 资讯列表 -->
    <c:choose>
        <c:when test="${empty page.records}">
            <div class="text-center text-muted py-5">暂无相关资讯</div>
        </c:when>
        <c:otherwise>
            <div class="row">
                <c:forEach items="${page.records}" var="n">
                    <div class="col-md-6 col-lg-4 mb-4">
                        <div class="card h-100">
                            <a href="${ctx}/news/${n.id}">
                                <c:choose>
                                    <c:when test="${not empty n.cover}">
                                        <img class="news-cover" src="${ctx}${n.cover}" alt="${n.title}">
                                    </c:when>
                                    <c:otherwise>
                                        <div class="news-cover d-flex align-items-center justify-content-center text-white"
                                             style="background:linear-gradient(135deg,#1e6feb,#6aa7f0);">
                                            校园头条
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </a>
                            <div class="card-body">
                                <h6 class="card-title">
                                    <a href="${ctx}/news/${n.id}" class="text-dark">${n.title}</a>
                                </h6>
                                <div class="d-flex justify-content-between align-items-center">
                                    <span class="badge badge-info">${n.categoryName}</span>
                                    <small class="text-muted">${n.viewCount} 浏览</small>
                                </div>
                                <small class="text-muted d-block mt-2">
                                    ${n.createTimeStr} · ${n.authorName}
                                </small>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>

            <!-- 分页 -->
            <nav class="mt-3">
                <ul class="pagination justify-content-center">
                    <c:if test="${page.current gt 1}">
                        <li class="page-item">
                            <a class="page-link" href="${ctx}/?page=${page.current-1}&categoryId=${categoryId}&keyword=${keyword}">上一页</a>
                        </li>
                    </c:if>
                    <li class="page-item disabled">
                        <span class="page-link">第 ${page.current} / ${page.pages} 页，共 ${page.total} 条</span>
                    </li>
                    <c:if test="${page.current lt page.pages}">
                        <li class="page-item">
                            <a class="page-link" href="${ctx}/?page=${page.current+1}&categoryId=${categoryId}&keyword=${keyword}">下一页</a>
                        </li>
                    </c:if>
                </ul>
            </nav>
        </c:otherwise>
    </c:choose>
</div>

<%@include file="common/footer.jsp" %>
