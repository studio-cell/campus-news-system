<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="pageTitle" value="资讯审核详情"/>
<%@include file="../common/header.jsp" %>

<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-9">
            <div class="card p-4">
                <h4 class="mb-2">${news.title}</h4>
                <div class="text-muted small mb-3">
                    <span class="badge badge-info">${news.categoryName}</span> &nbsp;
                    作者：${news.authorName} &nbsp;|&nbsp; 时间：${news.createTimeStr} &nbsp;|&nbsp; 浏览：${news.viewCount}
                    <c:choose>
                        <c:when test="${news.status==1}"><span class="badge badge-warning ml-1">待审核</span></c:when>
                        <c:when test="${news.status==2}"><span class="badge badge-success ml-1">已发布</span></c:when>
                        <c:when test="${news.status==3}"><span class="badge badge-danger ml-1">已驳回</span></c:when>
                        <c:otherwise><span class="badge badge-secondary ml-1">草稿</span></c:otherwise>
                    </c:choose>
                </div>
                <c:if test="${not empty news.cover}">
                    <img src="${ctx}${news.cover}" class="img-fluid rounded mb-3" style="max-height:320px;object-fit:cover;width:100%;" alt="封面">
                </c:if>
                <div style="line-height:1.9;white-space:pre-wrap;">${news.content}</div>

                <c:if test="${news.status==1}">
                    <hr>
                    <h6>审核操作</h6>
                    <div class="form-group">
                        <label>审核意见</label>
                        <textarea class="form-control" id="comment" rows="3" placeholder="请输入审核意见（可选）"></textarea>
                    </div>
                    <div>
                        <button class="btn btn-success" id="btnApprove">通过并发布</button>
                        <button class="btn btn-danger" id="btnReject">驳回</button>
                    </div>
                </c:if>
            </div>
            <a href="${ctx}/admin/audit" class="btn btn-light border mt-3">返回审核列表</a>
        </div>
    </div>
</div>

<script>
    var ctx = '${ctx}';
    var newsId = ${news.id};
    $('#btnApprove').click(function () {
        $.ajax({ url: ctx + '/admin/audit/approve', type: 'POST', data: { id: newsId, comment: $('#comment').val() }, dataType: 'json' })
            .done(function (res) { alert(res.message); if (res.code === 200) location.href = ctx + '/admin/audit'; })
            .fail(function () { alert('操作失败'); });
    });
    $('#btnReject').click(function () {
        if (!confirm('确定驳回该资讯吗？')) return;
        $.ajax({ url: ctx + '/admin/audit/reject', type: 'POST', data: { id: newsId, comment: $('#comment').val() }, dataType: 'json' })
            .done(function (res) { alert(res.message); if (res.code === 200) location.href = ctx + '/admin/audit'; })
            .fail(function () { alert('操作失败'); });
    });
</script>

<%@include file="../common/footer.jsp" %>
