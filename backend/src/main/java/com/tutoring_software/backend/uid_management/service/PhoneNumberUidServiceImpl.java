package com.tutoring_software.backend.uid_management.service;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.tutoring_software.backend.uid_management.entity.PhoneNumberUid;
import com.tutoring_software.backend.uid_management.mapper.PhoneNumberUidMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

@Service
public class PhoneNumberUidServiceImpl extends ServiceImpl<PhoneNumberUidMapper, PhoneNumberUid> implements PhoneNumberUidService {

    private static final Logger LOGGER = LoggerFactory.getLogger(PhoneNumberUidServiceImpl.class);

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
        try {
            PhoneNumberUid phoneNumberUid = getByPhoneNumber(phoneNumber);
            if (phoneNumberUid != null) {
                boolean result = removeById(phoneNumberUid.getId());
                if (result) {
                    LOGGER.info("Successfully deleted PhoneNumberUid mapping: phoneNumber={}, uid={}", 
                            phoneNumber, phoneNumberUid.getUid());
                }
                return result;
            }
            LOGGER.warn("Phone number not found for deletion: {}", phoneNumber);
            return false;
        } catch (Exception e) {
            LOGGER.error("Error deleting PhoneNumberUid mapping by phone number: {}", phoneNumber, e);
            throw e;
        }
    }
    
    @Override
    public boolean deleteByUid(Long uid) {
        try {
            PhoneNumberUid phoneNumberUid = getByUid(uid);
            if (phoneNumberUid != null) {
                boolean result = removeById(phoneNumberUid.getId());
                if (result) {
                    LOGGER.info("Successfully deleted PhoneNumberUid mapping by UID: uid={}, phoneNumber={}", 
                            uid, phoneNumberUid.getPhoneNumber());
                }
                return result;
            }
            LOGGER.warn("No phone number mapping found for UID: {}", uid);
            return false;
        } catch (Exception e) {
            LOGGER.error("Error deleting PhoneNumberUid mapping by UID: {}", uid, e);
            throw e;
        }
    }
}