package com.edu.news.util;

import org.apache.commons.codec.digest.DigestUtils;

/**
 * MD5 加密工具类（使用 commons-codec）
 */
public class Md5Util {

    /**
     * 对字符串进行 MD5 加密
     */
    public static String md5(String source) {
        if (source == null) {
            return null;
        }
        return DigestUtils.md5Hex(source);
    }

    /**
     * 校验明文与密文是否匹配
     */
    public static boolean matches(String raw, String encoded) {
        return encoded != null && encoded.equals(md5(raw));
    }
}
