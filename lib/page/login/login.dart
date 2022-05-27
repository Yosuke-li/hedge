import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hedge_manager/helper/dio/dio_helper.dart';
import 'package:hedge_manager/helper/global/api.dart';
import 'package:hedge_manager/helper/global/user.dart';
import 'package:hedge_manager/helper/lock.dart';
import 'package:hedge_manager/helper/log_utils.dart';
import 'package:hedge_manager/helper/navigator.dart';
import 'package:hedge_manager/helper/store.dart';
import 'package:hedge_manager/model/user.dart';
import 'package:hedge_manager/model/user_pass.dart';
import 'package:hedge_manager/page/management/home_page/home_page.dart';
import 'package:hedge_manager/widget/api_call_back.dart';
import 'package:hedge_manager/widget/toast_utils.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController passController = TextEditingController();
  bool isSave = false;

  @override
  void initState() {
    super.initState();
    LocateStorage.init().whenComplete(() => _getUser());
  }

  void _getUser() async {
    final String? userJson =
        await LocateStorage.getStringWithExpire('userModel');

    if (userJson != null) {
      UserModel userModel = UserModel.fromJson(jsonDecode(userJson));
      nameController.text = userModel.username!;
      passController.text = userModel.password!;
      isSave = userModel.isSave!;
      setState(() {});
    }
  }

  bool _check() {
    String? errText;
    if (passController.text.isEmpty == true) {
      errText = '密码不能为空';
    }
    if (nameController.text.isEmpty == true) {
      errText = '账户不能为空';
    }

    if (errText != null) {
      ToastUtils.showToast(msg: errText);
      return false;
    }

    return true;
  }

  void login() async {
    Lock lock = Lock();
    final FormState? from = formKey.currentState;
    final UserModel userModel;
    from!.save();
    if (from.validate()) {
      bool c = _check();
      if (c == true) {
        await lock.lock();
        try {
          final res = await loadingCallback(
            () => Request.login(params: {
              'username': nameController.text,
              'password': passController.text,
              'grant_type': 'password',
            }),
          );

          if (res.statusCode == 200 && res.data != null) {
            String cookie = res.headers.map['set-cookie'].toString().substring(
                1, res.headers.map['set-cookie'].toString().length - 1);
            LocateStorage.setStringWithExpire(
                'cookie', cookie, const Duration(days: 1));

            User user = User.fromJson(jsonDecode(res.data));
            Global.user = user;
            userModel = UserModel()
              ..isSave = isSave
              ..password = isSave ? passController.text : null
              ..username = nameController.text;

            LocateStorage.setStringWithExpire(
                'userModel', jsonEncode(userModel), const Duration(days: 1));
            lock.unlock();
            NavigatorUtils.pushWidget(context, HomePage(), replaceCurrent: true);
          }
        } catch (error, stack) {
          lock.unlock();
          ToastUtils.showToast(msg: '$error');
          Log.error(error, stackTrace: stack);
          rethrow;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/img/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 40,
              ),
              Container(
                child: const Text(
                  '欢迎使用！',
                  style: TextStyle(fontSize: 28, color: Colors.white),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                child: const Text(
                  'QME自动点价系统！',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Container(
                width: 500,
                height: 522,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: const Color(0xff797979),
                    width: 1.0,
                    style: BorderStyle.solid,
                  ),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (Global.environment == 'debug') {
                            Global.environment = 'release';
                          } else {
                            Global.environment = 'debug';
                          }
                          ApiUrl.changing();
                          setState(() {});
                        },
                        child: SizedBox(
                          height: 50,
                          child: Text(
                              'logo 预留位置，目前地址${Global.environment == 'debug' ? '本地' : '线上'}'),
                        ),
                      ),
                      const SizedBox(
                        height: 70.0,
                      ),
                      Container(
                        width: 300.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 5, //阴影范围
                              spreadRadius: 0.9, //阴影浓度
                              color: Colors.grey.withOpacity(0.2), //阴影颜色
                            ),
                          ],
                        ),
                        child: TextFormField(
                          controller: nameController,
                          decoration: InputDecoration(
                            labelText: '账户',
                            prefixIcon: const Icon(
                              IconData(0xe8c8, fontFamily: 'AliIcons'),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                color: Colors.black.withOpacity(0.8),
                              ),
                            ),
                          ),
                          onSaved: (String? val) {
                            nameController.text = val!;
                            setState(() {});
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      Container(
                        width: 300.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 5, //阴影范围
                              spreadRadius: 0.9, //阴影浓度
                              color: Colors.grey.withOpacity(0.2), //阴影颜色
                            ),
                          ],
                        ),
                        child: TextFormField(
                          controller: passController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: '密码',
                            prefixIcon: const Icon(Icons.lock),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                color: Colors.black.withOpacity(0.8),
                              ),
                            ),
                          ),
                          onSaved: (String? val) {
                            passController.text = val!;
                            setState(() {});
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: 300,
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            Transform.scale(
                              scale: 0.8,
                              child: Checkbox(
                                value: isSave,
                                onChanged: (bool? value) {
                                  isSave = !isSave;
                                  setState(() {});
                                },
                              ),
                            ),
                            const Text(
                              "记住密码",
                              style: TextStyle(fontSize: 11.0),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 40.0,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          login();
                        },
                        child: const Text(
                          "登录",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
