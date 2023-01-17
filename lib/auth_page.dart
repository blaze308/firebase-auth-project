import 'package:flutter/material.dart';
import 'package:flutter_firebase/pages/login_page.dart';
import 'package:flutter_firebase/pages/signup_page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLogin = true;
  @override
  Widget build(BuildContext context) => isLogin
      ? Login(onClickedSignUp: toggle)
      : Signup(onClickedSignUp: toggle);

  void toggle() => setState(() => isLogin = !isLogin);
}
