package org.sinabro.sinabro_blog.user.domain;

public enum Role {
    USER("USER"),
    ROLE_ADMIN("ADMIN"),
    MANAGER("MANAGER");

    private final String role;

    Role(String role) {
        this.role = role;
    }

    public String getRole() {
        return role;
    }
}
