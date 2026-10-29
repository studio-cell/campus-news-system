package com.edu.news.aspect;

import com.edu.news.entity.AuditLog;
import com.edu.news.mapper.AuditLogMapper;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Pointcut;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

/**
 * 审核操作日志切面（Spring AOP 环绕通知）
 * <p>
 * 审核通过/驳回操作会改变资讯状态，属于关键业务动作。为将"记录审核日志"这一
 * 横切关注点与核心业务逻辑解耦，这里使用 Spring AOP：当 NewsService 的
 * approve / reject 方法成功执行后，由本切面自动向 tb_audit_log 写入一条审核记录。
 * </p>
 */
@Aspect
@Component
public class AuditLogAspect {

    @Autowired
    private AuditLogMapper auditLogMapper;

    /** 切点：资讯审核通过与审核驳回两个方法 */
    @Pointcut("execution(* com.edu.news.service.NewsService.approve(..)) "
            + "|| execution(* com.edu.news.service.NewsService.reject(..))")
    public void auditPointcut() {
    }

    /** 环绕通知：业务执行成功后记录审核日志 */
    @Around("auditPointcut()")
    public Object recordAuditLog(ProceedingJoinPoint pjp) throws Throwable {
        // 先执行目标业务方法（审核通过 / 驳回）
        Object result = pjp.proceed();

        // 参数约定：方法签名为 (Integer newsId, Integer auditorId, String comment)
        Object[] args = pjp.getArgs();
        Integer newsId = args.length > 0 ? (Integer) args[0] : null;
        Integer auditorId = args.length > 1 ? (Integer) args[1] : null;
        String comment = args.length > 2 ? (String) args[2] : null;

        String action = "approve".equals(pjp.getSignature().getName()) ? "APPROVE" : "REJECT";

        AuditLog log = new AuditLog();
        log.setNewsId(newsId);
        log.setAuditorId(auditorId);
        log.setAction(action);
        log.setComment(comment);
        auditLogMapper.insert(log);
        return result;
    }
}
