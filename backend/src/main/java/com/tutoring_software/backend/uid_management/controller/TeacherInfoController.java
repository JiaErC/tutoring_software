package com.tutoring_software.backend.uid_management.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
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
     *
     * @param request 包含查询条件的请求体
     * @return 符合条件的老师列表
     */
    @GetMapping("/search")
    public Result<List<TeacherInfo>> searchTeachers(@RequestBody Map<String, Object> request) {
        //用来存储老师信息的列表
        List<TeacherInfo> result = new ArrayList<>();
        try {
            LOGGER.info("开始根据条件查询老师信息: {}", request);

            // 1. 提取查询条件 - 修改subjects的处理逻辑，确保正确接收Map<String,String>类型
            Map<String, String> subjects = new HashMap<>();
            if (request.get("subjects") instanceof Map) {
                subjects = (Map<String, String>) request.get("subjects");
            }

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

            Integer maxComments = null;
            if (request.get("maxComments") != null) {
                try {
                    maxComments = Integer.parseInt(request.get("maxComments").toString());
                } catch (NumberFormatException e) {
                    LOGGER.warn("最大评论数格式无效: {}", request.get("maxComments"));
                }
            }

            // 2. 获取符合条件的老师列表
            List<Teacher> filteredTeachers = new ArrayList<>();

            // 根据评分和评论数阈值过滤
            if (minRating != null && minComments != null) {
                // 先按评分过滤，再对结果按评论数过滤
                List<Teacher> ratingFiltered = teacherService.getByRatingGreaterThan(minRating);
                if (maxComments == null) {
                    for (Teacher teacher : ratingFiltered) {
                        if (teacher.getComments() >= minComments) {
                            filteredTeachers.add(teacher);
                        }
                    }
                } else {
                    for (Teacher teacher : ratingFiltered) {
                        if (teacher.getComments() >= minComments && teacher.getComments() <= maxComments) {
                            filteredTeachers.add(teacher);
                        }
                    }
                }
            } else if (minRating != null && maxComments != null) {
                filteredTeachers = teacherService.getByCommentsBetween(minComments, maxComments);
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
                    if (teacherCourse != null && subjects.containsValue(teacherCourse.getSubject())) {
                        finalFilteredTeachers.add(teacher);
                    }
                }
            } else {
                finalFilteredTeachers = filteredTeachers;
            }

            // 4. 组装返回数据
            for (Teacher teacher : finalFilteredTeachers) {
                // 处理老师可能教授多个学科的情况，确保每个老师只出现一次
                boolean teacherExists = false;
                TeacherInfo existingTeacherInfo = null;

                // 查找是否已存在该老师
                for (TeacherInfo ti : result) {
                    if (ti.getTeacherUid().equals(teacher.getTeacherUid())) {
                        teacherExists = true;
                        existingTeacherInfo = ti;
                        break;
                    }
                }
                // 获取当前老师的学科信息
                TeacherCourse teacherCourse = teacherCourseService.getByTeacherUid(teacher.getTeacherUid());
                String subject = (teacherCourse != null) ? teacherCourse.getSubject() : null;

                if (teacherExists && existingTeacherInfo != null) {
                    // 老师已存在，检查是否需要添加新学科
                    List<String> existingSubjects = existingTeacherInfo.getSubjects();
                    if (subject != null && !existingSubjects.contains(subject)) {
                        existingSubjects.add(subject);
                        // 更新学科匹配数量
                        if (subjects.containsValue(subject)) {
                            existingTeacherInfo.setSubjectMatchCount(existingTeacherInfo.getSubjectMatchCount() + 1);
                        }
                    }
                } else {
                    // 老师不存在，创建新的TeacherInfo对象
                    TeacherInfo newTeacherInfo = new TeacherInfo();
                    newTeacherInfo.setTeacherUid(teacher.getTeacherUid());
                    newTeacherInfo.setRating(teacher.getRating());
                    newTeacherInfo.setComments(teacher.getComments());
                    
                    // 初始化学科列表并添加当前学科
                    List<String> teacherSubjects = new ArrayList<>();
                    if (subject != null) {
                        teacherSubjects.add(subject);
                    }
                    newTeacherInfo.setSubjects(teacherSubjects);
                    
                    // 设置科目匹配数量
                    int matchCount = (subject != null && subjects.containsValue(subject)) ? 1 : 0;
                    newTeacherInfo.setSubjectMatchCount(matchCount);
                    
                    result.add(newTeacherInfo);
                }

            LOGGER.info("查询完成，共找到{}位符合条件的老师", result.size());
            return Result.success(result);}
        } catch (Exception e) {
            LOGGER.error("查询老师信息失败", e);
            return Result.error("查询老师信息失败：" + e.getMessage());
        }
    }

    //老师信息的存储
    // @PostMapping("/save")
    /**
     * 老师信息内部类 用于表示老师的详细信息
     */
    public static class TeacherInfo {

        private Long teacherUid;         // 老师uid
        private double rating = 0.0;           // 老师评分
        private int comments = 0;            // 老师评价数量
        private List<String> subjects = new ArrayList<>();   // 老师选择的学科
        private int subjectMatchCount = 0;   // 老师选择学科对口数量

        // 无参构造函数
        public TeacherInfo() {
        }

        // 全参构造函数
        public TeacherInfo(Long teacherUid, double rating, int comments, List<String> subjects, int subjectMatchCount) {
            this.teacherUid = teacherUid;
            this.rating = rating;
            this.comments = comments;
            this.subjects = subjects;
            this.subjectMatchCount = subjectMatchCount;
        }

        // getter和setter方法
        public Long getTeacherUid() {
            return teacherUid;
        }

        public void setTeacherUid(Long teacherUid) {
            this.teacherUid = teacherUid;
        }

        public double getRating() {
            return rating;
        }

        public void setRating(double rating) {
            this.rating = rating;
        }

        public int getComments() {
            return comments;
        }

        public void setComments(int comments) {
            this.comments = comments;
        }

        public List<String> getSubjects() {
            return subjects;
        }

        public void setSubjects(List<String> subjects) {
            this.subjects = subjects;
        }

        public int getSubjectMatchCount() {
            return subjectMatchCount;
        }

        public void setSubjectMatchCount(int subjectMatchCount) {
            this.subjectMatchCount = subjectMatchCount;
        }
    }
}
