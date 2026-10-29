<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="pageTitle" value="用户注册"/>
<%@include file="common/header.jsp" %>

<div class="container">
    <div class="row justify-content-center mt-4">
        <div class="col-md-4">
            <div class="card p-4">
                <h4 class="text-center mb-3">注册新账号</h4>
                <c:if test="${not empty error}">
                    <div class="alert alert-danger py-2">${error}</div>
                </c:if>
                <form action="${ctx}/user/register" method="post">
                    <div class="form-group">
                        <label>用户名</label>
                        <input class="form-control" name="username" required>
                    </div>
                    <div class="form-group">
                        <label>昵称</label>
                        <input class="form-control" name="nickname">
                    </div>
                    <div class="form-group">
                        <label>邮箱</label>
                        <input class="form-control" type="email" name="email">
                    </div>
                    <div class="form-group">
                        <label>密码</label>
                        <input class="form-control" type="password" name="password" required>
                    </div>
                    <button class="btn btn-primary btn-block">注册</button>
                    <div class="text-center mt-2 small">
                        <a href="${ctx}/login">已有账号？去登录</a>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<%@include file="common/footer.jsp" %>
