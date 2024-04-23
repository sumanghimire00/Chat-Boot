// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:testapp/common/custom_textform_field.dart';
import 'package:testapp/controller/signup_controller.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _countryNameController = TextEditingController();

  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SIGNUP SCREEN"),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: FormBuilder(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 100,
                  height: 100,
                  child: Image.asset("assets/images/icon.png"),
                ),
                const SizedBox(
                  height: 30,
                ),
                CustomTextField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Name Field cannot be empty";
                      } else {
                        return null;
                      }
                    },
                    controller: _nameController,
                    type: TextfieldType.Text,
                    hintText: "Name",
                    prefixIcon: Icons.person),
                CustomTextField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Email Field cannot be empty";
                      } else {
                        return null;
                      }
                    },
                    controller: _emailController,
                    type: TextfieldType.Email,
                    hintText: "Email",
                    prefixIcon: Icons.mail),
                CustomTextField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Password Field Cannot be Empty";
                    } else if (value.length < 6) {
                      return "password cannot be less than 6";
                    }
                    return null;
                  },
                  controller: _passwordController,
                  hintText: "Password",
                  prefixIcon: Icons.lock,
                  type: TextfieldType.Password,
                ),
                CustomTextField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Country Field cannot be empty";
                      } else {
                        return null;
                      }
                    },
                    controller: _countryNameController,
                    type: TextfieldType.Text,
                    hintText: "Country",
                    prefixIcon: Icons.home),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(0, 60),
                          backgroundColor: Colors.indigo,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(30),
                            ),
                          ),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.saveAndValidate()) {
                            setState(() {
                              isLoading = true;
                            });
                            try {
                              await SignUpController().signUp(
                                context: context,
                                email: _emailController.text.toString(),
                                password: _passwordController.text.toString(),
                                country: _countryNameController.text.toString(),
                                name: _nameController.text.toString(),
                              );
                            } finally {
                              setState(() {
                                isLoading = false;
                              });
                            }
                          }
                        },
                        child: isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                "SIGNUP",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
