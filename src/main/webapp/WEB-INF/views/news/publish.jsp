<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="pageTitle" value="${empty news ? '发布资讯' : '编辑资讯'}"/>
<%@include file="../common/header.jsp" %>

<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-9">
            <div class="card p-4">
                <h4 class="mb-3">${empty news ? '发布新资讯' : '编辑资讯'}</h4>
                <form id="newsForm">
                    <input type="hidden" name="id" value="${news.id}">
                    <div class="form-group">
                        <label>标题 <span class="text-danger">*</span></label>
                        <input class="form-control" name="title" id="fTitle" value="${news.title}" required>
                    </div>
                    <div class="form-group">
                        <label>分类 <span class="text-danger">*</span></label>
                        <select class="form-control" name="categoryId" id="fCategory" required>
                            <option value="">请选择分类</option>
                            <c:forEach items="${categories}" var="cat">
                                <option value="${cat.id}" ${news.categoryId==cat.id ? 'selected' : ''}>${cat.name}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>封面图</label>
                        <input type="file" class="form-control-file" id="fCover" accept="image/*">
                        <small class="text-muted">支持 jpg/png 等，不超过 10MB；不上传则使用默认封面</small>
                    </div>
                    <div class="form-group">
                        <label>正文内容 <span class="text-danger">*</span></label>
                        <textarea class="form-control" name="content" id="fContent" rows="12" required>${news.content}</textarea>
                    </div>
                    <div>
                        <button type="button" class="btn btn-secondary" id="btnSave">保存草稿</button>
                        <button type="button" class="btn btn-primary" id="btnSubmit">提交审核</button>
                        <a href="${ctx}/news/my" class="btn btn-light border ml-2">返回我的资讯</a>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<script>
    var newsId = '${empty news ? '' : news.id}';
    var ctx = '${ctx}';

    // 若选择了封面，先调用素材上传接口获取文件路径
    function uploadCoverIfAny() {
        var file = $('#fCover')[0].files[0];
        if (!file) return Promise.resolve('');
        var fd = new FormData();
        fd.append('file', file);
        return $.ajax({
            url: ctx + '/material/upload', type: 'POST', data: fd,
            processData: false, contentType: false, dataType: 'json'
        }).then(function (res) {
            return (res.code === 200 && res.data && res.data.filePath) ? res.data.filePath : '';
        });
    }

    function getFormData() {
        return {
            id: newsId,
            title: $('#fTitle').val(),
            categoryId: $('#fCategory').val(),
            content: $('#fContent').val()
        };
    }

    function saveDraft() {
        return uploadCoverIfAny().then(function (cover) {
            var data = getFormData();
            data.cover = cover;
            return $.ajax({ url: ctx + '/news/saveDraft', type: 'POST', data: data, dataType: 'json' });
        }).then(function (res) {
            if (res.code === 200) {
                if (!newsId) newsId = res.data;
                return res;
            }
            throw new Error(res.message);
        });
    }

    $('#btnSave').click(function () {
        saveDraft().then(function (res) { alert(res.message || '草稿已保存'); });
    });

    $('#btnSubmit').click(function () {
        saveDraft().then(function () {
            return $.ajax({ url: ctx + '/news/submit', type: 'POST', data: { id: newsId }, dataType: 'json' });
        }).then(function (res) {
            if (res.code === 200) { alert('已提交审核'); location.href = ctx + '/news/my'; }
            else { alert(res.message); }
        }).catch(function (e) { alert(e.message || '操作失败'); });
    });
</script>

<%@include file="../common/footer.jsp" %>
