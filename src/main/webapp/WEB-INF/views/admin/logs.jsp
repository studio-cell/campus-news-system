<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="pageTitle" value="审核日志"/>
<%@include file="../common/header.jsp" %>

<div class="container">
    <h4 class="mb-3">审核日志</h4>
    <div class="card">
        <table class="table table-hover mb-0">
            <thead class="thead-light">
            <tr>
                <th>资讯标题</th>
                <th>审核动作</th>
                <th>审核意见</th>
                <th>审核人</th>
                <th>审核时间</th>
            </tr>
            </thead>
            <tbody>
            <c:choose>
                <c:when test="${empty page.records}">
                    <tr><td colspan="5" class="text-center text-muted py-4">暂无审核记录</td></tr>
                </c:when>
                <c:otherwise>
                    <c:forEach items="${page.records}" var="log">
                        <tr>
                            <td>${log.newsTitle}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${log.action=='APPROVE'}">
                                        <span class="badge badge-success">通过</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge badge-danger">驳回</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>${empty log.comment ? '-' : log.comment}</td>
                            <td>${log.auditorName}</td>
                            <td>${log.auditTime}</td>
                        </tr>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
            </tbody>
        </table>
    </div>
    <nav class="mt-3">
        <ul class="pagination justify-content-center">
            <c:if test="${page.current gt 1}">
                <li class="page-item"><a class="page-link" href="${ctx}/admin/logs?page=${page.current-1}">上一页</a></li>
            </c:if>
            <li class="page-item disabled"><span class="page-link">第 ${page.current} / ${page.pages} 页</span></li>
            <c:if test="${page.current lt page.pages}">
                <li class="page-item"><a class="page-link" href="${ctx}/admin/logs?page=${page.current+1}">下一页</a></li>
            </c:if>
        </ul>
    </nav>
</div>

<%@include file="../common/footer.jsp" %>
