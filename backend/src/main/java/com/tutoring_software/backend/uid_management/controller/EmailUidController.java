package com.tutoring_software.backend.uid_management.controller;

import com.tutoring_software.backend.uid_management.Result;
import com.tutoring_software.backend.uid_management.entity.EmailUid;
import com.tutoring_software.backend.uid_management.service.EmailUidService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/email-uid")
public class EmailUidController {

    private static final Logger LOGGER = LoggerFactory.getLogger(EmailUidController.class);

    @Autowired
    private EmailUidService emailUidService;

    @GetMapping("/by-email/{email}")
    public Result<EmailUid> getByEmail(@PathVariable String email) {
        try {
            EmailUid result = emailUidService.getByEmail(email);
            if (result != null) {
                return Result.success(result);
            } else {
                return Result.error("Email not found");
            }
        } catch (Exception e) {
            LOGGER.error("Error getting by email", e);
            return Result.error("Internal server error");
        }
    }

    @GetMapping("/by-uid/{uid}")
    public Result<EmailUid> getByUid(@PathVariable Long uid) {
        try {
            EmailUid result = emailUidService.getByUid(uid);
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

    @PostMapping
    public Result<EmailUid> save(@RequestBody EmailUid emailUid) {
        try {
            boolean success = emailUidService.saveEmailUid(emailUid.getEmail(), emailUid.getUid());
            if (success) {
                return Result.success(emailUid);
            } else {
                return Result.error("Save failed");
            }
        } catch (Exception e) {
            LOGGER.error("Error saving email UID", e);
            return Result.error("Internal server error");
        }
    }

    @PostMapping
    public Result<EmailUid> saveEmailUid(@RequestParam String email, @RequestParam Long uid) {
        try {
            boolean success = emailUidService.saveEmailUid(email, uid);
            if (success) {
                return Result.success(new EmailUid(email, uid));
            } else {
                return Result.error("Save failed");
            }
        } catch (Exception e) {
            LOGGER.error("Error saving email UID", e);
            return Result.error("Internal server error");
        }
    }

    @PutMapping
    public Result<String> updateEmailUid(@RequestParam String email, @RequestParam Long uid) {
        try {
            boolean success = emailUidService.updateByEmail(email, uid);
            if (success) {
                return Result.success("Update successful");
            } else {
                return Result.error("Update failed or email not found");
            }
        } catch (Exception e) {
            LOGGER.error("Error updating email UID", e);
            return Result.error("Internal server error");
        }
    }

    @DeleteMapping("/{email}")
    public Result<String> deleteByEmail(@PathVariable String email) {
        try {
            boolean success = emailUidService.deleteByEmail(email);
            if (success) {
                return Result.success("Delete successful");
            } else {
                return Result.error("Delete failed or email not found");
            }
        } catch (Exception e) {
            LOGGER.error("Error deleting by email", e);
            return Result.error("Internal server error");
        }
    }
}