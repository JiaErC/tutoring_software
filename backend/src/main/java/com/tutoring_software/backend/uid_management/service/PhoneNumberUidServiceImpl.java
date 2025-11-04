package com.tutoring_software.backend.uid_management.service;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.tutoring_software.backend.uid_management.entity.PhoneNumberUid;
import com.tutoring_software.backend.uid_management.mapper.PhoneNumberUidMapper;
import org.springframework.stereotype.Service;

@Service
public class PhoneNumberUidServiceImpl extends ServiceImpl<PhoneNumberUidMapper, PhoneNumberUid> implements PhoneNumberUidService {

    @Override
    public PhoneNumberUid getByPhoneNumber(String phoneNumber) {
        return baseMapper.selectByPhoneNumber(phoneNumber);
    }

    @Override
    public PhoneNumberUid getByUid(Long uid) {
        return baseMapper.selectByUid(uid);
    }

    @Override
    public boolean savePhoneNumberUid(String phoneNumber, Long uid) {
        // 检查手机号是否已存在
        PhoneNumberUid existing = getByPhoneNumber(phoneNumber);
        if (existing != null) {
            return updateByPhoneNumber(phoneNumber, uid);
        }

        PhoneNumberUid phoneNumberUid = new PhoneNumberUid(phoneNumber, uid);
        return save(phoneNumberUid);
    }

    @Override
    public boolean updateByPhoneNumber(String phoneNumber, Long uid) {
        PhoneNumberUid phoneNumberUid = getByPhoneNumber(phoneNumber);
        if (phoneNumberUid != null) {
            phoneNumberUid.setUid(uid);
            return updateById(phoneNumberUid);
        }
        return false;
    }

    @Override
    public boolean deleteByPhoneNumber(String phoneNumber) {
        PhoneNumberUid phoneNumberUid = getByPhoneNumber(phoneNumber);
        if (phoneNumberUid != null) {
            return removeById(phoneNumberUid.getId());
        }
        return false;
    }
}