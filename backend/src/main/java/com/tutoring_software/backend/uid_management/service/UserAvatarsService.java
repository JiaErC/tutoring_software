package com.tutoring_software.backend.uid_management.service;

import com.baomidou.mybatisplus.extension.service.IService;

import com.tutoring_software.backend.uid_management.entity.UserAvatars;

public interface UserAvatarsService extends IService<UserAvatars> {
    // 通过uid查询用户的头像
    UserAvatars getByUid(Long uid);

    // 存储用户的头像
    boolean saveUserAvatars(Long uid, byte[] imageData, String mimeType);

    // 更新用户的头像
    boolean updateUserAvatars(Long uid, byte[] imageData, String mimeType);
}