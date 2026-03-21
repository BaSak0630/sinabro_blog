package org.sinabro.sinabro_blog.post.controller;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Map;
import java.util.UUID;

@Slf4j
@RestController
public class ImageController {

    @Value("${upload.path:./uploads}")
    private String uploadPath;

    @PostMapping("/upload/image")
    public ResponseEntity<Map<String, String>> uploadImage(@RequestParam("image") MultipartFile file) throws IOException {
        if (file.isEmpty()) {
            return ResponseEntity.badRequest().body(Map.of("error", "빈 파일입니다."));
        }

        String originalName = file.getOriginalFilename();
        String ext = originalName != null && originalName.contains(".")
                ? originalName.substring(originalName.lastIndexOf('.'))
                : ".png";
        String filename = UUID.randomUUID() + ext;

        Path dir = Paths.get(uploadPath);
        Files.createDirectories(dir);
        Files.copy(file.getInputStream(), dir.resolve(filename));

        String url = "/uploads/" + filename;
        log.info("이미지 업로드: {}", url);
        return ResponseEntity.ok(Map.of("url", url));
    }
}
