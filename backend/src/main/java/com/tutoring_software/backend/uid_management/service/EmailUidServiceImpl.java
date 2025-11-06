package com.tutoring_software.backend.uid_management.service;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.tutoring_software.backend.uid_management.entity.EmailUid;
import com.tutoring_software.backend.uid_management.mapper.EmailUidMapper;
import org.springframework.stereotype.Service;

@Service
public class EmailUidServiceImpl extends ServiceImpl<EmailUidMapper, EmailUid> implements EmailUidService {

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
        EmailUid emailUid = getByEmail(email);
        if (emailUid != null) {
            return removeById(emailUid.getId());
        }
        return false;
    }
}
