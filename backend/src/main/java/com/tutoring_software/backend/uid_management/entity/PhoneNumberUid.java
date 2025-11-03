package com.tutoring_software.backend.uid_management.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;

@TableName("phone_number_id")
public class PhoneNumberUid {
    //主键字段
    @TableId(type = IdType.AUTO)
    private Long id;
    //字段
    @TableField("phone_number") // 手机号字段
    private String phoneNumber;
    @TableField("uid") // UID字段
    private Long uid;

    // 构造函数
    public PhoneNumberUid() {}
}
