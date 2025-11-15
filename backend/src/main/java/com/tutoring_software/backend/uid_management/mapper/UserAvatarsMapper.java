package com.tutoring_software.backend.uid_management.mapper;

//基本的CRUD功能
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import com.tutoring_software.backend.uid_management.entity.UserAvatars;

@Mapper
public interface UserAvatarsMapper extends BaseMapper<UserAvatars> {
    // 通过用户uid查询头像文件
    @Select("SELECT * FROM user_avatars WHERE uid = #{uid}")
    UserAvatars getByUid(Long uid);

    // 通过uid更新用户头像
    @Update("UPDATE user_avatars SET image_data = #{imageData}, mime_type = #{mimeType}, created_at = CURRENT_TIMESTAMP WHERE uid = #{uid}")
    int updateByUid(Long uid, byte[] imageData, String mimeType);
}
