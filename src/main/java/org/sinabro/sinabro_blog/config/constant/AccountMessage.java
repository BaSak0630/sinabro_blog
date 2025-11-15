package org.sinabro.sinabro_blog.config.constant;

public class AccountMessage {
    public static final String PASSWORD_MIN_LENGTH_MSG = "비밀번호는 최소 " + AccountConstant.PASSWORD_MIN_LENGTH + "자 이상이어야 합니다.";
    public static final String PASSWORD_MAX_LENGTH_MSG = "비밀번호는 최대 " + AccountConstant.PASSWORD_MAX_LENGTH + "자 이하이어야 합니다.";
    public static final String ID_MIN_LENGTH_MSG = "아이디는 최소 " + AccountConstant.ID_MIN_LENGTH + "자 이상이어야 합니다.";
    public static final String ID_MAX_LENGTH_MSG = "아이디는 최대 " + AccountConstant.ID_MAX_LENGTH + "자 이하이어야 합니다.";
    public static final String ID_BLANK = "아이디는 필수입니다.";
    public static final String EMAIL_VALIDATE = "유효하지 않은 이메일입니다.";
}
