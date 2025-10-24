import "package:flutter/material.dart";
import "package:flutter_material_design_icons/flutter_material_design_icons.dart";
import "package:flutter_modular/flutter_modular.dart";

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

//定义性别 0 保密，1：男，2：女
int? _gender = 0;
//选择学生还是老师，也就是应用的身份，1：学生，2：老师
Set<int> _selectedRoles = {};
//是否选择了学科，老师的和学生的
bool _isTeachSelectedSubject = false;
bool _isStudySelectedSubject = false;

class _RegisterPageState extends State<RegisterPage> {
  //创建一个是否横屏的显示器
  bool _isLandscape = false;

  //这个是
  Widget _textPrompt(bool isSelected) {
    return isSelected
        ? Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Center(
              child: Text(
                '已选择学科',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )
        : Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.redAccent,
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Center(
              child: Text(
                '请选择学科',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    _isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    return Scaffold(
      // 添加返回按钮
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context), // 返回上一级路由
        ),
        title: const Text('注册'), // 设置页面标题
      ),
      backgroundColor: Colors.white,
      body: _isLandscape
          ? Align(alignment: Alignment.center, child: _buildRegister(context))
          : _buildRegister(context),
    );
  }

  Widget _buildRegister(BuildContext context) {
    //返回注册的各个项目
    return SingleChildScrollView(
      padding: _isLandscape
          ? const EdgeInsets.symmetric(horizontal: 150)
          : const EdgeInsets.all(0),
      child: Column(
        children: [
          const SizedBox(height: 20),
          const Text('注册账户'),
          const SizedBox(height: 10),
          //写入用户名
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: TextField(
              // controller: _loginPageCtr.usernameTextController,
              // inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r"\s"))],
              decoration: InputDecoration(
                prefixIcon: const Icon(MdiIcons.account),
                border: const UnderlineInputBorder(),
                labelText: '用户名',
                // hintText: '邮箱/手机号',
                suffixIcon: IconButton(
                  onPressed: () => debugPrint("清空用户名"),
                  icon: const Icon(Icons.clear),
                ),
              ),
            ),
          ),
          //写入email
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: TextField(
              // controller: _loginPageCtr.usernameTextController,
              // inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r"\s"))],
              decoration: InputDecoration(
                prefixIcon: const Icon(MdiIcons.email),
                border: const UnderlineInputBorder(),
                labelText: '邮箱',
                // hintText: '邮箱/手机号',
                suffixIcon: IconButton(
                  onPressed: () => debugPrint("清空邮箱"),
                  icon: const Icon(Icons.clear),
                ),
              ),
            ),
          ),
          //写入电话号码
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: TextField(
              // controller: _loginPageCtr.usernameTextController,
              // inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r"\s"))],
              decoration: InputDecoration(
                prefixIcon: const Icon(MdiIcons.phone),
                border: const UnderlineInputBorder(),
                labelText: '电话号码',
                // hintText: '邮箱/手机号',
                suffixIcon: IconButton(
                  onPressed: () => debugPrint("清空电话号码"),
                  icon: const Icon(Icons.clear),
                ),
              ),
            ),
          ),
          //两次写入密码
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: TextField(
              obscureText: true,
              // controller: _loginPageCtr.usernameTextController,
              // inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r"\s"))],
              decoration: InputDecoration(
                prefixIcon: const Icon(MdiIcons.lock),
                border: const UnderlineInputBorder(),
                labelText: '密码',
                // hintText: '邮箱/手机号',
                suffixIcon: IconButton(
                  onPressed: () => debugPrint("清空密码"),
                  icon: const Icon(Icons.clear),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: TextField(
              obscureText: true,
              // controller: _loginPageCtr.usernameTextController,
              // inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r"\s"))],
              decoration: InputDecoration(
                prefixIcon: const Icon(MdiIcons.lock),
                border: const UnderlineInputBorder(),
                labelText: '请再次输入密码',
                // hintText: '邮箱/手机号',
                suffixIcon: IconButton(
                  onPressed: () => debugPrint("清空密码"),
                  icon: const Icon(Icons.clear),
                ),
              ),
            ),
          ),
          //性别选择
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: RadioGroup<int>(
              groupValue: _gender,
              onChanged: (value) {
                setState(() {
                  _gender = value;
                  debugPrint('性别：$_gender');
                });
              },
              child: Row(
                children: <Widget>[
                  const Icon(MdiIcons.genderMaleFemale),
                  const SizedBox(width: 10),
                  const Text(
                    '性别',
                    style: TextStyle(fontSize: 12, color: Colors.black87),
                  ),
                  Radio<int>(value: 1),
                  const Text('男'),
                  Radio<int>(value: 2),
                  const Text('女'),
                  Radio<int>(value: 0),
                  const Text('保密'),
                ],
              ),
            ),
          ),
          //接下来是生日信息
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
                const Icon(MdiIcons.cake),
                const SizedBox(width: 10),
                const Text(
                  '生日',
                  style: TextStyle(fontSize: 12, color: Colors.black87),
                ),
                const SizedBox(width: 60),
                //选择出生日期
                SizedBox(
                  width: 200,
                  child:
                      //选择年、月、日
                      OutlinedButton.icon(
                        onPressed: () async {
                          final DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime(
                              2000,
                              1,
                              1,
                            ), // 初始选中日期，例如2000年1月1日
                            firstDate: DateTime(1900), // 允许选择的最早日期
                            lastDate: DateTime.now(), // 允许选择的最晚日期（今天）
                            helpText: '选择您的生日', // 自定义对话框标题
                            cancelText: '取消', // 自定义取消按钮文字
                            confirmText: '确定', // 自定义确认按钮文字
                          );

                          if (pickedDate != null) {
                            // 用户选择了日期，可以在这里处理 pickedDate
                            debugPrint("选择的生日是: $pickedDate");
                            // 例如：更新状态，将生日显示在界面上
                          }
                        },
                        icon: const Icon(MdiIcons.calendar),
                        label: const Text('选择生日'),
                      ),
                ),
              ],
            ),
          ),
          //选择学生还是老师，也就是应用的身份，1：学生，2：老师
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: <Widget>[
                const Icon(MdiIcons.accountCog),
                const SizedBox(width: 10),
                const Text(
                  '身份',
                  style: TextStyle(fontSize: 12, color: Colors.black87),
                ),
                // 替换为Checkbox组件
                Row(
                  children: [
                    Checkbox(
                      value: _selectedRoles.contains(1),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            _selectedRoles.add(1);
                          } else {
                            _selectedRoles.remove(1);
                          }
                          debugPrint('选中的身份：$_selectedRoles');
                        });
                      },
                    ),
                    const Text('学生'),
                  ],
                ),
                Row(
                  children: [
                    Checkbox(
                      value: _selectedRoles.contains(2),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            _selectedRoles.add(2);
                          } else {
                            _selectedRoles.remove(2);
                          }
                          debugPrint('选中的身份：$_selectedRoles');
                        });
                      },
                    ),
                    const Text('老师'),
                  ],
                ),
              ],
            ),
          ),
          //当用户选择了学生身份的时候
          //显示这个组件，用来选择学习的科目
          if (_selectedRoles.contains(1))
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: _buildStudySubjects(context),
            ),
          //当用户选择了老师身份的时候
          //显示这个组件，用来选择教学的科目
          if (_selectedRoles.contains(2))
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: _buildTeachSubjects(context),
            ),
          //确定按钮
          Center(
            child: OutlinedButton.icon(
              onPressed: () => debugPrint("确定"),
              icon: const Icon(Icons.login),
              label: const Text('确定'),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  //跳转到选择学习科目的界面
  Widget _buildStudySubjects(BuildContext context) {
    return Row(
      children: [
        const Icon(MdiIcons.bookOpen),
        const SizedBox(width: 10),
        const Text(
          "选择学习科目",
          style: TextStyle(fontSize: 12, color: Colors.black87),
        ),
        const SizedBox(width: 60),
        //跳转到选择科目的界面
        OutlinedButton.icon(
          onPressed: () => Modular.to.pushNamed(
            '/subjects',
            arguments: {'isTeacher': false},
          ),
          icon: const Icon(MdiIcons.pencil),
          label: const Text('选择科目'),
        ),
        const SizedBox(width: 60),
        //提示框，提示是否选择了学科
        _textPrompt(_isStudySelectedSubject),
      ],
    );
  }

  //跳转到选择教学科目的界面
  Widget _buildTeachSubjects(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.book),
        const SizedBox(width: 10),
        const Text(
          "选择教学科目",
          style: TextStyle(fontSize: 12, color: Colors.black87),
        ),
        const SizedBox(width: 60),
        //跳转到选择科目的界面
        OutlinedButton.icon(
          onPressed: () =>
              Modular.to.pushNamed('/subjects', arguments: {'isTeacher': true}),
          icon: const Icon(MdiIcons.pen),
          label: const Text('选择科目'),
        ),
        const SizedBox(width: 60),
        //提示框，提示是否选择了学科
        _textPrompt(_isTeachSelectedSubject),
      ],
    );
  }
}
