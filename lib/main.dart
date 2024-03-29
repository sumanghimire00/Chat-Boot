import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testapp/provider/theme_provider.dart';
import 'package:testapp/provider/user_provider.dart';
import 'package:testapp/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyAuONG9uguWkuGi0C69D8oRMvGa0QKp6PU",
      appId: "1:413711599036:android:1ce28396f8ef90588797b9",
      messagingSenderId: "413711599036",
      projectId: "graphite-post-409601",
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: Builder(
        builder: (BuildContext context) {
          final provider = Provider.of<ThemeProvider>(context);
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            themeMode: provider.themeMode,
            theme: ThemeData(
              brightness: Brightness.light,
              appBarTheme: const AppBarTheme(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white),
            ),
            darkTheme: ThemeData(
                brightness: Brightness.dark,
                appBarTheme: const AppBarTheme(
                  backgroundColor: Colors.grey,
                  foregroundColor: Colors.white,
                )),
            title: "Flutter Login App",
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
