</div>
<footer class="footer">
    <div class="container">
        校园头条新闻资讯系统 &nbsp;·&nbsp; J2EE 课程设计 &nbsp;·&nbsp; Spring + SpringMVC + MyBatis/MyBatis-Plus
    </div>
</footer>
<script src="https://cdn.bootcdn.net/ajax/libs/jquery/3.6.4/jquery.min.js"></script>
<script src="https://cdn.bootcdn.net/ajax/libs/twitter-bootstrap/4.6.2/js/bootstrap.bundle.min.js"></script>
<script>
    // 统一 AJAX 错误提示
    $(document).ajaxError(function (event, jqXHR) {
        var msg = '请求失败，请稍后重试';
        try {
            var d = JSON.parse(jqXHR.responseText);
            if (d && d.message) msg = d.message;
        } catch (e) {
            if (jqXHR.status === 401) msg = '请先登录';
            else if (jqXHR.status === 403) msg = '没有操作权限';
        }
        alert(msg);
    });
</script>
</body>
</html>
