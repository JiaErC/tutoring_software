package com.tutoring_software.backend.uid_management.service;

import com.baomidou.mybatisplus.extension.service.IService;

import com.tutoring_software.backend.uid_management.entity.UserDataItem;

public interface UserDataItemService extends IService<UserDataItem> {
    // 通过uid获取所有用户的数据，和存放数据
    UserDataItem getByUid(Long uid);

    // 保存用户数据
    boolean saveUserDataItem(Long uid, String username, String phoneNumber, String email, String birthday, String role,
            String gender, String password, String teachingSubjects, String learningSubjects);

    // 更新用户数据
    boolean updateUserDataItem(Long uid, String username, String phoneNumber, String email, String birthday,
            String role, String gender, String password, String teachingSubjects, String learningSubjects);

    // 设置生日、性别、用户名
    // boolean updateBirthday(Long uid, String birthday);
    // boolean updateGender(Long uid, String gender);
    // boolean updateUsername(Long uid, String username);
}
