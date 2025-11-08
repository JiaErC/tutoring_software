package com.tutoring_software.backend.uid_management.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;

@TableName("email_id")
public class EmailUid {
    @TableId(type=IdType.AUTO)
    private Long id;

    //字段
    @TableField("email")
    private String email;
    @TableField("uid") // UID字段
    private Long uid;

    //构造函数
    public EmailUid() {}
    public EmailUid(String email, Long uid){
        this.email = email;
        this.uid = uid;
    }
    //getter和setter
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public Long getUid() {
        return uid;
    }

    public void setUid(Long uid) {
        this.uid = uid;
    }
}