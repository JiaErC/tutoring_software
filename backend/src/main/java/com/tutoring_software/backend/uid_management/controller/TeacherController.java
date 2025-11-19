package com.tutoring_software.backend.uid_management.controller;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.tutoring_software.backend.uid_management.Result;
import com.tutoring_software.backend.uid_management.entity.Teacher;
import com.tutoring_software.backend.uid_management.service.TeacherService;

@RestController
@RequestMapping("/api/teacher")
public class TeacherController {

    private static final Logger LOGGER = LoggerFactory.getLogger(TeacherController.class);

    @Autowired
    private TeacherService teacherService;

    // 根据老师uid获取老师信息
    @GetMapping("/get/{teacherUid}")
    public Result<Teacher> getByTeacherUid(@PathVariable String teacherUid) {
        // 把teacherUid转换为Long类型
        Long teacherUidLong = Long.valueOf(teacherUid);
        LOGGER.info("需要查询的老师uid为:{}", teacherUidLong);
        try {
            Teacher result = teacherService.getByTeacherUid(teacherUidLong);
            if (result != null) {
                return Result.success(result);
            } else {
                return Result.error("Teacher UID not found");
            }
        } catch (Exception e) {
            LOGGER.error("Error getting teacher by UID", e);
            return Result.error("Internal server error");
        }
    }

    // 根据学科代码获取老师列表
    @GetMapping("/getBySubjectCode/{subjectCode}")
    public Result<List<Teacher>> getBySubjectCode(@PathVariable String subjectCode) {
        LOGGER.info("需要查询的学科代码为:{}", subjectCode);
        try {
            List<Teacher> result = teacherService.getBySubjectCode(subjectCode);
            return Result.success(result);
        } catch (Exception e) {
            LOGGER.error("Error getting teachers by subject code", e);
            return Result.error("Internal server error");
        }
    }

    // 保存老师信息
    @PostMapping("/save")
    public Result<String> saveTeacher(@RequestBody Teacher teacher) {
        try {
            // 首先检查老师是否已存在
            Teacher existingTeacher = teacherService.getByTeacherUid(teacher.getTeacherUid());
            if (existingTeacher != null) {
                LOGGER.error("老师{}已存在，保存失败", teacher.getTeacherUid());
                return Result.error("Teacher already exists"); // 返回明确的老师已存在错误
            }
            boolean success = teacherService.saveTeacher(
                    teacher.getTeacherUid(),
                    teacher.getRating(),
                    teacher.getSubjectCode());
            if (success) {
                LOGGER.info("成功存储老师数据:teacherUid={},subjectCode={}",
                        teacher.getTeacherUid(),
                        teacher.getSubjectCode());
                return Result.success("Save successful");
            } else {
                return Result.error("Save failed");
            }
        } catch (Exception e) {
            LOGGER.error("Error saving teacher data", e);
            return Result.error("Internal server error");
        }
    }

    // 更新老师信息
    @PutMapping("/update")
    public Result<String> updateTeacher(@RequestBody Teacher teacher) {
        try {
            // 检查老师是否存在
            Teacher existingTeacher = teacherService.getByTeacherUid(teacher.getTeacherUid());
            if (existingTeacher == null) {
                LOGGER.error("老师{}不存在，更新失败", teacher.getTeacherUid());
                return Result.error("Teacher not found");
            }

            boolean success = teacherService.updateTeacher(
                    teacher.getTeacherUid(),
                    teacher.getRating(),
                    teacher.getSubjectCode());

            if (success) {
                LOGGER.info("成功更新老师数据:teacherUid={},subjectCode={}",
                        teacher.getTeacherUid(),
                        teacher.getSubjectCode());
                return Result.success("Update successful");
            } else {
                return Result.error("Update failed");
            }
        } catch (Exception e) {
            LOGGER.error("Error updating teacher data", e);
            return Result.error("Internal server error");
        }
    }
}
