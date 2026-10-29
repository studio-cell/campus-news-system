<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="pageTitle" value="${news.title}"/>
<%@include file="../common/header.jsp" %>

<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-9">
            <div class="card p-4">
                <h3 class="mb-2">${news.title}</h3>
                <div class="text-muted small mb-3">
                    <span class="badge badge-info">${news.categoryName}</span> &nbsp;
                    作者：${news.authorName} &nbsp;|&nbsp;
                    时间：${news.createTimeStr} &nbsp;|&nbsp;
                    浏览：${news.viewCount}
                    <c:if test="${news.isTop==1}">
                        <span class="badge badge-danger ml-2">置顶头条</span>
                    </c:if>
                </div>
                <c:if test="${not empty news.cover}">
                    <img src="${ctx}${news.cover}" class="img-fluid rounded mb-3" alt="封面" style="max-height:360px;object-fit:cover;width:100%;">
                </c:if>
                <div style="line-height:1.9;white-space:pre-wrap;">${news.content}</div>
                <c:if test="${not empty loginUser and loginUser.id==news.authorId}">
                    <div class="mt-4">
                        <a class="btn btn-outline-primary btn-sm" href="${ctx}/news/publish?id=${news.id}">编辑此资讯</a>
                    </div>
                </c:if>
            </div>
            <a href="${ctx}/" class="btn btn-light border mt-3">返回首页</a>
        </div>
    </div>
</div>

<%@include file="../common/footer.jsp" %>
