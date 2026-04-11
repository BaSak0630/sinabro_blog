package org.sinabro.sinabro_blog.post.service;

import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.sinabro.commonness.exception.AccountNotFound;
import org.sinabro.commonness.exception.PostNotFound;
import org.sinabro.sinabro_blog.post.domain.Category;
import org.sinabro.sinabro_blog.post.domain.Post;
import org.sinabro.sinabro_blog.post.request.PostEditor;
import org.sinabro.sinabro_blog.post.repository.CategoryRepository;
import org.sinabro.sinabro_blog.post.repository.PostRepository;
import org.sinabro.sinabro_blog.post.request.PostCreate;
import org.sinabro.sinabro_blog.post.request.PostEdit;
import org.sinabro.sinabro_blog.post.request.PostSearch;
import org.sinabro.sinabro_blog.post.response.PagingResponse;
import org.sinabro.sinabro_blog.post.response.PostResponse;
import org.sinabro.commonness.user.repository.AccountRepository;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Service;

@Slf4j
@Service
@RequiredArgsConstructor
public class PostService {

    private final AccountRepository accountRepository;
    private final PostRepository postRepository;
    private final CategoryRepository categoryRepository;

    public void write(Long userId, PostCreate postCreate){
        var account = accountRepository.findById(userId).orElseThrow(AccountNotFound::new);

        //postCreate -> Entity
        Post post = Post.builder()
                .title(postCreate.getTitle())
                .content(postCreate.getContent())
                .account(account)
                .build();

        if (postCreate.getCategoryId() != null) {
            categoryRepository.findById(postCreate.getCategoryId())
                    .ifPresent(post::assignCategory);
        }

       postRepository.save(post);
    }

    @Transactional
    public PostResponse get(Long id) {
        Post post = postRepository.findById(id)
                .orElseThrow(() -> new PostNotFound());
        post.incrementViewCount();
        return new PostResponse(post);
        /*
        * PostController -> WebPostService -> Repository
        *                   PostService
        */
    }

    //글이 너무 많은 경우 -> 비용이 너무 많이 든다.
    //글리 -> 100.000.000-> DB글 모두 조회하는 경우 -> DB가 뻗을 수 있다.
    //DB-> 애플리케이션 서버로 전달하는 시간, 트래픽비용 등이 많이 들 수 있다.
    public PagingResponse<PostResponse> getList(PostSearch postSearch) {
        //web -> page 1 -> 0 변환해줌 yml
        Page<Post> postPage = postRepository.getList(postSearch);
        PagingResponse<PostResponse> postList = new PagingResponse<>(postPage,PostResponse.class);

        return postList;
    }

    @Transactional
    public void edit(Long id, PostEdit postEdit) {
        Post post = postRepository.findById(id)
                .orElseThrow(PostNotFound::new);

        PostEditor.PostEditorBuilder editorBuilder = post.toEditor();

        PostEditor postEditor = editorBuilder.title(postEdit.getTitle())
                .content(postEdit.getContent())
                .build();

        post.edit(postEditor);

        if (postEdit.getCategoryId() != null) {
            categoryRepository.findById(postEdit.getCategoryId())
                    .ifPresent(post::assignCategory);
        } else {
            post.assignCategory(null);
        }
    }

    public void delete(Long id) {
        Post post = postRepository.findById(id)
                .orElseThrow(PostNotFound::new);

        postRepository.delete(post);
    }
}
