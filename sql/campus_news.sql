-- =============================================================
-- 校园头条新闻资讯系统 数据库脚本
-- 数据库：MySQL 8.0+
-- 编码：utf8mb4
-- =============================================================

DROP DATABASE IF EXISTS campus_news;
CREATE DATABASE IF NOT EXISTS campus_news DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE campus_news;

-- -------------------------------------------------------------
-- 1. 用户表
-- -------------------------------------------------------------
DROP TABLE IF EXISTS tb_user;
CREATE TABLE tb_user (
    id          INT PRIMARY KEY AUTO_INCREMENT COMMENT '用户ID',
    username    VARCHAR(50)  NOT NULL UNIQUE COMMENT '用户名',
    password    VARCHAR(100) NOT NULL COMMENT '密码(MD5加密)',
    nickname    VARCHAR(50)  DEFAULT NULL COMMENT '昵称',
    email       VARCHAR(100) DEFAULT NULL COMMENT '邮箱',
    avatar      VARCHAR(255) DEFAULT NULL COMMENT '头像路径',
    role        TINYINT      NOT NULL DEFAULT 0 COMMENT '角色 0-普通用户 1-管理员',
    status      TINYINT      NOT NULL DEFAULT 1 COMMENT '状态 0-禁用 1-正常',
    create_time DATETIME     DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME     DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户表';

-- -------------------------------------------------------------
-- 2. 资讯分类表
-- -------------------------------------------------------------
DROP TABLE IF EXISTS tb_category;
CREATE TABLE tb_category (
    id          INT PRIMARY KEY AUTO_INCREMENT COMMENT '分类ID',
    name        VARCHAR(50)  NOT NULL COMMENT '分类名称',
    description VARCHAR(255) DEFAULT NULL COMMENT '分类描述',
    sort        INT          NOT NULL DEFAULT 0 COMMENT '排序号'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='资讯分类表';

-- -------------------------------------------------------------
-- 3. 素材表
-- -------------------------------------------------------------
DROP TABLE IF EXISTS tb_material;
CREATE TABLE tb_material (
    id          INT PRIMARY KEY AUTO_INCREMENT COMMENT '素材ID',
    title       VARCHAR(100) NOT NULL COMMENT '素材标题',
    file_path   VARCHAR(255) NOT NULL COMMENT '素材存储路径',
    file_type   VARCHAR(20)  NOT NULL COMMENT '素材类型 image/video/audio',
    file_size   BIGINT       DEFAULT 0 COMMENT '素材大小(字节)',
    uploader_id INT          NOT NULL COMMENT '上传者ID',
    create_time DATETIME     DEFAULT CURRENT_TIMESTAMP COMMENT '上传时间',
    CONSTRAINT fk_material_user FOREIGN KEY (uploader_id) REFERENCES tb_user(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='素材表';

-- -------------------------------------------------------------
-- 4. 资讯表
-- -------------------------------------------------------------
DROP TABLE IF EXISTS tb_news;
CREATE TABLE tb_news (
    id           INT PRIMARY KEY AUTO_INCREMENT COMMENT '资讯ID',
    title        VARCHAR(200) NOT NULL COMMENT '资讯标题',
    content      TEXT         NOT NULL COMMENT '资讯正文',
    cover        VARCHAR(255) DEFAULT NULL COMMENT '封面图路径',
    category_id  INT          NOT NULL COMMENT '所属分类ID',
    author_id    INT          NOT NULL COMMENT '作者ID',
    status       TINYINT      NOT NULL DEFAULT 0 COMMENT '状态 0-草稿 1-待审核 2-已发布 3-已驳回',
    view_count   INT          NOT NULL DEFAULT 0 COMMENT '浏览量',
    is_top       TINYINT      NOT NULL DEFAULT 0 COMMENT '是否置顶头条 0-否 1-是',
    publish_time DATETIME     DEFAULT NULL COMMENT '发布时间',
    create_time  DATETIME     DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time  DATETIME     DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    CONSTRAINT fk_news_category FOREIGN KEY (category_id) REFERENCES tb_category(id),
    CONSTRAINT fk_news_user FOREIGN KEY (author_id) REFERENCES tb_user(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='资讯表';

-- -------------------------------------------------------------
-- 5. 审核记录表
-- -------------------------------------------------------------
DROP TABLE IF EXISTS tb_audit_log;
CREATE TABLE tb_audit_log (
    id          INT PRIMARY KEY AUTO_INCREMENT COMMENT '记录ID',
    news_id     INT          NOT NULL COMMENT '资讯ID',
    auditor_id  INT          NOT NULL COMMENT '审核人ID',
    action      VARCHAR(20)  NOT NULL COMMENT '动作 APPROVE-通过 REJECT-驳回',
    comment     VARCHAR(255) DEFAULT NULL COMMENT '审核意见',
    audit_time  DATETIME     DEFAULT CURRENT_TIMESTAMP COMMENT '审核时间',
    CONSTRAINT fk_audit_news FOREIGN KEY (news_id) REFERENCES tb_news(id),
    CONSTRAINT fk_audit_user FOREIGN KEY (auditor_id) REFERENCES tb_user(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='审核记录表';

-- =============================================================
-- 初始数据
-- =============================================================

-- 管理员账号：admin / 123456  （密码为MD5加密：e10adc3949ba59abbe56e057f20f883e）
-- 测试用户：zhangsan / 123456
INSERT INTO tb_user (username, password, nickname, email, role, status) VALUES
('admin',    'e10adc3949ba59abbe56e057f20f883e', '系统管理员', 'admin@edu.cn',    1, 1),
('zhangsan', 'e10adc3949ba59abbe56e057f20f883e', '张三',       'zhangsan@edu.cn', 0, 1);

-- 资讯分类
INSERT INTO tb_category (name, description, sort) VALUES
('校园新闻', '校园内最新动态、活动报道', 1),
('学术科研', '学术讲座、科研成果、竞赛信息', 2),
('社团活动', '各社团活动通知与报道', 3),
('就业招聘', '校园招聘、实习信息、就业指导', 4),
('生活服务', '校园生活指南、便民服务信息', 5);

-- 示例素材（由管理员上传）
INSERT INTO tb_material (title, file_path, file_type, file_size, uploader_id) VALUES
('校园风光图', '/upload/cover_campus1.jpg', 'image', 204800, 1),
('迎新晚会照片', '/upload/cover_party.jpg',  'image', 307200, 1);

-- 示例资讯（两条已发布）
INSERT INTO tb_news (title, content, cover, category_id, author_id, status, view_count, is_top, publish_time) VALUES
('学校隆重举行2026级新生开学典礼', '金秋九月，丹桂飘香。学校在体育馆隆重举行2026级新生开学典礼，校领导、各院系负责人及全体新生参加。校长在致辞中勉励新生珍惜大学时光，脚踏实地，志存高远。', '/upload/cover_campus1.jpg', 1, 1, 2, 128, 1, NOW()),
('图书馆举办"书香校园"阅读推广活动', '为营造浓厚的学习氛围，图书馆于本周举办"书香校园"阅读推广活动，活动包括好书推荐、读书分享会、经典诵读等环节，欢迎广大师生积极参与。', '/upload/cover_news2.jpg', 5, 1, 2, 86, 0, NOW());

-- 示例审核记录
INSERT INTO tb_audit_log (news_id, auditor_id, action, comment) VALUES
(1, 1, 'APPROVE', '内容真实，通过审核'),
(2, 1, 'APPROVE', '符合规范，准予发布');
