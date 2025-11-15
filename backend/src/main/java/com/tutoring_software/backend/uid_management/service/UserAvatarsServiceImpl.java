package com.tutoring_software.backend.uid_management.service;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.springframework.stereotype.Service;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.tutoring_software.backend.uid_management.entity.UserAvatars;
import com.tutoring_software.backend.uid_management.mapper.UserAvatarsMapper;

public class UserAvatarsServiceImpl extends ServiceImpl<UserAvatarsMapper, UserAvatars> implements UserAvatarsService {
    private static final Logger LOGGER = LoggerFactory.getLogger(UserAvatarsServiceImpl.class);

    @Override
    public UserAvatars getByUid(Long uid) {
        return baseMapper.getByUid(uid);
    }

    @Override
    public boolean saveUserAvatars(Long uid, byte[] imageData, String mimeType) {
        UserAvatars userAvatars = new UserAvatars(uid, imageData, mimeType);
        return save(userAvatars);
    }

    @Override
    public boolean updateUserAvatars(Long uid, byte[] imageData, String mimeType) {
        LOGGER.info("更新用户{}的头像", uid);
        // 检查用户是否存在
        UserAvatars existingAvatar = getByUid(uid);
        if (existingAvatar == null) {
            LOGGER.warn("用户{}不存在，无法更新头像", uid);
            return false;
        }
        // 执行更新操作
        int rows = baseMapper.updateByUid(uid, imageData, mimeType);
        return rows > 0;
    }
}
