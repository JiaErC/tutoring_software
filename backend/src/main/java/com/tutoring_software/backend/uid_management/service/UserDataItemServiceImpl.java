package com.tutoring_software.backend.uid_management.service;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.springframework.stereotype.Service;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.tutoring_software.backend.uid_management.entity.UserDataItem;
import com.tutoring_software.backend.uid_management.mapper.UserDataItemMapper;

@Service
public class UserDataItemServiceImpl extends ServiceImpl<UserDataItemMapper, UserDataItem>
        implements UserDataItemService {

    private static final Logger LOGGER = LoggerFactory.getLogger(UserDataItemServiceImpl.class);

    @Override
    public UserDataItem getByUid(Long uid) {
        return baseMapper.getByUid(uid);
    }

    @Override
    public boolean saveUserDataItem(Long uid, String username, String phoneNumber, String email, String birthday,
            String role, String gender, String password, String teachingSubjects, String learningSubjects) {
        UserDataItem userDataItem = new UserDataItem(uid, username, phoneNumber, email, birthday, role,
                gender, password, teachingSubjects, learningSubjects);
        return save(userDataItem);
    }

    @Override
    public boolean updateUserDataItem(Long uid, String username, String phoneNumber, String email, String birthday,
            String role, String gender, String password, String teachingSubjects, String learningSubjects) {
        try {
            // 先查询用户是否存在
            UserDataItem existingUser = getByUid(uid);
            if (existingUser == null) {
                LOGGER.error("用户{}不存在，更新失败", uid);
                return false;
            }

            // 更新用户信息
            existingUser.setUsername(username);
            existingUser.setPhoneNumber(phoneNumber != null ? phoneNumber : "");
            existingUser.setEmail(email != null ? email : "");
            existingUser.setBirthday(birthday != null ? birthday : "");
            existingUser.setRole(role);
            existingUser.setGender(gender != null ? gender : "隐藏");
            existingUser.setPassword(password);
            existingUser.setTeachingSubjects(teachingSubjects);
            existingUser.setLearningSubjects(learningSubjects);

            return updateById(existingUser);
        } catch (Exception e) {
            LOGGER.error("更新用户{}数据失败", uid, e);
            return false;
        }
    }
}
