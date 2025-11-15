package com.tutoring_software.backend.uid_management.controller;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import com.tutoring_software.backend.uid_management.Result;
import com.tutoring_software.backend.uid_management.entity.UserAvatars;
import com.tutoring_software.backend.uid_management.service.UserAvatarsService;

@RestController
@RequestMapping("/api/user-avatars")
public class UserAvatarsController {
    private static final Logger LOGGER = LoggerFactory.getLogger(UserAvatarsController.class);

    @Autowired
    private UserAvatarsService userAvatarsService;

    @GetMapping("/get/{uid}")
    public Result<UserAvatars> getByUid(@PathVariable String uid) {
        // 把uid转换为Long类型
        Long uidLong = Long.parseLong(uid);
        LOGGER.info("需要查询的uid为:{}", uidLong);
        try {
            UserAvatars result = userAvatarsService.getByUid(uidLong);
            if (result != null) {
                return Result.success(result);
            } else {
                return Result.error("UID not found");
            }
        } catch (Exception e) {
            LOGGER.error("Error getting by UID", e);
            return Result.error("Internal server error");
        }
    }

    // 存储头像数据
    @PostMapping("/save")
    public Result<String> saveUserAvatars(@RequestBody UserAvatars userAvatars) {
        try {
            // 首先检查用户是否已存在
            UserAvatars existingUser = userAvatarsService.getByUid(userAvatars.getUid());
            if (existingUser != null) {
                LOGGER.error("用户{}已存在，保存失败", userAvatars.getUid());
                return Result.error("User already exists"); // 返回明确的用户已存在错误
            }
            boolean success = userAvatarsService.saveUserAvatars(
                    userAvatars.getUid(), userAvatars.getImageData(),
                    userAvatars.getMimeType());
            if (success) {
                LOGGER.info("成功存储数据:uid={}", userAvatars.getUid());
                return Result.success("Save successful");
            } else {
                return Result.error("Save failed");
            }
        } catch (Exception e) {
            LOGGER.error("Error saving user avatar", e);
            return Result.error("Internal server error");
        }
    }

    // 更新头像数据
    @PutMapping("/update")
    public Result<String> updateUserAvatars(@RequestBody UserAvatars userAvatars) {
        try {
            boolean success = userAvatarsService.updateUserAvatars(
                    userAvatars.getUid(), userAvatars.getImageData(),
                    userAvatars.getMimeType());
            if (success) {
                LOGGER.info("成功更新用户{}的头像", userAvatars.getUid());
                return Result.success("Update successful");
            } else {
                LOGGER.warn("更新用户{}头像失败，用户不存在", userAvatars.getUid());
                return Result.error("User not found");
            }
        } catch (Exception e) {
            LOGGER.error("Error updating user avatar", e);
            return Result.error("Internal server error");
        }
    }
}
