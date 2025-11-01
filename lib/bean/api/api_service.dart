//未来的前后端API通信处理代码

/*
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tutoring_software/modules/user_data/user_data_item.dart';

class ApiService {
  static const String baseUrl = 'https://your-backend-api.com';
  static const String registerEndpoint = '$baseUrl/api/users/register';
  static const String loginEndpoint = '$baseUrl/api/users/login';
  static const String userInfoEndpoint = '$baseUrl/api/users/info';

  // 用户注册
  static Future<Map<String, dynamic>> registerUser(Map<String, dynamic> userData) async {
    final response = await http.post(
      Uri.parse(registerEndpoint),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(userData),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to register user: ${response.body}');
    }
  }

  // 用户登录
  static Future<Map<String, dynamic>> loginUser(String account, String password) async {
    final response = await http.post(
      Uri.parse(loginEndpoint),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'account': account, 'password': password}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to login: ${response.body}');
    }
  }

  // 获取用户信息
  static Future<Map<String, dynamic>> getUserInfo(String token) async {
    final response = await http.get(
      Uri.parse(userInfoEndpoint),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get user info: ${response.body}');
    }
  }
}*/


//在注册页面也需要使用后端传递过来的UID
/* ... existing code ...
  void _handleRegister() async {
    if (!_validateForm()) {
      return;
    }
    try {
      // 准备发送到后端的数据
      final userDataToSend = {
        'username': uName,
        'email': uEmail,
        'phone': uPhone,
        'password': uPassword,
        'gender': uGender.toString(),
        'birthday': uBirthday,
        'role': uRole.toList().join(','),
        'teachSubjects': uTeachSubjects,
        'studySubjects': uStudySubjects,
      };
      
      // 调用API注册用户，获取后端返回的UID
      final response = await ApiService.registerUser(userDataToSend);
      final uid = response['id'] as String;
      
      // 创建用户数据项
      final userDataItem = UserDataItem(
        uID: uid,
        uName: uName,
        uEmail: uEmail,
        uPassword: uPassword, // 在实际应用中，考虑是否需要在本地存储密码
        uPhone: uPhone,
        uBirthday: uBirthday,
        uGender: uGender.toString(),
        uRole: uRole.toList().join(','),
        uTeachSubjects: uTeachSubjects,
        uStudySubjects: uStudySubjects,
      );
      
      // 更新本地状态和存储
      statusController.addStatus(uid);
      if (uPhone.isNotEmpty) {
        accountController.putPhoneNumberUID(uPhone, uid);
      }
      if (uEmail.isNotEmpty) {
        accountController.putEmailUID(uEmail, uid);
      }
      userDataController.saveUserData(userDataItem);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('注册成功！数据已保存。'))
      );
      Modular.to.pushReplacementNamed('/login');
    } catch (e) {
      print('注册失败: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('注册失败: $e'))
      );
    }
  }
// ... existing code ...*/



//未来实现Token管理
/*import 'package:hive/hive.dart';

class TokenManager {
  static late Box<String> tokenBox;
  static const String _tokenKey = 'auth_token';
  
  // 初始化token存储
  static Future<void> init() async {
    tokenBox = await Hive.openBox('tokens');
  }
  
  // 保存token
  static Future<void> saveToken(String token) async {
    await tokenBox.put(_tokenKey, token);
  }
  
  // 获取token
  static String? getToken() {
    return tokenBox.get(_tokenKey);
  }
  
  // 删除token
  static Future<void> deleteToken() async {
    await tokenBox.delete(_tokenKey);
  }
}*/