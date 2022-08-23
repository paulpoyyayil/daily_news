// ignore_for_file: must_be_immutable
import 'package:daily_news/screens/homepage.dart';
import 'package:daily_news/screens/login.dart';
import 'package:daily_news/screens/registration.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

late bool isLoggedin;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await checkUser();
  runApp(MyApp());
}

checkUser() async {
  FirebaseAuth.instance.authStateChanges().listen((User) {
    if (User == null) {
      isLoggedin = false;
    } else {
      isLoggedin = true;
    }
  });
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: isLoggedin ? 'home_screen ' : 'login_screen',
        routes: {
          'login_screen': (context) => Login(),
          'registration_screen': (context) => Registration(),
          'home_screen': (context) => Homepage(),
        },
        onUnknownRoute: ((settings) {
          return MaterialPageRoute(
            builder: (_) => isLoggedin ? Homepage() : Login(),
          );
        }));
  }
}
