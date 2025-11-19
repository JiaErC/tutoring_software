package com.tutoring_software.backend.uid_management.controller;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.tutoring_software.backend.uid_management.Result;
import com.tutoring_software.backend.uid_management.entity.TSRelationship;
import com.tutoring_software.backend.uid_management.service.TSRelationshipService;

/**
 * 师生关系控制器
 */
@RestController
@RequestMapping("/api/ts-relationship")
public class TSRelationshipController {

    private static final Logger LOGGER = LoggerFactory.getLogger(TSRelationshipController.class);

    @Autowired
    private TSRelationshipService tsRelationshipService;
    
    /**
     * 根据学生UID获取师生关系列表
     */
    @GetMapping("/student/{studentUid}")
    public Result<List<TSRelationship>> getRelationshipsByStudent(@PathVariable Long studentUid) {
        LOGGER.info("需要查询学生{}的师生关系列表", studentUid);
        try {
            List<TSRelationship> result = tsRelationshipService.selectByStudentUid(studentUid);
            if (result != null) {
                return Result.success(result);
            } else {
                return Result.error("No relationships found");
            }
        } catch (Exception e) {
            LOGGER.error("Error getting relationships by student UID", e);
            return Result.error("Internal server error");
        }
    }
    
    /**
     * 根据老师UID获取师生关系列表
     */
    @GetMapping("/teacher/{teacherUid}")
    public Result<List<TSRelationship>> getRelationshipsByTeacher(@PathVariable Long teacherUid) {
        LOGGER.info("需要查询老师{}的师生关系列表", teacherUid);
        try {
            List<TSRelationship> result = tsRelationshipService.selectByTeacherUid(teacherUid);
            if (result != null) {
                return Result.success(result);
            } else {
                return Result.error("No relationships found");
            }
        } catch (Exception e) {
            LOGGER.error("Error getting relationships by teacher UID", e);
            return Result.error("Internal server error");
        }
    }
    
    /**
     * 根据学生UID和老师UID查询特定师生关系
     */
    @GetMapping("/check")
    public Result<TSRelationship> checkRelationship(@RequestParam Long studentUid, @RequestParam Long teacherUid) {
        LOGGER.info("检查学生{}和老师{}的关系", studentUid, teacherUid);
        try {
            TSRelationship relationship = tsRelationshipService.selectByStudentAndTeacherUid(studentUid, teacherUid);
            if (relationship != null) {
                return Result.success(relationship);
            } else {
                return Result.error("Relationship not found");
            }
        } catch (Exception e) {
            LOGGER.error("Error checking relationship", e);
            return Result.error("Internal server error");
        }
    }
    
    /**
     * 保存师生关系
     */
    @PostMapping("/save")
    public Result<String> saveRelationship(@RequestBody TSRelationship tsRelationship) {
        LOGGER.info("保存师生关系: 学生{} 和老师{}", tsRelationship.getStudentUid(), tsRelationship.getTeacherUid());
        try {
            boolean success = tsRelationshipService.saveRelationship(tsRelationship);
            if (success) {
                LOGGER.info("成功保存师生关系: 学生{} 和老师{}", tsRelationship.getStudentUid(), tsRelationship.getTeacherUid());
                return Result.success("Save successful");
            } else {
                return Result.error("Save failed");
            }
        } catch (Exception e) {
            LOGGER.error("Error saving relationship", e);
            return Result.error("Internal server error");
        }
    }
    
    /**
     * 删除师生关系
     */
    @DeleteMapping("/delete")
    public Result<String> deleteRelationship(@RequestParam Long studentUid, @RequestParam Long teacherUid) {
        LOGGER.info("删除师生关系: 学生{} 和老师{}", studentUid, teacherUid);
        try {
            boolean success = tsRelationshipService.deleteRelationship(studentUid, teacherUid);
            if (success) {
                LOGGER.info("成功删除师生关系: 学生{} 和老师{}", studentUid, teacherUid);
                return Result.success("Delete successful");
            } else {
                return Result.error("Delete failed or relationship not found");
            }
        } catch (Exception e) {
            LOGGER.error("Error deleting relationship", e);
            return Result.error("Internal server error");
        }
    }
}