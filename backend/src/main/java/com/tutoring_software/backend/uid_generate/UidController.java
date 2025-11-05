package com.tutoring_software.backend.uid_generate;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.tutoring_software.backend.uid_generate.UidGenerator;
import com.tutoring_software.backend.uid_generate.exception.UidGenerateException;

@RestController
@RequestMapping("/api/uid")
public class UidController {
    private static final Logger LOGGER = LoggerFactory.getLogger(UidController.class);

    @Autowired
    private UidGenerator uidGenerator;

    /**
     * 生成一个唯一的UID
     */
    @GetMapping("/generate")
    public Result<Long> generateUid() {
        try {
            long uid = uidGenerator.getUID();
            LOGGER.info("Generated UID: {}", uid);
            return Result.success(uid);
        } catch (UidGenerateException e) {
            LOGGER.error("Failed to generate UID", e);
            return Result.error("Failed to generate UID: " + e.getMessage());
        }
    }

    /**
     * 解析UID
     */
    @GetMapping("/parse")
    public Result<String> parseUid(Long uid) {
        if (uid == null) {
            return Result.error("UID cannot be null");
        }

        try {
            String parsed = uidGenerator.parseUID(uid);
            LOGGER.info("Parsed UID: {}", parsed);
            return Result.success(parsed);
        } catch (Exception e) {
            LOGGER.error("Failed to parse UID", e);
            return Result.error("Failed to parse UID: " + e.getMessage());
        }
    }

    // 统一响应结果封装类
    public static class Result<T> {
        private int code;
        private String message;
        private T data;

        private Result(int code, String message, T data) {
            this.code = code;
            this.message = message;
            this.data = data;
        }

        public static <T> Result<T> success(T data) {
            return new Result<>(200, "Success", data);
        }

        public static <T> Result<T> error(String message) {
            return new Result<>(500, message, null);
        }

        // Getters and setters
        public int getCode() { return code; }
        public void setCode(int code) { this.code = code; }
        public String getMessage() { return message; }
        public void setMessage(String message) { this.message = message; }
        public T getData() { return data; }
        public void setData(T data) { this.data = data; }
    }
}