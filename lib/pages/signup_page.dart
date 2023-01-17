import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/utils.dart';

class Signup extends StatefulWidget {
  //added and modified incl key
  // const Signup({super.key});
  final Function() onClickedSignUp;

  const Signup({
    Key? key,
    required this.onClickedSignUp,
  }) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

final formKey = GlobalKey<FormState>();

class _SignupState extends State<Signup> {
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
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (email) =>
                    email != null && !EmailValidator.validate(email)
                        ? "Enter valid email"
                        : null,
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
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (password) => password != null && password.length < 6
                    ? "password must be at least 6 characters long"
                    : null,
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
                  onPressed: signUp,
                  icon: const Icon(Icons.arrow_upward),
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      backgroundColor: green),
                  label: const Text(
                    "Sign Up",
                    style: TextStyle(color: Colors.white),
                  )),
              const SizedBox(height: 20),
              RichText(
                  text: TextSpan(
                      style: const TextStyle(color: Colors.black, fontSize: 16),
                      text: "Already have an Account?",
                      children: [
                    const WidgetSpan(child: SizedBox(width: 4)),
                    TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = widget.onClickedSignUp,
                        text: "Sign In",
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: green,
                        ))
                  ]))
            ],
          ),
        ),
      ),
    );
  }

  Future signUp() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return const Center(child: CircularProgressIndicator());
        });

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
    } on FirebaseAuthException catch (e) {
      Utils.showSnackBar(e.message);
    }

    if (!mounted) return;
    Navigator.of(context, rootNavigator: true).pop();
  }
}
