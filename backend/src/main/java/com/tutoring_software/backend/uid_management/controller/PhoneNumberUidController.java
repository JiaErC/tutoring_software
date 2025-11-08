package com.tutoring_software.backend.uid_management.controller;

import com.tutoring_software.backend.uid_management.entity.PhoneNumberUid;
import com.tutoring_software.backend.uid_management.service.PhoneNumberUidService;
import com.tutoring_software.backend.uid_management.Result;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/phone-uid")
public class PhoneNumberUidController {

    private static final Logger LOGGER = LoggerFactory.getLogger(PhoneNumberUidController.class);

    @Autowired
    private PhoneNumberUidService phoneNumberUidService;

    @GetMapping("/by-phone/{phoneNumber}")
    public Result<PhoneNumberUid> getByPhoneNumber(@PathVariable String phoneNumber) {
        try {
            PhoneNumberUid result = phoneNumberUidService.getByPhoneNumber(phoneNumber);
            if (result != null) {
                return Result.success(result);
            } else {
                return Result.error("Phone number not found");
            }
        } catch (Exception e) {
            LOGGER.error("Error getting by phone number", e);
            return Result.error("Internal server error");
        }
    }

    @GetMapping("/by-uid/{uid}")
    public Result<PhoneNumberUid> getByUid(@PathVariable Long uid) {
        try {
            PhoneNumberUid result = phoneNumberUidService.getByUid(uid);
            if (result != null) {
                return Result.success(result);
            } else {
                return Result.error("UID not found");
            }
        } catch (Exception e) {
            LOGGER.error("Error getting by UID", e);
            return Result.error("Internal server error");
        }
    }

    @PostMapping("/save")
    public Result<String> savePhoneNumberUid(@RequestParam String phoneNumber, @RequestParam Long uid) {
        try {
            boolean success = phoneNumberUidService.savePhoneNumberUid(phoneNumber, uid);
            if (success) {
                //打印成功信息
                LOGGER.info("Successfully saved PhoneNumberUid: phoneNumber={}, uid={}", phoneNumber, uid);
                return Result.success("Save successful");
            } else {
                return Result.error("Save failed");
            }
        } catch (Exception e) {
            LOGGER.error("Error saving phone number UID", e);
            return Result.error("Internal server error");
        }
    }

    @PutMapping
    public Result<String> updatePhoneNumberUid(@RequestParam String phoneNumber, @RequestParam Long uid) {
        try {
            boolean success = phoneNumberUidService.updateByPhoneNumber(phoneNumber, uid);
            if (success) {
                return Result.success("Update successful");
            } else {
                return Result.error("Update failed or phone number not found");
            }
        } catch (Exception e) {
            LOGGER.error("Error updating phone number UID", e);
            return Result.error("Internal server error");
        }
    }

    @DeleteMapping("/{phoneNumber}")
    public Result<String> deleteByPhoneNumber(@PathVariable String phoneNumber) {
        try {
            boolean success = phoneNumberUidService.deleteByPhoneNumber(phoneNumber);
            if (success) {
                return Result.success("Delete successful");
            } else {
                return Result.error("Delete failed or phone number not found");
            }
        } catch (Exception e) {
            LOGGER.error("Error deleting by phone number", e);
            return Result.error("Internal server error");
        }
    }
}