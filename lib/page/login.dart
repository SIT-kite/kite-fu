import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:kite_fu/global/session_pool.dart';
import 'package:kite_fu/global/storage_pool.dart';
import 'package:kite_fu/util/flash.dart';
import 'package:kite_fu/util/logger.dart';
import 'package:kite_fu/util/url_launcher.dart';
import 'package:kite_fu/util/validation.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Text field controllers.
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final GlobalKey _formKey = GlobalKey<FormState>();

  final TapGestureRecognizer _recognizer = TapGestureRecognizer()..onTap = onOpenUserLicense;

  // State
  bool isPasswordClear = false;
  bool isLicenseAccepted = false;
  bool isProxySettingShown = false;
  bool disableLoginButton = false;
  bool showPs = false;

  void gotoFuMainPage() {
    // 跳转页面并移除所有其他页面
    Navigator.of(context).pushNamedAndRemoveUntil(
      '/fu',
      (Route<dynamic> route) => false,
    );
  }

  /// 用户点击登录按钮后
  Future<void> onLogin() async {
    bool formValid = (_formKey.currentState as FormState).validate();
    if (!formValid) {
      return;
    }
    if (!isLicenseAccepted) {
      showBasicFlash(context, const Text('请勾选用户协议'));
      return;
    }

    setState(() {
      disableLoginButton = true;
    });
    try {
      final user = await SessionPool.kiteSession.login(
        _usernameController.text,
        _passwordController.text,
      );

      Log.info(user);

      showBasicFlash(context, const Text('登录成功'));
      StoragePool.account.account = user;
      gotoFuMainPage();
    } catch (e) {
      Log.info('$e');
      showBasicFlash(context, Text('登录异常: ${e.toString().split('\n')[0]}'));
      setState(() {
        disableLoginButton = false;
        showPs = true;
      });
    }
  }

  static void onOpenUserLicense() {
    const url = "https://cdn.kite.sunnysab.cn/license/";
    launchInBrowser(url);
  }

  Widget buildTitleLine() {
    return Container(
        alignment: Alignment.centerLeft,
        child: const Text('欢迎登录', style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)));
  }

  Widget buildLoginForm() {
    return Form(
      autovalidateMode: AutovalidateMode.always,
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _usernameController,
            autofocus: true,
            decoration: const InputDecoration(labelText: '学号', hintText: '输入你的学号', icon: Icon(Icons.person)),
            validator: studentIdValidator,
          ),
          TextFormField(
            controller: _passwordController,
            autofocus: true,
            obscureText: !isPasswordClear,
            decoration: InputDecoration(
              suffixIcon: IconButton(
                icon: Icon(isPasswordClear ? Icons.visibility_off : Icons.visibility),
                onPressed: () {
                  setState(() {
                    isPasswordClear = !isPasswordClear;
                  });
                },
              ),
              labelText: 'OA密码或身份证号倒数第7到2位',
              hintText: '输入你的校验信息',
              icon: const Icon(Icons.lock),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildUserLicenseCheckbox() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Checkbox(
          value: isLicenseAccepted,
          onChanged: (_isLicenseAccepted) {
            setState(() => isLicenseAccepted = _isLicenseAccepted!);
          },
        ),
        Text.rich(
          TextSpan(
            children: [
              const TextSpan(text: '我已阅读并同意'),
              TextSpan(text: '《上应小风筝用户协议》', style: const TextStyle(color: Colors.blue), recognizer: _recognizer),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildLoginButton() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          height: 40,
          child: ElevatedButton(
            onPressed: disableLoginButton ? null : onLogin,
            child: const Text('进入活动页面'),
          ),
        ),
        TextButton(
          child: const Text(
            '遇到问题?',
            style: TextStyle(color: Colors.grey),
          ),
          onPressed: () => launchInBrowser('https://support.qq.com/products/377648'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Container(
              width: screenWidth,
              padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title field.
                  buildTitleLine(),
                  const Padding(padding: EdgeInsets.only(top: 40.0)),
                  // Form field: username and password.
                  buildLoginForm(),
                  const SizedBox(height: 10),
                  // User license check box.
                  buildUserLicenseCheckbox(),
                  const SizedBox(height: 25),
                  // Login button.
                  buildLoginButton(),
                  const SizedBox(height: 10),
                  showPs
                      ? const Text('PS: 由于假期学校信息化技术中心无值班，在非值班期间学校为保护学校服务器的安全，会将设备关闭，故通过OA密码可能造成登录失败，建议使用身份证号登录')
                      : Container(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
