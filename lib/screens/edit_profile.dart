import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testapp/common/custom_textform_field.dart';
import 'package:testapp/provider/user_provider.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final TextEditingController _nameController = TextEditingController();
  final GlobalKey<FormState> editProfileKey = GlobalKey<FormState>();

  var db = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _nameController.text =
        Provider.of<UserProvider>(context, listen: false).userName;
  }

  void updateProfile() {
    Map<String, dynamic> dataToUpdate = {
      "name": _nameController.text,
    };
    db
        .collection("users")
        .doc(Provider.of<UserProvider>(context, listen: false).userId)
        .update(dataToUpdate);
    Provider.of<UserProvider>(context, listen: false).getUserDetails();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    var editProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                if (editProfileKey.currentState!.validate()) {
                  updateProfile();
                }
              },
              icon: const Icon(Icons.check)),
        ],
        centerTitle: true,
        title: const Text("Edit Profile"),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        margin: const EdgeInsets.all(8),
        child: Form(
          key: editProfileKey,
          child: Column(
            children: [
              CustomTextField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Name cannot be empty";
                    } else if (value.length < 6) {
                      return "Name  cannot be less than 6 letter";
                    } else {
                      return null;
                    }
                  },
                  controller: _nameController,
                  hintText: "Name",
                  prefixIcon: Icons.person)
            ],
          ),
        ),
      ),
    );
  }
}
