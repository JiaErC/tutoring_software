package com.tutoring_software.backend.uid_management.mapper;

//获取基本的CRUD功能
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.tutoring_software.backend.uid_management.entity.PhoneNumberUid;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface PhoneNumberUidMapper extends BaseMapper<PhoneNumberUid> {
    // 可以添加自定义SQL方法
    PhoneNumberUid selectByPhoneNumber(String phoneNumber);
    PhoneNumberUid selectByUid(Long uid);
}
