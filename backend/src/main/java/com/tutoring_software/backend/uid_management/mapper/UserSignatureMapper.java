package com.tutoring_software.backend.uid_management.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import com.tutoring_software.backend.uid_management.entity.UserSignature;

@Mapper
public interface UserSignatureMapper extends BaseMapper<UserSignature> {
    @Select("SELECT * FROM user_signature WHERE uid = #{uid}")
    UserSignature getByUid(Long uid);
    //修改用户签名
    @Update("UPDATE user_signature SET signatures = #{signatures} WHERE uid = #{uid}")
    int updateSignatures(Long uid, String signatures);
}
