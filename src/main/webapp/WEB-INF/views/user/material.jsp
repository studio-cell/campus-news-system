<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="pageTitle" value="素材管理"/>
<%@include file="../common/header.jsp" %>

<div class="container">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h4>素材管理</h4>
        <div class="input-group" style="max-width:380px;">
            <input type="file" class="form-control-file border p-1 rounded" id="uploadFile" accept="image/*,video/*,audio/*">
            <div class="input-group-append">
                <button class="btn btn-primary" id="btnUpload">上传</button>
            </div>
        </div>
    </div>

    <c:choose>
        <c:when test="${empty page.records}">
            <div class="text-center text-muted py-5">暂无素材，点击右上角上传</div>
        </c:when>
        <c:otherwise>
            <div class="row">
                <c:forEach items="${page.records}" var="m">
                    <div class="col-md-3 mb-3">
                        <div class="card h-100">
                            <c:choose>
                                <c:when test="${m.fileType=='image'}">
                                    <img src="${ctx}${m.filePath}" class="card-img-top" style="height:140px;object-fit:cover;" alt="${m.title}">
                                </c:when>
                                <c:otherwise>
                                    <div class="d-flex align-items-center justify-content-center text-white"
                                         style="height:140px;background:linear-gradient(135deg,#1e6feb,#6aa7f0);">
                                        ${m.fileType}
                                    </div>
                                </c:otherwise>
                            </c:choose>
                            <div class="card-body p-2">
                                <div class="small font-weight-bold text-truncate" title="${m.title}">${m.title}</div>
                                <div class="small text-muted">${m.uploaderName} · ${m.createTimeStr}</div>
                                <div class="text-right">
                                    <button class="btn btn-outline-danger btn-sm" onclick="delMaterial(${m.id})">删除</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
            <nav class="mt-2">
                <ul class="pagination justify-content-center">
                    <c:if test="${page.current gt 1}">
                        <li class="page-item"><a class="page-link" href="${ctx}/material?page=${page.current-1}">上一页</a></li>
                    </c:if>
                    <li class="page-item disabled"><span class="page-link">第 ${page.current} / ${page.pages} 页</span></li>
                    <c:if test="${page.current lt page.pages}">
                        <li class="page-item"><a class="page-link" href="${ctx}/material?page=${page.current+1}">下一页</a></li>
                    </c:if>
                </ul>
            </nav>
        </c:otherwise>
    </c:choose>
</div>

<script>
    var ctx = '${ctx}';
    $('#btnUpload').click(function () {
        var file = $('#uploadFile')[0].files[0];
        if (!file) { alert('请选择文件'); return; }
        var fd = new FormData();
        fd.append('file', file);
        $.ajax({ url: ctx + '/material/upload', type: 'POST', data: fd,
            processData: false, contentType: false, dataType: 'json' })
            .done(function (res) { alert(res.message); if (res.code === 200) location.reload(); })
            .fail(function () { alert('上传失败'); });
    });
    function delMaterial(id) {
        if (!confirm('确定删除该素材吗？')) return;
        $.ajax({ url: ctx + '/material/delete', type: 'POST', data: { id: id }, dataType: 'json' })
            .done(function (res) { alert(res.message); if (res.code === 200) location.reload(); })
            .fail(function () { alert('删除失败'); });
    }
</script>

<%@include file="../common/footer.jsp" %>
