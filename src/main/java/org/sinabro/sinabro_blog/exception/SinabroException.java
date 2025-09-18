package org.sinabro.sinabro_blog.exception;

import lombok.Getter;

import java.util.HashMap;
import java.util.Map;

@Getter
public abstract class SinabroException extends RuntimeException {

    public final Map<String, String> validation = new HashMap<>();

    public SinabroException(String message) {
        super(message);
    }

    public SinabroException(String message, Throwable cause) {
        super(message, cause);
    }

    public abstract int statusCode();

    public void addValidation(String fieldName, String message) {
        validation.put(fieldName, message);
    }
}
