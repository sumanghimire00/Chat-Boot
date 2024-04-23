import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testapp/common/custom_textform_field.dart';
import 'package:testapp/controller/login_controller.dart';
import 'package:testapp/provider/theme_provider.dart';
import 'package:testapp/screens/forgot_screen.dart';
import 'package:testapp/screens/signup_page.dart';

class LoginBody extends StatefulWidget {
  const LoginBody({super.key});

  @override
  State<LoginBody> createState() => _LoginBodyState();
}

class _LoginBodyState extends State<LoginBody> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        actions: [
          Consumer<ThemeProvider>(
            builder: (context, value, child) => IconButton(
              onPressed: () {
                SharedPreferences.getInstance();

                if (provider.themeMode == ThemeMode.light) {
                  provider.setTheme(ThemeMode.dark);
                } else if (provider.themeMode == ThemeMode.dark) {
                  provider.setTheme(ThemeMode.light);
                } else {
                  provider.setTheme(ThemeMode.system);
                }
              },
              icon: provider.themeMode == ThemeMode.light
                  ? const Icon(Icons.dark_mode)
                  : const Icon(Icons.light_mode),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 10,
          ),
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Text(
                  "Welcome To Chatboot Login",
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: 150,
                  height: 150,
                  child: Image.asset("assets/images/icon.png"),
                ),
                const SizedBox(
                  height: 50,
                ),
                FormBuilder(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Email id Form Field
                      CustomTextField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Email cannot be empty";
                          } else {
                            return null;
                          }
                        },
                        controller: _emailController,
                        hintText: "Email",
                        prefixIcon: Icons.person,
                      ),

                      // Password form Field
                      CustomTextField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Password cannot be empty";
                          } else if (value.length < 6) {
                            return "Password cannot be less than 6";
                          } else {
                            return null;
                          }
                        },
                        controller: _passwordController,
                        hintText: "Password",
                        prefixIcon: Icons.lock,
                        type: TextfieldType.Password,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const ForgotScreen(),
                                  ));
                            },
                            child: const Text(
                              "Forgot Password",
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.indigo,
                                foregroundColor: Colors.white,
                                minimumSize: const Size(0, 60),
                              ),
                              onPressed: () async {
                                if (_formKey.currentState!.saveAndValidate()) {
                                  isLoading = true;
                                  setState(() {});
                                  try {
                                    await LoginController().login(
                                        context: context,
                                        email: _emailController.text.toString(),
                                        password: _passwordController.text
                                            .toString());
                                  } finally {
                                    isLoading = false;
                                    setState(() {});
                                  }
                                }
                              },
                              child: isLoading
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 4,
                                    )
                                  : const Text(
                                      "LOGIN",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Don't have login email/passwor?"),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SignUpPage(),
                                ),
                              );
                            },
                            child: const Text(
                              "SIGNUP",
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
