import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/pages/reset_password.dart';
import 'package:flutter_firebase/utils.dart';

class Login extends StatefulWidget {
  //added and modified incl key
  // const Login({super.key});
  final VoidCallback onClickedSignUp;

  const Login({
    Key? key,
    required this.onClickedSignUp,
  }) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  Color green = Colors.green;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Form(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const SizedBox(height: 40),
            TextField(
              controller: emailController,
              cursorColor: green,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: "email",
                labelStyle: TextStyle(color: green),
                prefixIcon: Icon(
                  Icons.email,
                  color: green,
                ),
              ),
            ),
            const SizedBox(height: 40),
            TextField(
              controller: passwordController,
              cursorColor: green,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                focusColor: green,
                labelText: "password",
                labelStyle: TextStyle(color: green),
                prefixIcon: Icon(
                  Icons.lock,
                  color: green,
                ),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
                onPressed: signIn,
                icon: const Icon(Icons.arrow_forward),
                style: ElevatedButton.styleFrom(
                    backgroundColor: green,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20))),
                label: const Text(
                  "Sign In",
                  style: TextStyle(color: Colors.white),
                )),
            const SizedBox(height: 15),
            GestureDetector(
                onTap: (() => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const ResetPassword()))),
                child: Text("Forgot Password?",
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: green,
                        fontStyle: FontStyle.italic,
                        fontSize: 15))),
            const SizedBox(height: 10),
            RichText(
                text: TextSpan(
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                    text: "No Account?",
                    children: [
                  const WidgetSpan(child: SizedBox(width: 4)),
                  TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = widget.onClickedSignUp,
                      text: "Sign Up",
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: green,
                      ))
                ])),
          ]),
        ),
      ),
    );
  }

  Future signIn() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return const Center(
              child: CircularProgressIndicator(
            value: 2,
          ));
        });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
    } on FirebaseAuthException catch (e) {
      if (e.credential == null) {
        Utils.showSnackBar("error in credentials");
      }
      // Utils.showSnackBar(e.message);
    }

    if (!mounted) return;
    Navigator.of(context, rootNavigator: true).pop();
  }
}
