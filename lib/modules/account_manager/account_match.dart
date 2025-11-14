class AccountMatch {
  //邮箱正则表达式
  static final RegExp emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );
  
  //电话号码正则表达式（中国手机号）
  static final RegExp phoneRegex = RegExp(r'^1[3-9]\d{9}$');
  
  // 验证邮箱格式
  static bool isValidEmail(String email) {
    return emailRegex.hasMatch(email);
  }
  
  // 验证电话号码格式
  static bool isValidPhone(String phone) {
    return phoneRegex.hasMatch(phone);
  }
}