package org.sinabro.sinabro_blog.exception;

public class Unauthorized extends SinabroException {

    private static final String MESSAGE = "인증 필요합니다.";

    public Unauthorized() {
        super("[ERROR]" + MESSAGE);
    }

    @Override
    public int statusCode() {
        return 401;
    }
}
