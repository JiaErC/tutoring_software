class AccountMatch {
  //邮箱正则表达式
  static final RegExp emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  //电话号码正则表达式（中国手机号）
  static final RegExp phoneRegex = RegExp(r'^1[3-9]\d{9}$');

  //UID正则表达式：19位的数字
  static final RegExp uidRegex = RegExp(r'^\d{19}$');

  // 用户名正则表达式：2-30个字符，允许字母、数字、下划线和中文
  static final RegExp usernameRegex = RegExp(
    r'^[a-zA-Z0-9_\u4e00-\u9fa5]{2,30}$',
  );

  // 验证邮箱格式
  static bool isValidEmail(String email) {
    return emailRegex.hasMatch(email);
  }

  // 验证电话号码格式
  static bool isValidPhone(String phone) {
    return phoneRegex.hasMatch(phone);
  }

  //验证用户UID是否输入正确
  static bool isValidUid(String uid) {
    return uidRegex.hasMatch(uid);
  }

  // 验证用户名格式
  static bool isValidUsername(String username) {
    return usernameRegex.hasMatch(username);
  }
}
