package org.sinabro.sinabro_blog.exception;

public class CommentNotFound extends SinabroException {

    private static final String MESSAGE = "존재하지 않는 글입니다.";

    public CommentNotFound() {
        super(MESSAGE);
    }

    @Override
    public int statusCode() {
        return 404;
    }
}
