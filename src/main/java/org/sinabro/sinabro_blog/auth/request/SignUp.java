package org.sinabro.sinabro_blog.auth.request;

import jakarta.validation.constraints.NotBlank;
import lombok.Builder;
import lombok.Data;

@Data
public class SignUp {
    @NotBlank(message = "이름을 입력해주세요")
    private String username;

    @NotBlank(message = "아이디 입력해주세요")
    private String accountId; // 아이디

    @NotBlank(message = "비밀번호를 입력해주세요")
    private final String password;

    @NotBlank(message = "이메일을 입력해주세요")
    private final String email;

    @Builder
    public SignUp(String username, String accountId, String password, String email) {
        this.username = username;
        this.accountId = accountId;
        this.password = password;
        this.email = email;
    }
}
