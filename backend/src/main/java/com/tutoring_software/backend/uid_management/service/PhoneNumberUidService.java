package com.tutoring_software.backend.uid_management.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.tutoring_software.backend.uid_management.entity.PhoneNumberUid;

public interface PhoneNumberUidService extends IService<PhoneNumberUid> {
    // 自定义业务方法
    PhoneNumberUid getByPhoneNumber(String phoneNumber);
    PhoneNumberUid getByUid(Long uid);
    boolean savePhoneNumberUid(String phoneNumber, Long uid);
    boolean updateByPhoneNumber(String phoneNumber, Long uid);
    boolean deleteByPhoneNumber(String phoneNumber);
}
