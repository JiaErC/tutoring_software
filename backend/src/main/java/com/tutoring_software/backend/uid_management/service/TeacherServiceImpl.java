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
    public boolean saveTeacher(Long teacherUid, double rating, String subjectCode) {
        try {
            Teacher teacher = new Teacher(teacherUid, rating, 0); // comments初始化为0
            return save(teacher);
        } catch (Exception e) {
            LOGGER.error("保存老师信息失败，teacherUid: {}", teacherUid, e);
            return false;
        }
    }

    @Override
    public boolean updateTeacher(Long teacherUid, double rating, String subjectCode) {
        try {
            // 先查询老师是否存在
            Teacher existingTeacher = getByTeacherUid(teacherUid);
            if (existingTeacher == null) {
                LOGGER.error("老师{}不存在，更新失败", teacherUid);
                return false;
            }

            // 更新老师信息
            existingTeacher.setRating(rating);
            // 注意：Teacher实体类中没有subjectCode字段，这里不设置subjectCode

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
}