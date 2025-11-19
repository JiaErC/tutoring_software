package com.tutoring_software.backend.uid_management.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;

@TableName("user_signature")
public class UserSignature {
    // 主键字段
    @TableId(type = IdType.AUTO)
    private Long id;
    // 关联用户ID，NOT NULL约束
    @TableField("uid")
    private Long uid;
    //用户的签名
    @TableField("signatures")
    private String signatures;
    
    //构造方法
    public UserSignature(){}
    public UserSignature(Long uid, String signatures) {
        this.uid = uid;
        this.signatures = signatures;
    }

    //getter和setter
    public Long getId() {
        return id;
    }
    public void setId(Long id) {
        this.id = id;
    }
    public Long getUid() {
        return uid;
    }
    public void setUid(Long uid) {
        this.uid = uid;
    }
    public String getSignatures() {
        return signatures;
    }
    public void setSignatures(String signatures) {
        this.signatures = signatures;
    }
}