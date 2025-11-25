package com.tutoring_software.backend.uid_management.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;

import com.tutoring_software.backend.uid_management.entity.TeacherCourse;

@Mapper
public interface TeacherCourseMapper extends BaseMapper<TeacherCourse> {
    // 通过老师uid获取老师信息
    @Select("SELECT * FROM teachers_courses WHERE teacher_uid = #{teacherUid}")
    TeacherCourse getByTeacherUid(Long teacherUid);

    // 通过学科代码获取老师列表
    @Select("SELECT * FROM teachers_courses WHERE subject = #{subject}")
    List<TeacherCourse> getBySubject(String subject);

    // 通过老师uid删除老师课程信息
    @Delete("DELETE FROM teachers_courses WHERE teacher_uid = #{teacherUid}")
    int deleteByTeacherUid(Long teacherUid);
}