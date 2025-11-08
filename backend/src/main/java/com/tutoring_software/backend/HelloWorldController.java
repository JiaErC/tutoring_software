package com.tutoring_software.backend;

import com.tutoring_software.backend.uid_management.service.PhoneNumberUidService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HelloWorldController {

    @Autowired
    private PhoneNumberUidService phoneNumberUidService;

    private static final Logger logger = LoggerFactory.getLogger(HelloWorldController.class);

    @GetMapping("/hello")
    public String helloWorld() {
        String phoneNumber = "133124448678";
        Long uid = 12336633L;
        try {
            boolean success = phoneNumberUidService.savePhoneNumberUid(phoneNumber, uid);
            if (success) {
                return "保存成功: 电话号码" + phoneNumber + " 与 UID " + uid + " 已关联";
            } else {
                return "保存失败，请重试";
            }
        } catch (Exception e) {
            logger.error("保存电话号码与UID映射关系时发生错误", e);
            return "保存时发生错误: " + e.getMessage();
        }
    }
//
//    /**
//     * 存储电话号码和UID的映射关系
//     * 调用示例: POST /hello/save-phone-uid?phoneNumber=13812345678&uid=123456
//     */
//    @PostMapping("/hello/save-phone-uid")
//    public String savePhoneNumberUid(@RequestParam String phoneNumber, @RequestParam Long uid) {
//        try {
//            boolean success = phoneNumberUidService.savePhoneNumberUid(phoneNumber, uid);
//            if (success) {
//                return "保存成功: 电话号码" + phoneNumber + " 与 UID " + uid + " 已关联";
//            } else {
//                return "保存失败，请重试";
//            }
//        } catch (Exception e) {
//            return "保存时发生错误: " + e.getMessage();
//        }
//    }
//
//    /**
//     * 根据电话号码查询对应的UID
//     * 调用示例: GET /hello/get-uid-by-phone?phoneNumber=13812345678
//     */
//    @GetMapping("/hello/get-uid-by-phone")
//    public String getUidByPhoneNumber(@RequestParam String phoneNumber) {
//        try {
//            return phoneNumberUidService.getByPhoneNumber(phoneNumber) != null
//                    ? "查询结果: 电话号码" + phoneNumber + " 对应的UID是 " + phoneNumberUidService.getByPhoneNumber(phoneNumber).getUid()
//                    : "未找到该电话号码对应的UID";
//        } catch (Exception e) {
//            return "查询时发生错误: " + e.getMessage();
//        }
//    }
//
//    /**
//     * 根据UID查询对应的电话号码
//     * 调用示例: GET /hello/get-phone-by-uid?uid=123456
//     */
//    @GetMapping("/hello/get-phone-by-uid")
//    public String getPhoneByUid(@RequestParam Long uid) {
//        try {
//            return phoneNumberUidService.getByUid(uid) != null
//                    ? "查询结果: UID " + uid + " 对应的电话号码是 " + phoneNumberUidService.getByUid(uid).getPhoneNumber()
//                    : "未找到该UID对应的电话号码";
//        } catch (Exception e) {
//            return "查询时发生错误: " + e.getMessage();
//        }
//    }
}