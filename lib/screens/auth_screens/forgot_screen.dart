import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:testapp/common/common_function.dart';
import 'package:testapp/common/custom_textform_field.dart';
import 'package:testapp/screens/auth_screens/login_body.dart';

class ForgotScreen extends StatefulWidget {
  const ForgotScreen({super.key});

  @override
  State<ForgotScreen> createState() => _ForgotScreenState();
}

class _ForgotScreenState extends State<ForgotScreen> {
  final TextEditingController emailController = TextEditingController();
  forgotEmail(String email) async {
    if (email == "") {
      return ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Required email to reset Password"),
        ),
      );
    } else {
      FirebaseAuth.instance
          .sendPasswordResetEmail(email: email)
          .then(
            (value) => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Password reset Successfully"),
              ),
            ),
          )
          .then(
            (value) => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginBody(),
              ),
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "Forgot Password",
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.03,
          vertical: height * 0.02,
        ),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          CustomTextField(
            controller: emailController,
            hintText: "Email",
            prefixIcon: Icons.email,
          ),
          CommonFunction.blanckSpace(height * 0.02, width),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              forgotEmail(emailController.text.toString());
            },
            child: const Text("Forgot"),
          )
        ]),
      ),
    );
  }
}
