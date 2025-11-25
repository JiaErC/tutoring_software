package com.tutoring_software.backend.uid_management.service;

import java.util.List;

import com.baomidou.mybatisplus.extension.service.IService;
import com.tutoring_software.backend.uid_management.entity.TeacherCourse;

public interface TeacherCourseService extends IService<TeacherCourse> {
    // 通过老师uid获取老师课程信息
    TeacherCourse getByTeacherUid(Long teacherUid);
    
    // 通过学科代码获取老师课程列表
    List<TeacherCourse> getBySubject(String subject);
    
    // 保存老师课程信息
    boolean saveTeacherCourse(Long teacherUid, String subjectCode);
    
    // 更新老师课程信息
    boolean updateTeacherCourse(Long teacherUid, String subjectCode);

    // 删除老师课程信息
    boolean deleteTeacherCourse(Long teacherUid);
}