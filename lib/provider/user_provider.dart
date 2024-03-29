import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  String userName = "user name";
  String userEmail = "user@gmail.com";
  String userId = "1";

  var db = FirebaseFirestore.instance;

  void getUserDetails() {
    var authUser = FirebaseAuth.instance.currentUser;
    db.collection("users").doc(authUser!.uid).get().then((snapshotData) {
      userName = snapshotData.data()?["name"] ?? "";
      userEmail = snapshotData.data()?["email"] ?? "";
      userId = snapshotData.data()?["id"] ?? "";
      notifyListeners();
    });
  }
}
