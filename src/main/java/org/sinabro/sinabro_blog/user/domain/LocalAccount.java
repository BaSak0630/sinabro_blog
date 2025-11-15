package org.sinabro.sinabro_blog.user.domain;

import jakarta.persistence.Entity;
import jakarta.persistence.PrimaryKeyJoinColumn;
import jakarta.validation.ValidationException;
import lombok.AccessLevel;
import lombok.NoArgsConstructor;
import lombok.experimental.SuperBuilder;
import org.sinabro.sinabro_blog.config.constant.AccountConstant;
import org.sinabro.sinabro_blog.config.constant.AccountMessage;

import java.time.LocalDateTime;

@Entity
@SuperBuilder
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@PrimaryKeyJoinColumn(name = "id")
public class LocalAccount extends Account {
    private final static String EMAIL_SEPARATOR = "@";

    public void validate() {
        //id
        if (accountId == null || accountId.isBlank()) {
            throw new ValidationException(AccountMessage.ID_BLANK);
        }
        if (accountId.length() > AccountConstant.ID_MAX_LENGTH) {
            throw new ValidationException(AccountMessage.ID_MAX_LENGTH_MSG);
        }
        if (accountId.length() < AccountConstant.ID_MIN_LENGTH) {
            throw new ValidationException(AccountMessage.ID_MIN_LENGTH_MSG);
        }
        //email
        if (email == null || !email.contains(EMAIL_SEPARATOR)) {
            throw new ValidationException(AccountMessage.EMAIL_VALIDATE);
        }

        //password
        if (password.length() < AccountConstant.PASSWORD_MIN_LENGTH) {
            throw new ValidationException(AccountMessage.PASSWORD_MIN_LENGTH_MSG);
        }
        if (password.length() > AccountConstant.PASSWORD_MAX_LENGTH) {
            throw new ValidationException(AccountMessage.PASSWORD_MAX_LENGTH_MSG);
        }
        //TODO 특수문자 공백 등등 추개검증 필요
    }
}
