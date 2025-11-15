package com.tutoring_software.backend.uid_management.service;

import com.baomidou.mybatisplus.extension.service.IService;

import com.tutoring_software.backend.uid_management.entity.UserSignature;

public interface UserSignatureService extends IService<UserSignature> {
    //通过uid获取用户的签名
    public UserSignature getByUid(Long uid);
    //修改用户签名
    boolean updateSignature(Long uid, String signatures) ;
    //保存用户签名
    boolean saveUserSignature(Long uid, String signatures);
}
