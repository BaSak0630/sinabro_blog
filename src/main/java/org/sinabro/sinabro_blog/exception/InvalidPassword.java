package org.sinabro.sinabro_blog.exception;

public class InvalidPassword extends SinabroException {
    private static final String MESSAGE = "비밀번호가 올바르지 않습니다.";

    public InvalidPassword() {
        super(MESSAGE);
    }

    @Override
    public int statusCode() {
        return 400;
    }
}
