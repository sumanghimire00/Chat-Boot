import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:testapp/screens/splash_screen.dart';

class LoginController {
  Future<void> login(
      {required BuildContext context,
      required String email,
      required String password}) async {
    // ignore: unused_local_variable
    UserCredential? userCredential;
    if (email == "" && password == "") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Enter required Fields"),
        ),
      );
    } else {
      try {
        userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        // ignore: use_build_context_synchronously
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const SplashScreen(),
          ),
          (route) {
            return false;
          },
        );
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Login successfully")));
      } on FirebaseAuthException catch (e) {
        e.toString();
      }
    }
  }
}
