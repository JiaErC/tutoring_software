package com.tutoring_software.backend.uid_management.service;

import java.util.List;

import com.baomidou.mybatisplus.extension.service.IService;
import com.tutoring_software.backend.uid_management.entity.Teacher;

public interface TeacherService extends IService<Teacher> {
    // 通过老师uid获取老师信息
    Teacher getByTeacherUid(Long teacherUid);
    
    // 通过学科代码获取老师列表
    List<Teacher> getBySubjectCode(String subjectCode);
    
    // 保存老师信息
    boolean saveTeacher(Long teacherUid, String rating, String subjectCode);
    
    // 更新老师信息
    boolean updateTeacher(Long teacherUid, String rating, String subjectCode);
}