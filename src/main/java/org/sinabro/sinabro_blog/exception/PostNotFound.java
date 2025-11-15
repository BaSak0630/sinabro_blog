package org.sinabro.sinabro_blog.exception;

/*
 * status -> 404
 */

public class PostNotFound extends SinabroException {

    private static final String MESSAGE = "존재하지 않는 글입니다.";

    public PostNotFound() {
        super("[ERROR] " + MESSAGE);
    }


    @Override
    public int statusCode() {
        return 404;
    }
}
