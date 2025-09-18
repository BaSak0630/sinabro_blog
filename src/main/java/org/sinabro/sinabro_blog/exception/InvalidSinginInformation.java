package org.sinabro.sinabro_blog.exception;

public class InvalidSinginInformation extends SinabroException {
    private static final String MESSAGE = "아이디 비밀번호가 올바르지 않습니다.";

    public InvalidSinginInformation() {
        super(MESSAGE);
    }

    @Override
    public int statusCode() {
        return 400;
    }
}
