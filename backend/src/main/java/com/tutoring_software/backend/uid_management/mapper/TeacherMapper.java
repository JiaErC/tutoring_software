package com.tutoring_software.backend.uid_management.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.tutoring_software.backend.uid_management.entity.Teacher;

@Mapper
public interface TeacherMapper extends BaseMapper<Teacher> {
    // 通过老师uid获取老师信息
    @Select("SELECT * FROM teachers WHERE teacher_uid = #{teacherUid}")
    Teacher getByTeacherUid(Long teacherUid);
    
    // 通过评分大于指定值获取老师列表
    @Select("SELECT * FROM teachers WHERE rating >= #{rating}")
    List<Teacher> getByRatingGreaterThan(double rating);
    
    // 通过评论数大于指定值获取老师列表
    @Select("SELECT * FROM teachers WHERE comments >= #{comments}")
    List<Teacher> getByCommentsGreaterThan(int comments);

    //评论数在最小值和最大值之间的评论数量
    @Select("SELECT * FROM teachers WHERE comments >= #{minComments} AND comments <= #{maxComments}")
    List<Teacher> getByCommentsBetween(int minComments, int maxComments);

   // 通过老师uid删除老师信息
    @Delete("DELETE FROM teachers WHERE teacher_uid = #{teacherUid}")
    int deleteByTeacherUid(Long teacherUid);
}