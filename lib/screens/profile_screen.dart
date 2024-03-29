import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testapp/provider/user_provider.dart';
import 'package:testapp/screens/edit_profile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 60,
                child: Text(
                  provider.userName[0],
                  style: const TextStyle(
                      fontSize: 50, fontWeight: FontWeight.w500),
                ),
              ),
              Text(
                provider.userName,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              Text(
                provider.userEmail,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfileEditScreen(),
                        ));
                  },
                  child: const Text("Edit Profile"))
            ],
          ),
        ),
      ),
    );
  }
}
