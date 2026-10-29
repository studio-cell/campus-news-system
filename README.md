# 校园头条新闻资讯系统

基于 **SSM（Spring + SpringMVC + MyBatis）** 架构的校园新闻资讯发布与审核平台，为 J2EE 课程设计全栈独立开发项目。

**核心业务流程：**

> 用户注册登录 → 发布/编辑资讯（草稿）→ 提交审核 → 管理员审核（通过/驳回）→ 前台浏览资讯

## ✨ 功能特性

- 用户注册、登录、登出、个人中心
- 资讯发布 / 编辑（草稿 → 提交审核 → 审核发布全流程）
- 管理员审核（通过 / 驳回）、置顶头条、审核日志
- 素材管理（图片 / 视频 / 音频上传）
- 资讯分类浏览、关键词搜索、置顶头条
- Spring AOP 审核日志切面、登录 / 管理员拦截器权限控制、全局异常处理与统一返回格式
- MyBatis-Plus 单表 CRUD 增强与分页插件、动态 SQL 多条件联表查询
- SpringMVC 文件上传、MD5 密码加密、Druid 连接池与声明式事务

## 🛠 技术栈

| 技术 | 版本 | 用途 |
| --- | --- | --- |
| Spring | 5.3.x | IoC 容器、AOP、声明式事务 |
| SpringMVC | 5.3.x | MVC 分层、拦截器、文件上传 |
| MyBatis / MyBatis-Plus | 3.5.x | 持久层 ORM、动态 SQL、分页插件 |
| MySQL | 8.0 | 数据库 |
| Druid | 1.2.x | 数据库连接池 |
| JSP + JSTL + Bootstrap | 4.6 | 前端页面渲染 |
| Maven / Tomcat | 3.6+ / 8.5+ | 构建 / 部署 |

## 📁 目录结构

```
campus-news-system/
├── pom.xml                          # Maven 配置
├── sql/
│   └── campus_news.sql              # 数据库脚本（建库建表 + 初始数据）
├── src/main/java/com/edu/news/
│   ├── aspect/AuditLogAspect.java   # Spring AOP 切面（审核日志）
│   ├── common/                      # 统一返回、业务异常、全局异常处理
│   ├── controller/                  # 控制器（用户/资讯/素材/后台）
│   ├── dto/NewsQueryDTO.java        # 资讯查询参数对象
│   ├── entity/                      # 实体类（5 张表）
│   ├── interceptor/                 # 登录拦截器、管理员拦截器
│   ├── mapper/                      # MyBatis-Plus Mapper 接口
│   ├── service/ + impl/             # 业务接口与实现
│   └── util/Md5Util.java            # MD5 加密工具
├── src/main/resources/
│   ├── jdbc.properties              # 数据库连接配置
│   ├── app.properties               # 上传目录配置
│   ├── mapper/NewsMapper.xml        # 动态 SQL（多条件联表查询）
│   ├── spring-mybatis.xml           # Spring + 数据源 + MyBatis-Plus + 事务 + AOP
│   └── spring-mvc.xml               # SpringMVC 配置（视图、上传、拦截器、静态资源）
└── src/main/webapp/
    ├── WEB-INF/web.xml              # Web 部署描述文件
    └── WEB-INF/views/               # JSP 页面（index、news、user、admin、common）
```

## 🚀 快速开始

1. **初始化数据库**：在 MySQL 中执行 `sql/campus_news.sql`（自动建库建表并写入初始数据）。
2. **配置数据库连接**：修改 `src/main/resources/jdbc.properties` 中的用户名和密码。
3. **配置上传目录**：修改 `src/main/resources/app.properties` 的 `upload.dir` 为本地绝对路径。
4. **启动**：用 IDEA 打开项目，配置本地 Tomcat（war exploded）后运行，访问：

   ```
   http://localhost:8080/campus-news-system/
   ```

   命令行打包部署：

   ```bash
   mvn clean package -DskipTests
   ```

   将 `target/campus-news-system.war` 放入 Tomcat 的 `webapps` 目录并启动 Tomcat。

## 👤 初始账号

| 角色 | 用户名 | 密码 | 说明 |
| --- | --- | --- | --- |
| 管理员 | admin | 123456 | 可审核资讯、置顶头条、管理全部素材 |
| 普通用户 | zhangsan | 123456 | 可发布资讯、上传素材 |

## 📄 文档

- 详细部署说明与常见问题：[部署文档.md](./部署文档.md)
