package com.tutoring_software.backend.uid_management.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import java.time.LocalDateTime;

@TableName("user_avatars")
public class ImageData {
    // 主键字段
    @TableId(type = IdType.AUTO)
    private Long id;
    
    // 关联用户ID，NOT NULL约束
    @TableField("uid")
    private Long uid;
    
    // 图片二进制数据，NOT NULL约束
    @TableField("image_data")
    private byte[] imageData;
    
    // 图片类型，如 'image/jpeg'
    @TableField("mime_type")
    private String mimeType;
    
    // 创建时间，默认值为当前时间戳
    @TableField("created_at")
    private LocalDateTime createdAt;

    // Getter和Setter方法
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

    public byte[] getImageData() {
        return imageData;
    }

    public void setImageData(byte[] imageData) {
        this.imageData = imageData;
    }

    public String getMimeType() {
        return mimeType;
    }

    public void setMimeType(String mimeType) {
        this.mimeType = mimeType;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
}
