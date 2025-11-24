package com.tutoring_software.backend.uid_management.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.tutoring_software.backend.uid_management.Result;
import com.tutoring_software.backend.uid_management.entity.Teacher;
import com.tutoring_software.backend.uid_management.entity.TeacherCourse;
import com.tutoring_software.backend.uid_management.service.TeacherCourseService;
import com.tutoring_software.backend.uid_management.service.TeacherService;

@RestController
@RequestMapping("/api/teacher_info")
public class TeacherInfoController {

    private static final Logger LOGGER = LoggerFactory.getLogger(TeacherInfoController.class);

    @Autowired
    private TeacherService teacherService;
    
    @Autowired
    private TeacherCourseService teacherCourseService;
    
    /**
     * 根据用户选择的条件查询老师列表
     * @param request 包含查询条件的请求体
     * @return 符合条件的老师列表
     */
    @PostMapping("/search")
    public Result<List<Map<String, Object>>> searchTeachers(@RequestBody Map<String, Object> request) {
        try {
            LOGGER.info("开始根据条件查询老师信息: {}", request);
            
            // 1. 提取查询条件
            List<String> subjects = request.get("subjects") instanceof List ? 
                (List<String>) request.get("subjects") : new ArrayList<>();
            Double minRating = 0.0;
            if (request.get("minRating") != null) {
                try {
                    minRating = Double.parseDouble(request.get("minRating").toString());
                } catch (NumberFormatException e) {
                    LOGGER.warn("评分格式无效: {}", request.get("minRating"));
                }
            }
            Integer minComments = 0;
            if (request.get("minComments") != null) {
                try {
                    minComments = Integer.parseInt(request.get("minComments").toString());
                } catch (NumberFormatException e) {
                    LOGGER.warn("评论数格式无效: {}", request.get("minComments"));
                }
            }
            
            // 2. 获取符合条件的老师列表
            List<Teacher> filteredTeachers = new ArrayList<>();
            
            // 根据评分和评论数阈值过滤
            if (minRating != null && minComments != null) {
                // 先按评分过滤，再对结果按评论数过滤
                List<Teacher> ratingFiltered = teacherService.getByRatingGreaterThan(minRating);
                for (Teacher teacher : ratingFiltered) {
                    if (teacher.getComments() >= minComments) {
                        filteredTeachers.add(teacher);
                    }
                }
            } else if (minRating != null) {
                filteredTeachers = teacherService.getByRatingGreaterThan(minRating);
            } else if (minComments != null) {
                filteredTeachers = teacherService.getByCommentsGreaterThan(minComments);
            } else {
                // 当没有设置评分和评论数过滤条件时，默认获取所有老师
                filteredTeachers = teacherService.list();
            }
            
            // 3. 根据教学科目进一步过滤
            List<Teacher> finalFilteredTeachers = new ArrayList<>();
            if (!subjects.isEmpty()) {
                for (Teacher teacher : filteredTeachers) {
                    TeacherCourse teacherCourse = teacherCourseService.getByTeacherUid(teacher.getTeacherUid());
                    if (teacherCourse != null && subjects.contains(teacherCourse.getSubject())) {
                        finalFilteredTeachers.add(teacher);
                    }
                }
            } else {
                finalFilteredTeachers = filteredTeachers;
            }
            
            // 4. 组装返回数据
            List<Map<String, Object>> result = new ArrayList<>();
            for (Teacher teacher : finalFilteredTeachers) {
                Map<String, Object> teacherInfo = new HashMap<>();
                
                // 基础信息
                teacherInfo.put("uid", teacher.getTeacherUid());
                
                // 注意：由于Teacher实体类中没有性别、年龄、评分表等字段，
                // 这里假设通过其他服务获取或设置默认值
                teacherInfo.put("gender", "未知"); // 实际应用中应从用户服务获取
                teacherInfo.put("age", 0); // 实际应用中应从用户服务获取
                
                // 教学科目信息
                TeacherCourse teacherCourse = teacherCourseService.getByTeacherUid(teacher.getTeacherUid());
                if (teacherCourse != null) {
                    // 将科目转换为JSON格式
                    Map<String, String> subjectJson = new HashMap<>();
                    subjectJson.put("subjectCode", teacherCourse.getSubject());
                    teacherInfo.put("subjects", subjectJson);
                } else {
                    teacherInfo.put("subjects", new HashMap<>());
                }
                
                // 评分和评价数量
                teacherInfo.put("rating", teacher.getRating());
                teacherInfo.put("comments", teacher.getComments());
                
                // 评分表（实际应用中可能需要从其他表获取）
                teacherInfo.put("ratingDetails", new ArrayList<>());
                
                result.add(teacherInfo);
            }
            
            LOGGER.info("查询完成，共找到{}位符合条件的老师", result.size());
            return Result.success(result);
            
        } catch (Exception e) {
            LOGGER.error("查询老师信息失败", e);
            return Result.error("查询老师信息失败：" + e.getMessage());
        }
    }
}