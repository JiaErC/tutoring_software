package com.tutoring_software.backend.uid_management.entity;

import java.time.LocalDateTime;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.fasterxml.jackson.annotation.JsonFormat; 

@TableName("comments")
public class CommentItem {
    //BIGSERVAL
    @TableId(type=IdType.AUTO)
    private Long id;

    /*字段*/
    //学生UID
    //老师UID
    @TableField("student_uid")
    private Long studentUid;
    @TableField("teacher_uid")
    private Long teacherUid;

    //评论的内容 VarChar(1000)
    //评分 Char(1)
    //评论的时间 TIMESTAMP、
    //评论的学科VarChar(40)
    @TableField("content")
    private String content;
    @TableField("rating")
    private String rating;
    @TableField("created_at")
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime createdAt;
    @TableField("subject")
    private String subject;

    //构造函数
    public CommentItem() {
    }
    public CommentItem(Long studentUid, Long teacherUid, String content, String rating, LocalDateTime createdAt, String subject) {
        this.studentUid = studentUid;
        this.teacherUid = teacherUid;
        this.content = content;
        this.rating = rating;
        this.createdAt = createdAt;
        this.subject = subject;
    }
    //getter和setter
    public Long getId() {
        return id;
    }
    public void setId(Long id) {
        this.id = id;
    }
    public Long getStudentUid() {
        return studentUid;
    }
    public void setStudentUid(Long studentUid) {
        this.studentUid = studentUid;
    }
    public Long getTeacherUid() {
        return teacherUid;
    }
    public void setTeacherUid(Long teacherUid) {
        this.teacherUid = teacherUid;
    }
    public String getContent() {
        return content;
    }
    public void setContent(String content) {
        this.content = content;
    }
    public String getRating() {
        return rating;
    }
    public void setRating(String rating) {
        this.rating = rating;
    }
    public LocalDateTime getCreatedAt() {
        return createdAt;
    }
    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
    public String getSubject() {
        return subject;
    }
    public void setSubject(String subject) {
        this.subject = subject;
    }

}