// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:testapp/screens/splash_screen.dart';

class SignUpController {
  Future<void> signUp(
      {required BuildContext context,
      required String name,
      required String country,
      required String email,
      required String password}) async {
    // ignore: unused_local_variable
    UserCredential? userCredential;
    if (email == "" && password == "") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Field Cannot be empty"),
        ),
      );
    } else {
      try {
        userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        var userId = FirebaseAuth.instance.currentUser!.uid;
        var db = FirebaseFirestore.instance
            .collection("users")
            .doc(userId.toString());

        Map<String, dynamic> data = {
          "name": name,
          "email": email,
          "country": country,
          "id": userId.toString(),
        };
        await db.set(data);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Email and Password created Sucsessfully"),
          ),
        );
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const SplashScreen(),
          ),
          (route) {
            return false;
          },
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text(e.toString()),
          ),
        );
      }
    }
  }
}
