package org.sinabro.sinabro_blog.exception;

public class UserNotFound extends SinabroException {

    private static final String MESSAGE = "존재하지 않는 아이디입니다.";

    public UserNotFound() {
        super("[ERROR]" + MESSAGE);
    }


    @Override
    public int statusCode() {
        return 404;
    }
}
