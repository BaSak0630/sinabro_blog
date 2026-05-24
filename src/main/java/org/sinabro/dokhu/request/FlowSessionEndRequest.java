package org.sinabro.dokhu.request;

import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
public class FlowSessionEndRequest {
    private String memo;
    private Integer bookmarkPage;
}
