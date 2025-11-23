package com.tutoring_software.backend.uid_management.service;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.tutoring_software.backend.uid_management.entity.TeacherCourse;
import com.tutoring_software.backend.uid_management.mapper.TeacherCourseMapper;

/**
 * 老师课程服务实现类
 */
@Service
public class TeacherCourseServiceImpl extends ServiceImpl<TeacherCourseMapper, TeacherCourse> implements TeacherCourseService {

    private static final Logger LOGGER = LoggerFactory.getLogger(TeacherCourseServiceImpl.class);

    @Override
    public TeacherCourse getByTeacherUid(Long teacherUid) {
        try {
            LOGGER.info("根据老师UID获取课程信息: teacherUid={}", teacherUid);
            return baseMapper.getByTeacherUid(teacherUid);
        } catch (Exception e) {
            LOGGER.error("根据老师UID获取课程信息失败: teacherUid={}", teacherUid, e);
            return null;
        }
    }

    @Override
    public List<TeacherCourse> getBySubject(String subject) {
        try {
            LOGGER.info("根据学科代码获取老师课程列表: subject={}", subject);
            return baseMapper.getBySubject(subject);
        } catch (Exception e) {
            LOGGER.error("根据学科代码获取老师课程列表失败: subject={}", subject, e);
            return null;
        }
    }

    @Override
    public boolean saveTeacherCourse(Long teacherUid, String subjectCode) {
        try {
            LOGGER.info("保存老师课程信息: teacherUid={}, subjectCode={}", teacherUid, subjectCode);
            
            // 先检查是否已存在该老师的课程信息
            TeacherCourse existingCourse = getByTeacherUid(teacherUid);
            if (existingCourse != null) {
                LOGGER.warn("老师{}的课程信息已存在，保存失败", teacherUid);
                return false;
            }
            
            // 创建新的老师课程对象
            TeacherCourse teacherCourse = new TeacherCourse(teacherUid, subjectCode);
            return save(teacherCourse);
        } catch (Exception e) {
            LOGGER.error("保存老师课程信息失败: teacherUid={}, subjectCode={}", teacherUid, subjectCode, e);
            return false;
        }
    }

    @Override
    public boolean updateTeacherCourse(Long teacherUid, String subjectCode) {
        try {
            LOGGER.info("更新老师课程信息: teacherUid={}, subjectCode={}", teacherUid, subjectCode);
            
            // 先查询老师课程是否存在
            TeacherCourse existingCourse = getByTeacherUid(teacherUid);
            if (existingCourse == null) {
                LOGGER.error("老师{}的课程信息不存在，更新失败", teacherUid);
                return false;
            }

            // 更新老师课程信息
            existingCourse.setSubject(subjectCode);
            return updateById(existingCourse);
        } catch (Exception e) {
            LOGGER.error("更新老师课程信息失败: teacherUid={}, subjectCode={}", teacherUid, subjectCode, e);
            return false;
        }
    }
}