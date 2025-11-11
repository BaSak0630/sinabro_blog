package org.sinabro.sinabro_blog.auth.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class Login {

    @NotBlank(message = "계정 ID는 필수입니다.")
    @Size(min = 4, max = 20, message = "계정 ID는 4자 이상 20자 이하여야 합니다.")
    private String accountId;

    @NotBlank(message = "비밀번호는 필수입니다.")
    @Size(min = 6, message = "비밀번호는 6자 이상이어야 합니다.")
    private String password;

    @Builder
    public Login(String accountId, String password) {
        this.accountId = accountId;
        this.password = password;
    }

    @Override
    public String toString() {
        return "Login{" +
                "accountId='" + accountId + '\'' +
                ", password='[PROTECTED]'" +
                '}';
    }
}