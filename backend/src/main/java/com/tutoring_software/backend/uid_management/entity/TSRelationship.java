package com.tutoring_software.backend.uid_management.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;

@TableName("teacher_student_relationship")
public class TSRelationship {
    // 主键字段 - BIGSERIAL类型
    @TableId(type = IdType.AUTO)
    private Long id;
    
    // 学生UID字段
    @TableField("student_uid")
    private Long studentUid;
    
    // 老师UID字段
    @TableField("teacher_uid")
    private Long teacherUid;

    //学科选择关系char(6)
    @TableField("subject")
    private String subject;
    
    // 构造函数
    public TSRelationship() {}
    
    public TSRelationship(Long studentUid, Long teacherUid) {
        this.studentUid = studentUid;
        this.teacherUid = teacherUid;
    }
    
    // getter和setter方法
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
    
    public String getSubject() {
        return subject;
    }
    
    public void setSubject(String subject) {
        this.subject = subject;
    }
}