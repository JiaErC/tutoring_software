package com.tutoring_software.backend.uid_management.controller;

import com.tutoring_software.backend.uid_management.entity.CommentItem;
import com.tutoring_software.backend.uid_management.entity.Teacher;
import com.tutoring_software.backend.uid_management.service.CommentItemService;
import com.tutoring_software.backend.uid_management.service.TeacherService;
import com.tutoring_software.backend.uid_management.Result;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.time.LocalDateTime;

/**
 * 评论控制器
 */
@RestController
@RequestMapping("/api/comment")
public class CommentItemController {

    private static final Logger LOGGER = LoggerFactory.getLogger(CommentItemController.class);

    @Autowired
    private CommentItemService commentItemService;

    @Autowired
    private TeacherService teacherService;

    /**
     * 根据老师UID获取评论列表
     */
    @GetMapping("/teacher/{teacherUid}")
    public Result<List<CommentItem>> getCommentsByTeacher(@PathVariable Long teacherUid) {
        LOGGER.info("需要查询老师{}的评论列表", teacherUid);
        try {
            List<CommentItem> result = commentItemService.getCommentsByTeacherUid(teacherUid);
            if (result != null) {
                return Result.success(result);
            } else {
                return Result.error("No comments found");
            }
        } catch (Exception e) {
            LOGGER.error("Error getting comments by teacher UID", e);
            return Result.error("Internal server error");
        }
    }

    /**
     * 根据学生UID获取评论列表
     */
    @GetMapping("/student/{studentUid}")
    public Result<List<CommentItem>> getCommentsByStudent(@PathVariable Long studentUid) {
        LOGGER.info("需要查询学生{}的评论列表", studentUid);
        try {
            List<CommentItem> result = commentItemService.getCommentsByStudentUid(studentUid);
            if (result != null) {
                return Result.success(result);
            } else {
                return Result.error("No comments found");
            }
        } catch (Exception e) {
            LOGGER.error("Error getting comments by student UID", e);
            return Result.error("Internal server error");
        }
    }

    /**
     * 保存评论
     */
    @PostMapping("/save")
    public Result<String> saveComment(@RequestBody CommentItem commentItem) {
        LOGGER.info("保存评论: 学生{} 评论老师{}", commentItem.getStudentUid(), commentItem.getTeacherUid());
        try {
            // 设置创建时间
            if (commentItem.getCreatedAt() == null) {
                commentItem.setCreatedAt(LocalDateTime.now());
            }
            boolean success = commentItemService.saveComment(commentItem);
            if (success) {
                LOGGER.info("成功保存评论: 学生{} 评论老师{}", commentItem.getStudentUid(), commentItem.getTeacherUid());
                // 更新老师的评论数
                Teacher teacher = teacherService.getByTeacherUid(commentItem.getTeacherUid());
                if (teacher != null) {
                    double commentRating = Double.parseDouble(commentItem.getRating());
                    double currentRating = teacher.getRating();
                    double newRating = (currentRating * teacher.getComments() + commentRating)
                            / (teacher.getComments() + 1);
                    int newComments = teacher.getComments() + 1;
                    teacherService.updateTeacher(commentItem.getTeacherUid(), newRating, newComments);
                }
                return Result.success("Save successful");
            } else {
                return Result.error("Save failed");
            }
        } catch (Exception e) {
            LOGGER.error("Error saving comment", e);
            return Result.error("Internal server error");
        }
    }
}