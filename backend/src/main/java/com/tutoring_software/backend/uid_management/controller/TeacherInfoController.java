package com.tutoring_software.backend.uid_management.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
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
     *
     * @param request 包含查询条件的请求体
     * @return 符合条件的老师列表
     */
    @PostMapping("/search")
    public Result<List<TeacherInfo>> searchTeachers(@RequestBody Map<String, Object> request) {
        // 用来存储老师信息的列表
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
            } else {
                filteredTeachers = teacherService.getByRatingGreaterThan(minRating);
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
            }
            LOGGER.info("查询完成，共找到{}位符合条件的老师", result.size());
            return Result.success(result);
        } catch (Exception e) {
            LOGGER.error("查询老师信息失败", e);
            return Result.error("查询老师信息失败：" + e.getMessage());
        }
    }

    @PostMapping("/register")
    public Result<String> registerTeacher(@RequestBody Map<String, Object> request) {
        try {
            LOGGER.info("开始存储老师注册信息: {}", request);

            // 1. 提取请求参数
            Long teacherUid = null;
            // String subjectCode = null;
            Map<String, String> subjects = new HashMap<>();

            if (request.get("teacherUid") != null) {
                try {
                    teacherUid = Long.parseLong(request.get("teacherUid").toString());
                } catch (NumberFormatException e) {
                    LOGGER.error("老师UID格式无效: {}", request.get("teacherUid"));
                    return Result.error("老师UID格式无效");
                }
            }

            // 修改为处理Map类型的subjects
            if (request.get("subjects") != null) {
                try {
                    // 假设传入的subjects是一个Map<String, String>，其中key为学科ID，value为学科名称
                    Object subjectsObj = request.get("subjects");
                    if (subjectsObj instanceof Map) {
                        subjects = (Map<String, String>) subjectsObj;
                    } else {
                        LOGGER.error("学科信息格式不正确，应为Map类型");
                        return Result.error("学科信息格式不正确，应为Map类型");
                    }
                } catch (Exception e) {
                    LOGGER.error("解析学科信息失败: {}", e.getMessage());
                    return Result.error("解析学科信息失败");
                }
            }

            // 2. 参数校验
            if (teacherUid == null) {
                LOGGER.error("老师UID不能为空");
                return Result.error("老师UID不能为空");
            }

            if (subjects.isEmpty()) {
                LOGGER.error("至少需要选择一个学科");
                return Result.error("至少需要选择一个学科");
            }

            // 3. 存储老师基本信息到teachers表（只需要存储一次）
            // 保存老师信息：teacherUid, 初始评分0.0, 初始评论数0
            boolean teacherSaved = teacherService.saveTeacher(teacherUid, 0.0, 0);
            if (!teacherSaved) {
                LOGGER.error("保存老师基本信息失败，teacherUid: {}", teacherUid);
                return Result.error("保存老师基本信息失败");
            }

            // 4. 遍历所有学科，存储老师课程信息到teachers_courses表
            boolean allCoursesSaved = true;
            StringBuilder failedSubjects = new StringBuilder();

            for (Map.Entry<String, String> entry : subjects.entrySet()) {
                String subjectCode = entry.getKey();

                boolean courseSaved = teacherCourseService.saveTeacherCourse(teacherUid, subjectCode);
                if (!courseSaved) {
                    allCoursesSaved = false;
                    failedSubjects.append(subjectCode).append(", ");
                    LOGGER.error("保存老师课程信息失败，teacherUid: {}, subjectCode: {}", teacherUid, subjectCode);
                }
            }

            if (!allCoursesSaved) {
                LOGGER.error("部分课程信息保存失败，失败的学科代码: {}", failedSubjects.toString());
                return Result.error("部分课程信息保存失败: " + failedSubjects.toString());
            }

            LOGGER.info("老师注册信息存储成功，teacherUid: {}, 学科数量: {}", teacherUid, subjects.size());
            return Result.success("老师注册信息存储成功");
        } catch (Exception e) {
            LOGGER.error("存储老师注册信息失败", e);
            return Result.error("存储老师注册信息失败：" + e.getMessage());
        }
    }

    // 当老师修改了自己的教学选课信息的时候，要更新teachers_courses表
    /**
     * 更新老师课程信息
     *
     * @param request 包含老师UID和新学科信息的请求体
     * @return 操作结果
     */
    @PostMapping("/updateCourses")
    public Result<String> updateTeacherCourses(@RequestBody Map<String, Object> request) {
        try {
            LOGGER.info("开始更新老师课程信息: {}", request);

            // 1. 提取请求参数
            Long teacherUid = null;
            Map<String, String> subjects = new HashMap<>();

            if (request.get("teacherUid") != null) {
                try {
                    teacherUid = Long.parseLong(request.get("teacherUid").toString());
                } catch (NumberFormatException e) {
                    LOGGER.error("老师UID格式无效: {}", request.get("teacherUid"));
                    return Result.error("老师UID格式无效");
                }
            }

            // 获取学科信息
            if (request.get("subjects") != null) {
                try {
                    Object subjectsObj = request.get("subjects");
                    if (subjectsObj instanceof Map) {
                        subjects = (Map<String, String>) subjectsObj;
                    } else {
                        LOGGER.error("学科信息格式不正确，应为Map类型");
                        return Result.error("学科信息格式不正确，应为Map类型");
                    }
                } catch (Exception e) {
                    LOGGER.error("解析学科信息失败: {}", e.getMessage());
                    return Result.error("解析学科信息失败");
                }
            }

            // 2. 参数校验
            if (teacherUid == null) {
                LOGGER.error("老师UID不能为空");
                return Result.error("老师UID不能为空");
            }

            if (subjects.isEmpty()) {
                LOGGER.error("至少需要选择一个学科");
                return Result.error("至少需要选择一个学科");
            }

            // 3. 先删除老师现有的所有课程信息
            boolean coursesDeleted = teacherCourseService.deleteTeacherCourse(teacherUid);
            if (!coursesDeleted) {
                LOGGER.error("删除老师原有课程信息失败，teacherUid: {}", teacherUid);
                // 即使删除失败也继续尝试添加新课程，因为可能是因为课程不存在
            }

            // 4. 遍历所有学科，更新老师课程信息
            boolean allCoursesUpdated = true;
            StringBuilder failedSubjects = new StringBuilder();
            for (Map.Entry<String, String> entry : subjects.entrySet()) {
                String subjectCode = entry.getKey();

                boolean courseSaved = teacherCourseService.saveTeacherCourse(teacherUid, subjectCode);
                if (!courseSaved) {
                    allCoursesUpdated = false;
                    failedSubjects.append(subjectCode).append(", ");
                    LOGGER.error("更新老师课程信息失败，teacherUid: {}, subjectCode: {}", teacherUid, subjectCode);
                }
            }

            if (!allCoursesUpdated) {
                LOGGER.error("部分课程信息更新失败，失败的学科代码: {}", failedSubjects.toString());
                return Result.error("部分课程信息更新失败: " + failedSubjects.toString());
            }

            LOGGER.info("老师课程信息更新成功，teacherUid: {}, 学科数量: {}", teacherUid, subjects.size());
            return Result.success("老师课程信息更新成功");
        } catch (Exception e) {
            LOGGER.error("更新老师课程信息失败", e);
            return Result.error("更新老师课程信息失败：" + e.getMessage());
        }
    }

    // 删除老师信息
    /**
     * 删除老师信息
     *
     * @param request 包含老师UID的请求体
     * @return 操作结果
     */
    @DeleteMapping("/delete")
    public Result<String> deleteTeacher(@RequestBody Map<String, Object> request) {
        try {
            LOGGER.info("开始删除老师信息: {}", request);

            // 1. 提取请求参数
            Long teacherUid = null;
            if (request.get("teacherUid") != null) {
                try {
                    teacherUid = Long.parseLong(request.get("teacherUid").toString());
                } catch (NumberFormatException e) {
                    LOGGER.error("老师UID格式无效: {}", request.get("teacherUid"));
                    return Result.error("老师UID格式无效");
                }
            }

            // 2. 参数校验
            if (teacherUid == null) {
                LOGGER.error("老师UID不能为空");
                return Result.error("老师UID不能为空");
            }

            // 3. 先删除老师的课程信息
            teacherCourseService.deleteTeacherCourse(teacherUid);
            // 即使课程信息不存在，也继续删除老师基本信息

            // 4. 再删除老师基本信息
            boolean teacherDeleted = teacherService.deleteTeacher(teacherUid);

            if (teacherDeleted) {
                LOGGER.info("删除老师信息成功，teacherUid: {}", teacherUid);
                return Result.success("删除老师信息成功");
            } else {
                LOGGER.error("删除老师基本信息失败，teacherUid: {}", teacherUid);
                return Result.error("删除老师信息失败");
            }
        } catch (Exception e) {
            LOGGER.error("删除老师信息异常", e);
            return Result.error("删除老师信息失败：" + e.getMessage());
        }
    }

    // 老师信息的存储
    // @PostMapping("/save")
    /**
     * 老师信息内部类 用于表示老师的详细信息
     */
    public static class TeacherInfo {

        private Long teacherUid; // 老师uid
        private double rating = 0.0; // 老师评分
        private int comments = 0; // 老师评价数量
        private List<String> subjects = new ArrayList<>(); // 老师选择的学科
        private int subjectMatchCount = 0; // 老师选择学科对口数量

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
