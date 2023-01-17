import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/utils.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  Color green = Colors.green;

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 8,
        backgroundColor: Colors.transparent,
        title: const Text("Reset Password"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Reset Password",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, color: green),
                ),
                const SizedBox(height: 20),
                TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (email) =>
                        email != null && !EmailValidator.validate(email)
                            ? "Enter valid email"
                            : null,
                    controller: emailController,
                    cursorColor: green,
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: "email",
                      labelStyle: TextStyle(color: green),
                    )),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                    onPressed: resetPass,
                    icon: const Icon(Icons.email_outlined),
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        backgroundColor: green),
                    label: const Text(
                      "Reset Password",
                      style: TextStyle(color: Colors.white),
                    )),
              ],
            )),
      ),
    );
  }

  Future resetPass() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return const Center(child: CircularProgressIndicator(value: 2));
        });

    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());
      Utils.showSnackBar("Password Reset Email Sent");
    } on FirebaseAuthException catch (e) {
      Utils.showSnackBar(e.message);
    }

    if (!mounted) return;
    Navigator.of(context, rootNavigator: true).pop();
  }
}
