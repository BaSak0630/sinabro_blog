package org.sinabro.dokhu.repository;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.sinabro.dokhu.domain.Book;

@Mapper
public interface BookMapper {

    Book findById(@Param("id") Long id);
}