package com.tutoring_software.backend.uid_management.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;

@TableName("teachers_courses")
public class TeacherCourse {
    // BIGSERIAL 自增id
    @TableId(type = IdType.AUTO)
    private Long id;
    
    // 老师的uid
    @TableField("teacher_uid")
    private Long teacherUid;
    
    // 老师选择教学的学科(6位整数组成的学科ID)
    @TableField("subject")
    private String subject;

    // 无参构造函数
    public TeacherCourse() {
    }
    
    // 全参构造函数
    public TeacherCourse(Long teacherUid, String subject) {
        this.teacherUid = teacherUid;
        this.subject = subject;
    }
    
    // getter 和 setter 方法
    public Long getId() {
        return id;
    }
    
    public void setId(Long id) {
        this.id = id;
    }
    
    public Long getTeacherUid() {
        return teacherUid;
    }
    
    public void setTeacherUid(Long teacherUid) {
        this.teacherUid = teacherUid;
    }
    
    public String getSubject(){
        return subject;
    }
        
    public void setSubject(String subject){
        this.subject = subject;
    }
}