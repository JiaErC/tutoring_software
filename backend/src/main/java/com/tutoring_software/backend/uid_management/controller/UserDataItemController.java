package com.tutoring_software.backend.uid_management.controller;

import com.tutoring_software.backend.uid_management.Result;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import com.tutoring_software.backend.uid_management.entity.UserDataItem;
import com.tutoring_software.backend.uid_management.service.UserDataItemService;

@RestController
@RequestMapping("/api/user-data-item")
public class UserDataItemController {

    private static final Logger LOGGER = LoggerFactory.getLogger(UserDataItemController.class);

    @Autowired
    private UserDataItemService userDataItemService;

    @GetMapping("/get/{uid}")
    public Result<UserDataItem> getByUid(@PathVariable String uid){
        //把uid转换为Long类型
        Long uidLong = Long.parseLong(uid);
        LOGGER.info("需要查询的uid为:{}",uidLong);
        try{
            UserDataItem result = userDataItemService.getByUid(uidLong);
            if (result != null) {
                return Result.success(result);
            }else{
                return Result.error("UID not found");
            }
        } catch (Exception e) {
            LOGGER.error("Error getting by UID", e);
            return Result.error("Internal server error");
        }
    }

    @PostMapping("/save")
    public Result<String> saveUserDataItem(@RequestBody UserDataItem userDataItem){
        try{
            // 首先检查用户是否已存在
            UserDataItem existingUser = userDataItemService.getByUid(userDataItem.getUid());
            if (existingUser != null) {
                LOGGER.error("用户{}已存在，保存失败", userDataItem.getUid());
                return Result.error("User already exists"); // 返回明确的用户已存在错误
            }
            boolean success = userDataItemService.saveUserDataItem(
                    userDataItem.getUid(),userDataItem.getUsername(),
                    userDataItem.getPhoneNumber(),userDataItem.getEmail(),
                    userDataItem.getBirthday(),userDataItem.getRole(),
                    userDataItem.getGender(),userDataItem.getPassword(),
                    userDataItem.getTeachingSubjects(),userDataItem.getLearningSubjects());
            if(success){
                LOGGER.info("成功存储数据:uid={},username={}",userDataItem.getUid(),userDataItem.getUsername());
                return Result.success("Save successful");
            }else{
                return Result.error("Save failed");
            }
        }catch(Exception e){
            LOGGER.error("Error saving user data item", e);
            return Result.error("Internal server error");
        }
    }
}
