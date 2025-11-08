package com.tutoring_software.backend.uid_management.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Mapper;

import com.tutoring_software.backend.uid_management.entity.UserDataItem;
import org.apache.ibatis.annotations.Select;


@Mapper
public interface UserDataItemMapper extends BaseMapper<UserDataItem> {
    //通过uid获取所有的用户数据
    @Select("SELECT * FROM user_data_item WHERE uid = #{uid}")
    UserDataItem getByUid(Long uid);
}
