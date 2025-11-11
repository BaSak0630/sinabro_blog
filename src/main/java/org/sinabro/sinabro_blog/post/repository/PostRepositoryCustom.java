package org.sinabro.sinabro_blog.post.repository;


import org.sinabro.sinabro_blog.post.domain.Post;
import org.sinabro.sinabro_blog.post.request.PostSearch;
import org.springframework.data.domain.Page;

public interface PostRepositoryCustom {

    Page<Post> getList(PostSearch postSearch);
}
