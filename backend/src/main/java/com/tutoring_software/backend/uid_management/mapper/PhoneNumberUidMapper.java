package com.tutoring_software.backend.uid_management.mapper;

//获取基本的CRUD功能
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.tutoring_software.backend.uid_management.entity.PhoneNumberUid;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

@Mapper
public interface PhoneNumberUidMapper extends BaseMapper<PhoneNumberUid> {
    // 可以添加自定义SQL方法
    @Select("SELECT * FROM phone_number_id WHERE phone_number = #{phoneNumber}")
    PhoneNumberUid selectByPhoneNumber(String phoneNumber);
    @Select("SELECT * FROM phone_number_id WHERE id = #{uid}")
    PhoneNumberUid selectByUid(Long uid);
}
