package com.tutoring_software.backend.uid_management.service;

import java.util.List;

import com.baomidou.mybatisplus.extension.service.IService;
import com.tutoring_software.backend.uid_management.entity.Teacher;

public interface TeacherService extends IService<Teacher> {
    // 通过老师uid获取老师信息
    Teacher getByTeacherUid(Long teacherUid);

    // 保存老师信息
    boolean saveTeacher(Long teacherUid, double rating, int comments);

    // 更新老师信息
    boolean updateTeacher(Long teacherUid, double rating, int comments);

    // 通过评分大于指定值获取老师列表
    List<Teacher> getByRatingGreaterThan(double rating);

    // 通过评论数大于指定值获取老师列表
    List<Teacher> getByCommentsGreaterThan(int comments);

    // 通过评论数大于最小值，大于最大值的老师列表
    List<Teacher> getByCommentsBetween(int minComments, int maxComments);

    // 删除老师信息
    boolean deleteTeacher(Long teacherUid);
}