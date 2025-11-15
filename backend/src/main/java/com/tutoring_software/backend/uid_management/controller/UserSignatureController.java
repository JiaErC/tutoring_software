package com.tutoring_software.backend.uid_management.controller;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import com.tutoring_software.backend.uid_management.Result;
import com.tutoring_software.backend.uid_management.entity.UserSignature;
import com.tutoring_software.backend.uid_management.service.UserSignatureService;

@RestController
@RequestMapping("/api/user-signatures")
public class UserSignatureController {
    private static final Logger LOGGER = LoggerFactory.getLogger(UserSignatureController.class);

    @Autowired
    private UserSignatureService userSignatureService;

    // 通过uid获取用户的签名
    @GetMapping("/get/{uid}")
    public Result<UserSignature> getByUid(@PathVariable String uid) {
        // 把uid转换为Long类型
        Long uidLong = Long.parseLong(uid);
        LOGGER.info("需要查询的uid为:{}", uidLong);
        try {
            UserSignature result = userSignatureService.getByUid(uidLong);
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

    // 存储用户签名数据
    @PostMapping("/save")
    public Result<String> saveUserSignature(@RequestBody UserSignature userSignature) {
        try {
            // 首先检查用户是否已存在
            UserSignature existingUser = userSignatureService.getByUid(userSignature.getUid());
            if (existingUser != null) {
                LOGGER.error("用户{}已存在，保存失败", userSignature.getUid());
                return Result.error("User already exists"); // 返回明确的用户已存在错误
            }
            boolean success = userSignatureService.saveUserSignature(
                    userSignature.getUid(), userSignature.getSignatures());
            if (success) {
                LOGGER.info("成功存储数据:uid={}", userSignature.getUid());
                return Result.success("Save successful");
            } else {
                return Result.error("Save failed");
            }
        } catch (Exception e) {
            LOGGER.error("Error saving user signature", e);
            return Result.error("Internal server error");
        }
    }

    // 更新签名数据
    @PutMapping("/update")
    public Result<String> updateUserSignatures(@RequestBody UserSignature userSignature) {
        try {
            boolean success = userSignatureService.updateSignature(
                    userSignature.getUid(), userSignature.getSignatures());
            if (success) {
                LOGGER.info("成功更新用户{}的签名", userSignature.getUid());
                return Result.success("Update successful");
            } else {
                LOGGER.warn("更新用户{}签名失败，用户不存在", userSignature.getUid());
                return Result.error("User not found");
            }
        } catch (Exception e) {
            LOGGER.error("Error updating user signature", e);
            return Result.error("Internal server error");
        }
    }
}
