<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="pageTitle" value="我的资讯"/>
<%@include file="../common/header.jsp" %>

<div class="container">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h4>我的资讯</h4>
        <a href="${ctx}/news/publish" class="btn btn-primary btn-sm">发布新资讯</a>
    </div>

    <c:choose>
        <c:when test="${empty page.records}">
            <div class="text-center text-muted py-5">还没有发布任何资讯</div>
        </c:when>
        <c:otherwise>
            <div class="card">
                <ul class="list-group list-group-flush">
                    <c:forEach items="${page.records}" var="n">
                        <li class="list-group-item">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <a href="${ctx}/news/${n.id}" class="text-dark font-weight-bold">${n.title}</a>
                                    <div class="small text-muted">
                                        ${n.createTimeStr} · ${n.viewCount} 浏览
                                        <c:if test="${n.isTop==1}"><span class="badge badge-danger ml-1">置顶</span></c:if>
                                    </div>
                                </div>
                                <div class="text-right">
                                    <c:choose>
                                        <c:when test="${n.status==0}">
                                            <span class="badge badge-secondary">草稿</span>
                                        </c:when>
                                        <c:when test="${n.status==1}">
                                            <span class="badge badge-warning">待审核</span>
                                        </c:when>
                                        <c:when test="${n.status==2}">
                                            <span class="badge badge-success">已发布</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge badge-danger">已驳回</span>
                                        </c:otherwise>
                                    </c:choose>
                                    <div class="mt-1">
                                        <c:if test="${n.status==0 || n.status==3}">
                                            <a class="btn btn-outline-primary btn-sm" href="${ctx}/news/publish?id=${n.id}">编辑</a>
                                            <button class="btn btn-outline-info btn-sm" onclick="submitAudit(${n.id})">提交审核</button>
                                        </c:if>
                                        <button class="btn btn-outline-danger btn-sm" onclick="delNews(${n.id})">删除</button>
                                    </div>
                                </div>
                            </div>
                        </li>
                    </c:forEach>
                </ul>
            </div>
            <nav class="mt-3">
                <ul class="pagination justify-content-center">
                    <c:if test="${page.current gt 1}">
                        <li class="page-item"><a class="page-link" href="${ctx}/news/my?page=${page.current-1}">上一页</a></li>
                    </c:if>
                    <li class="page-item disabled"><span class="page-link">第 ${page.current} / ${page.pages} 页</span></li>
                    <c:if test="${page.current lt page.pages}">
                        <li class="page-item"><a class="page-link" href="${ctx}/news/my?page=${page.current+1}">下一页</a></li>
                    </c:if>
                </ul>
            </nav>
        </c:otherwise>
    </c:choose>
</div>

<script>
    var ctx = '${ctx}';
    function submitAudit(id) {
        if (!confirm('确定提交审核吗？')) return;
        $.ajax({ url: ctx + '/news/submit', type: 'POST', data: { id: id }, dataType: 'json' })
            .done(function (res) { alert(res.message); if (res.code === 200) location.reload(); })
            .fail(function () { alert('操作失败'); });
    }
    function delNews(id) {
        if (!confirm('确定删除该资讯吗？删除后不可恢复。')) return;
        $.ajax({ url: ctx + '/news/delete', type: 'POST', data: { id: id }, dataType: 'json' })
            .done(function (res) { alert(res.message); if (res.code === 200) location.reload(); })
            .fail(function () { alert('操作失败'); });
    }
</script>

<%@include file="../common/footer.jsp" %>
