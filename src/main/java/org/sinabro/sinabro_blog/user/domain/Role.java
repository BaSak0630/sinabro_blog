package org.sinabro.sinabro_blog.user.domain;

import lombok.Getter;

@Getter
public enum Role {
    USER("USER"),
    ROLE_ADMIN("ADMIN"),
    MANAGER("MANAGER");

    private final String role;

    Role(String role) {
        this.role = role;
    }

}
