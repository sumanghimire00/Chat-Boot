import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testapp/provider/theme_provider.dart';
import 'package:testapp/provider/user_provider.dart';
import 'package:testapp/screens/chatroom_screen.dart';
import 'package:testapp/screens/widgets/profile_screen.dart';
import 'package:testapp/screens/widgets/splash_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var user = FirebaseAuth.instance.currentUser;
  var db = FirebaseFirestore.instance;
  var scaffoldKey = GlobalKey<ScaffoldState>();

  List<Map<String, dynamic>> chatList = [];
  List<String> chatId = [];
  void getChatrooms() {
    db.collection("chatrooms").get().then((snapshotData) {
      for (var singleChatroomData in snapshotData.docs) {
        chatList.add(singleChatroomData.data());
        chatId.add(singleChatroomData.id.toString());
      }
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    getChatrooms();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ThemeProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
        key: scaffoldKey,
        drawer: Drawer(
          child: Column(
            children: [
              Container(
                  height: 150,
                  padding: const EdgeInsets.only(bottom: 10),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ListTile(
                        title: Text(
                          userProvider.userName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                        subtitle: Text(
                          userProvider.userEmail,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ProfileScreen(),
                            ),
                          );
                        },
                        leading: CircleAvatar(
                          radius: 30,
                          child: Text(userProvider.userName[0]),
                        ),
                      )
                    ],
                  )),
              Consumer(
                builder: (context, value, child) => ListTile(
                  onTap: () {
                    SharedPreferences.getInstance();

                    if (provider.themeMode == ThemeMode.light) {
                      provider.setTheme(ThemeMode.dark);
                    } else if (provider.themeMode == ThemeMode.dark) {
                      provider.setTheme(ThemeMode.light);
                    } else {
                      provider.setTheme(ThemeMode.system);
                    }
                  },
                  trailing: provider.themeMode == ThemeMode.light
                      ? const Icon(Icons.dark_mode)
                      : const Icon(Icons.light_mode),
                  leading: const Text(
                    "Theme Change",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              ListTile(
                onTap: () async {
                  await FirebaseAuth.instance.signOut().then(
                        (value) => Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SplashScreen(),
                          ),
                          (route) {
                            return false;
                          },
                        ),
                      );
                },
                leading: const Text(
                  "Logout",
                  style: TextStyle(fontSize: 18),
                ),
                trailing: const Icon(Icons.logout),
              ),
            ],
          ),
        ),
        appBar: AppBar(
          centerTitle: true,
          leading: InkWell(
            onTap: () {
              scaffoldKey.currentState!.openDrawer();
            },
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: CircleAvatar(
                child: Text(userProvider.userName[0]),
              ),
            ),
          ),
          title: const Text("Home Page"),
        ),
        body: ListView.builder(
          itemCount: chatList.length,
          itemBuilder: (BuildContext context, int index) {
            String chatroomName = chatList[index]["chatroom_name"] ?? "";
            return ListTile(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ChatRommScreen(
                    chatRoomID: chatId[index],
                    chatRoomName: chatroomName,
                  ),
                ));
              },
              title: Text(chatroomName),
              subtitle: Text(chatList[index]["desc"] ?? ""),
              leading: CircleAvatar(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                child: Text(chatroomName[0]),
              ),
            );
          },
        ));
  }
}
