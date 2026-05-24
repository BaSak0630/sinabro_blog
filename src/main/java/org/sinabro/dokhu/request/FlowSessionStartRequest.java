package org.sinabro.dokhu.request;

import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
public class FlowSessionStartRequest {
    private Long userBookId;
    private String videoUrl;
}
