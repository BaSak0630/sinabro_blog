package org.sinabro.sinabro_blog.exception;

import lombok.Getter;

/*
* status -> 400
*/
@Getter
public class InvalidRequest extends SinabroException {

    private static final String MESSAGE = "잘못된 요청입니다.";
    public InvalidRequest() {
        super("[ERROR] " + MESSAGE);
    }

    public InvalidRequest(String fieldName,String message) {
        super("[ERROR] " + MESSAGE);
        addValidation(fieldName,message);
    }

    @Override
    public int statusCode() {
        return 400;
    }
}
