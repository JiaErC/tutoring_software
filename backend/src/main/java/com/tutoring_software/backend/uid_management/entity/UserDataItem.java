package com.tutoring_software.backend.uid_management.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;

@TableName("user_data_item")
public class UserDataItem {
    //主键字段
    @TableId(type = IdType.AUTO)
    private Long id;
    //字段：分别为
    // uid BIGINT 不能为空
    // 用户名 varchar(100) 不能为空
    // 手机号 varchar(20) 可以为空
    // 邮箱 varchar(255) 可以为空
    // 生日 varchar(20) 可以为空
    // 身份 varchar(15) 不可为空
    //性别 varchar(10) 不可为空
    // 密码 varchar(40) 不可为空
    @TableField("uid")
    private Long uid;
    @TableField("username")
    private String username;
    @TableField("phone_number")
    private String phoneNumber = "";
    @TableField("email")
    private String email = "";
    @TableField("birthday")
    private String birthday = "";
    @TableField("role")
    private String role;
    @TableField("gender")
    private String gender = "隐藏";
    @TableField("password")
    private String password;
    public UserDataItem(){}
    public UserDataItem(Long uid, String username, String phoneNumber, String email, String birthday, String role, String gender, String password) {
        this.uid = uid;
        this.username = username;
        this.phoneNumber = phoneNumber;
        this.email = email;
        this.birthday = birthday;
        this.role = role;
        this.gender = gender;
        this.password = password;
    }

    //getter 和 setter
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
    public String getUsername() {
        return username;
    }
    public void setUsername(String username) {
        this.username = username;
    }
    public String getPhoneNumber() {
        return phoneNumber;
    }
    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }
    public String getEmail() {
        return email;
    }
    public void setEmail(String email) {
        this.email = email;
    }
    public String getBirthday() {
        return birthday;
    }
    public void setBirthday(String birthday) {
        this.birthday = birthday;
    }
    public String getRole() {
        return role;
    }
    public void setRole(String role) {
        this.role = role;
    }
    public String getGender() {
        return gender;
    }
    public void setGender(String gender) {
        this.gender = gender;
    }
    public String getPassword() {
        return password;
    }
    public void setPassword(String password) {
        this.password = password;
    }
}
