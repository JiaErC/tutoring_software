package com.tutoring_software.backend.uid_management.service;

import com.baomidou.mybatisplus.extension.service.IService;

import com.tutoring_software.backend.uid_management.entity.EmailUid;

public interface EmailUidService extends IService<EmailUid> {
    //自定义业务方法
    EmailUid getByEmail(String email);
    EmailUid getByUid(Long uid);
    boolean saveEmailUid(String email, Long uid);
    boolean updateByEmail(String email, Long uid);
    boolean deleteByEmail(String email);
}