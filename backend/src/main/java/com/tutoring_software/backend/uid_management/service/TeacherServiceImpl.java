package com.tutoring_software.backend.uid_management.service;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.tutoring_software.backend.uid_management.entity.Teacher;
import com.tutoring_software.backend.uid_management.mapper.TeacherMapper;

@Service
public class TeacherServiceImpl extends ServiceImpl<TeacherMapper, Teacher>
        implements TeacherService {

    private static final Logger LOGGER = LoggerFactory.getLogger(TeacherServiceImpl.class);

    @Override
    public Teacher getByTeacherUid(Long teacherUid) {
        return baseMapper.getByTeacherUid(teacherUid);
    }

    @Override
    public boolean saveTeacher(Long teacherUid, double rating, int comments) {
        try {
            Teacher teacher = new Teacher(teacherUid, rating, comments); // comments初始化为0
            return save(teacher);
        } catch (Exception e) {
            LOGGER.error("保存老师信息失败，teacherUid: {}", teacherUid, e);
            return false;
        }
    }

    @Override
    public boolean updateTeacher(Long teacherUid, double rating, int comments) {
        try {
            // 先查询老师是否存在
            Teacher existingTeacher = getByTeacherUid(teacherUid);
            if (existingTeacher == null) {
                LOGGER.error("老师{}不存在，更新失败", teacherUid);
                return false;
            }

            // 更新老师信息
            existingTeacher.setRating(rating);
            existingTeacher.setComments(comments);

            return updateById(existingTeacher);
        } catch (Exception e) {
            LOGGER.error("更新老师{}信息失败", teacherUid, e);
            return false;
        }
    }
    
    @Override
    public List<Teacher> getByRatingGreaterThan(double rating) {
        return baseMapper.getByRatingGreaterThan(rating);
    }
    
    @Override
    public List<Teacher> getByCommentsGreaterThan(int comments) {
        return baseMapper.getByCommentsGreaterThan(comments);
    }
    
    @Override
    public List<Teacher> getByCommentsBetween(int minComments, int maxComments) {
        return baseMapper.getByCommentsBetween(minComments, maxComments);
    }

        @Override
    public boolean deleteTeacher(Long teacherUid) {
        try {
            LOGGER.info("开始删除老师信息，teacherUid: {}", teacherUid);
            
            // 先查询老师是否存在
            Teacher existingTeacher = getByTeacherUid(teacherUid);
            if (existingTeacher == null) {
                LOGGER.warn("老师{}不存在，无需删除", teacherUid);
                return false;
            }
            
            int result = baseMapper.deleteByTeacherUid(teacherUid);
            if (result > 0) {
                LOGGER.info("删除老师信息成功，teacherUid: {}", teacherUid);
                return true;
            } else {
                LOGGER.error("删除老师信息失败，teacherUid: {}", teacherUid);
                return false;
            }
        } catch (Exception e) {
            LOGGER.error("删除老师信息异常，teacherUid: {}", teacherUid, e);
            return false;
        }
    }
}