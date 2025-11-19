package com.tutoring_software.backend.uid_management.service;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.springframework.stereotype.Service;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.tutoring_software.backend.uid_management.entity.UserSignature;
import com.tutoring_software.backend.uid_management.mapper.UserSignatureMapper;

@Service
public class UserSignatureServiceImpl extends ServiceImpl<UserSignatureMapper, UserSignature> implements UserSignatureService{

    private static final Logger logger = LoggerFactory.getLogger(UserSignatureServiceImpl.class);

    @Override
    public UserSignature getByUid(Long uid) {
        return baseMapper.getByUid(uid);
    }

    @Override
    public boolean updateSignature(Long uid, String signatures) {
        logger.info("更新用户{}的签名", uid);
        // 检查用户是否存在
        UserSignature existingSignature = getByUid(uid);
        if (existingSignature == null) {
            logger.warn("用户{}不存在，无法更新签名", uid);
            return false;
        }
        // 执行更新操作
        int rows = baseMapper.updateSignatures(uid, signatures);
        return rows > 0;
    }

    @Override
    public boolean saveUserSignature(Long uid, String signatures) {
        UserSignature userSignature = new UserSignature(uid,signatures);
        return save(userSignature);
    }

    
}
