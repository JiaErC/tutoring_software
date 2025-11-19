package com.tutoring_software.backend.uid_management.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;

@TableName("teachers")
public class Teacher {
    // BIGSERIAL 自增id
    @TableId(type = IdType.AUTO)
    private Long id;
    
    // 老师的uid
    @TableField("teacher_uid")
    private Long teacherUid;
    
    // 老师的评分rating
    @TableField("rating")
    private String rating;
    
    // 老师教学的学科号（六位数字组成的字符串）
    @TableField("subject_code")
    private String subjectCode;
    
    // 无参构造函数
    public Teacher() {
    }
    
    // 全参构造函数
    public Teacher(Long teacherUid, String rating, String subjectCode) {
        this.teacherUid = teacherUid;
        this.rating = rating;
        this.subjectCode = subjectCode;
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
    
    public String getRating() {
        return rating;
    }
    
    public void setRating(String rating) {
        this.rating = rating;
    }
    
    public String getSubjectCode() {
        return subjectCode;
    }
    
    public void setSubjectCode(String subjectCode) {
        this.subjectCode = subjectCode;
    }
}