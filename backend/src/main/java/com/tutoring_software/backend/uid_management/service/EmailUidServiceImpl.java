package com.tutoring_software.backend.uid_management.service;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.tutoring_software.backend.uid_management.entity.EmailUid;
import com.tutoring_software.backend.uid_management.mapper.EmailUidMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

@Service
public class EmailUidServiceImpl extends ServiceImpl<EmailUidMapper, EmailUid> implements EmailUidService {

   private static final Logger LOGGER = LoggerFactory.getLogger(EmailUidServiceImpl.class);


    @Override
    public EmailUid getByEmail(String email) {
        return baseMapper.selectByEmail(email);
    }

    @Override
    public EmailUid getByUid(Long uid) {
        return baseMapper.selectByUid(uid);
    }

    @Override
    public boolean saveEmailUid(String email, Long uid) {
        EmailUid existing = getByEmail(email);
        if (existing != null) {
            return updateByEmail(email, uid);
        }
        EmailUid emailUid = new EmailUid(email, uid);
        return save(emailUid);
    }

    @Override
    public boolean updateByEmail(String email, Long uid) {
        EmailUid emailUid = getByEmail(email);
        if (emailUid != null) {
            emailUid.setUid(uid);
            return updateById(emailUid);
        }
        return false;
    }

    @Override
    public boolean deleteByEmail(String email) {
        try {
            EmailUid emailUid = getByEmail(email);
            if (emailUid != null) {
                boolean result = removeById(emailUid.getId());
                if (result) {
                    LOGGER.info("Successfully deleted EmailUid mapping: email={}, uid={}", email, emailUid.getUid());
                }
                return result;
            }
            LOGGER.warn("Email not found for deletion: {}", email);
            return false;
        } catch (Exception e) {
            LOGGER.error("Error deleting EmailUid mapping by email: {}", email, e);
            throw e;
        }
    }

    @Override
    public boolean deleteByUid(Long uid) {
        try {
            EmailUid emailUid = getByUid(uid);
            if (emailUid != null) {
                boolean result = removeById(emailUid.getId());
                if (result) {
                    LOGGER.info("Successfully deleted EmailUid mapping by UID: uid={}, email={}", uid,
                            emailUid.getEmail());
                }
                return result;
            }
            LOGGER.warn("No email mapping found for UID: {}", uid);
            return false;
        } catch (Exception e) {
            LOGGER.error("Error deleting EmailUid mapping by UID: {}", uid, e);
            throw e;
        }
    }
}
