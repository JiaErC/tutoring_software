package com.tutoring_software.backend.uid_management.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import com.tutoring_software.backend.uid_management.entity.EmailUid;

@Mapper
public interface EmailUidMapper extends BaseMapper<EmailUid> {
    @Select("SELECT * FROM email_id WHERE email = #{email}")
    EmailUid selectByEmail(String email);
    @Select("SELECT * FROM email_id WHERE id = #{uid}")
    EmailUid selectByUid(Long uid);
}