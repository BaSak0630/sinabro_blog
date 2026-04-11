package org.sinabro.commonness.admin.response;

import lombok.Getter;

import java.util.List;

@Getter
public class AdminPageResponse<T> {
    private final long page;
    private final long size;
    private final long totalCount;
    private final List<T> items;

    public AdminPageResponse(long page, long size, long totalCount, List<T> items) {
        this.page = page;
        this.size = size;
        this.totalCount = totalCount;
        this.items = items;
    }
}
