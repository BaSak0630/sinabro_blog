package org.sinabro.sinabro_blog.exception;

public class AccountNotFound extends SinabroException {

    private static final String MESSAGE = "이미 가입된 아이디입니다.";

    public AccountNotFound() {
        super("[ERROR] " + MESSAGE);
    }

    @Override
    public int statusCode() {
        return 400;
    }
}
