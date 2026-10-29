<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="pageTitle" value="个人中心"/>
<%@include file="../common/header.jsp" %>

<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-6">
            <div class="card p-4">
                <h4 class="mb-3">个人资料</h4>
                <c:if test="${not empty msg}">
                    <div class="alert alert-success py-2">${msg}</div>
                </c:if>
                <form action="${ctx}/user/profile" method="post">
                    <div class="form-group">
                        <label>用户名（不可修改）</label>
                        <input class="form-control" value="${user.username}" disabled>
                    </div>
                    <div class="form-group">
                        <label>昵称</label>
                        <input class="form-control" name="nickname" value="${user.nickname}">
                    </div>
                    <div class="form-group">
                        <label>邮箱</label>
                        <input class="form-control" name="email" value="${user.email}">
                    </div>
                    <div class="form-group">
                        <label>角色</label>
                        <input class="form-control" value="${user.role==1 ? '管理员' : '普通用户'}" disabled>
                    </div>
                    <button class="btn btn-primary">保存资料</button>
                </form>
            </div>
        </div>
    </div>
</div>

<%@include file="../common/footer.jsp" %>
