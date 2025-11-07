package com.tutoring_software.backend.uid_management.service;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.springframework.stereotype.Service;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.tutoring_software.backend.uid_management.entity.UserDataItem;
import com.tutoring_software.backend.uid_management.mapper.UserDataItemMapper;

@Service
public class UserDataItemServiceImpl extends ServiceImpl<UserDataItemMapper, UserDataItem> implements UserDataItemService{

    private static final Logger LOGGER = LoggerFactory.getLogger(UserDataItemServiceImpl.class);

    @Override
    public UserDataItem getByUid(Long uid) {
        return baseMapper.selectById(uid);
    }
    @Override
    public boolean saveUserDataItem(Long uid,String username ,String phoneNumber,String email,String role,String gender,String birthday
    ,String password) {
        UserDataItem existing = getByUid(uid);
        UserDataItem userDataItem = new UserDataItem(uid,username,phoneNumber,email,role,gender,birthday,password);;
        return save(userDataItem);
    }
}
