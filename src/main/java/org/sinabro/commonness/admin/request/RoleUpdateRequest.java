package org.sinabro.commonness.admin.request;

import lombok.Getter;
import lombok.NoArgsConstructor;
import org.sinabro.commonness.user.domain.Role;

@Getter
@NoArgsConstructor
public class RoleUpdateRequest {
    private Role role;
}
