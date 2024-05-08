import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testapp/controller/notification_controller.dart';
import 'package:testapp/provider/user_provider.dart';
import 'package:testapp/screens/auth_screens/login_body.dart';
import 'package:testapp/screens/widgets/home_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final user = FirebaseAuth.instance.currentUser;
  NotificationController notificationController = NotificationController();
  @override
  void initState() {
    notificationController.requestNotificationPermission();

    notificationController.getDeviceToken().then((value) {
      print("Get token");
      print(value);
    });
    Future.delayed(const Duration(seconds: 2), () {
      if (user == null) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginBody(),
            ));
      } else {
        Provider.of<UserProvider>(context, listen: false).getUserDetails();

        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const HomePage(),
            ));
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(
        child: SizedBox(
          height: height * 0.3,
          width: width * 0.3,
          child: const Image(image: AssetImage("assets/images/icon.png")),
        ),
      ),
    );
  }
}
