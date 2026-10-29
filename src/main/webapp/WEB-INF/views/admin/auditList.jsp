<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="pageTitle" value="资讯审核"/>
<%@include file="../common/header.jsp" %>

<div class="container">
    <h4 class="mb-3">资讯审核</h4>
    <ul class="nav nav-tabs mb-3">
        <li class="nav-item"><a class="nav-link ${status==1 ? 'active' : ''}" href="${ctx}/admin/audit?status=1">待审核</a></li>
        <li class="nav-item"><a class="nav-link ${status==2 ? 'active' : ''}" href="${ctx}/admin/audit?status=2">已发布</a></li>
        <li class="nav-item"><a class="nav-link ${status==3 ? 'active' : ''}" href="${ctx}/admin/audit?status=3">已驳回</a></li>
    </ul>

    <c:choose>
        <c:when test="${empty page.records}">
            <div class="text-center text-muted py-5">暂无该状态的资讯</div>
        </c:when>
        <c:otherwise>
            <div class="card">
                <ul class="list-group list-group-flush">
                    <c:forEach items="${page.records}" var="n">
                        <li class="list-group-item d-flex justify-content-between align-items-center">
                            <div>
                                <strong>${n.title}</strong>
                                <div class="small text-muted">
                                    ${n.categoryName} · 作者 ${n.authorName} · ${n.createTimeStr} · ${n.viewCount} 浏览
                                </div>
                            </div>
                            <div>
                                <a class="btn btn-outline-primary btn-sm" href="${ctx}/admin/audit/detail?id=${n.id}">审核/查看</a>
                                <c:if test="${status==2}">
                                    <button class="btn btn-outline-info btn-sm" onclick="toggleTop(${n.id}, ${n.isTop==1 ? 0 : 1})">
                                        ${n.isTop==1 ? '取消置顶' : '置顶头条'}
                                    </button>
                                </c:if>
                            </div>
                        </li>
                    </c:forEach>
                </ul>
            </div>
            <nav class="mt-3">
                <ul class="pagination justify-content-center">
                    <c:if test="${page.current gt 1}">
                        <li class="page-item"><a class="page-link" href="${ctx}/admin/audit?status=${status}&page=${page.current-1}">上一页</a></li>
                    </c:if>
                    <li class="page-item disabled"><span class="page-link">第 ${page.current} / ${page.pages} 页</span></li>
                    <c:if test="${page.current lt page.pages}">
                        <li class="page-item"><a class="page-link" href="${ctx}/admin/audit?status=${status}&page=${page.current+1}">下一页</a></li>
                    </c:if>
                </ul>
            </nav>
        </c:otherwise>
    </c:choose>
</div>

<script>
    var ctx = '${ctx}';
    function toggleTop(id, isTop) {
        $.ajax({ url: ctx + '/admin/news/top', type: 'POST', data: { id: id, isTop: isTop }, dataType: 'json' })
            .done(function (res) { alert(res.message); if (res.code === 200) location.reload(); })
            .fail(function () { alert('操作失败'); });
    }
</script>

<%@include file="../common/footer.jsp" %>
