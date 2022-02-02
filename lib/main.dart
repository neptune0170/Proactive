import 'dart:io' show Platform;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notesapp/Pages/auth_login_page.dart';
import 'package:notesapp/Pages/home_page.dart';
import 'package:notesapp/Pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notesapp/Pages/splash_page.dart';
import 'package:notesapp/Provider/timeleft.info.dart';
import 'package:notesapp/utils/user_simple_preferences.dart';
import 'package:provider/provider.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();

  // print(osVersion);
  // await Firebase.initializeApp(
  //     options: FirebaseOptions(
  //   apiKey: "AIzaSyAIyZxxowQ5ZoYwN0JWQq-8IhPeuQGtQ7k",
  //   appId: "1:397151227980:web:bb1f1bce06099b7364e4e9",
  //   storageBucket: "notesapp-6268f.appspot.com",
  //   messagingSenderId: "397151227980",
  //   projectId: "notesapp-6268f",
  // ));

  //firebase(mobile)
  // await Firebase.initializeApp();

  // await UserSimplePreferences.init();

  // runApp(MyApp());
  runApp(SplashPage(
      key: UniqueKey(),
      onInitializationComplete: () {
        runApp(ChangeNotifierProvider(
            create: (context) => TimerInfo(), child: MyApp()));
      }));

  // runApp(
  //     ChangeNotifierProvider(create: (context) => TimerInfo(), child: MyApp()));
}

class MyApp extends StatelessWidget {
  final authController = AuthController();
  MyApp({Key? key}) : super(key: key);
  final User? user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        title: 'Notes App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            fontFamily: 'Montserrat',
            primaryColor: Colors.white,
            accentColor: Colors.white,
            scaffoldBackgroundColor: Color(0xff070706),
            inputDecorationTheme: const InputDecorationTheme(
              hintStyle: TextStyle(color: Colors.grey),
            )),
        home: FutureBuilder(
          future: authController.tryAutoLogin(),
          builder: (context, authResult) {
            if (authResult.connectionState == ConnectionState.waiting) {
              return AuthLoading();
            } else {
              if (authResult.data == true) {
                return HomePage();
              } else {
                return LoginPage();
              }
            }
          },
        )

        // user == null ? LoginPage() : HomePage()
        // ChangeNotifierProvider(
        //     create: (context) => TimerInfo(), child: HomePage())
        );

    //  MaterialApp(
    //     title: 'Notes App',
    //     debugShowCheckedModeBanner: false,
    //     theme: ThemeData(
    //         fontFamily: 'Montserrat',
    //         primaryColor: Colors.white,
    //         accentColor: Colors.white,
    //         scaffoldBackgroundColor: Color(0xff070706),
    //         inputDecorationTheme: const InputDecorationTheme(
    //           hintStyle: TextStyle(color: Colors.grey),
    //         )),
    //     home: user == null ? LoginPage() : HomePage()
    //     // ChangeNotifierProvider(
    //     //     create: (context) => TimerInfo(), child: HomePage())
    //     );
  }
}
//https://www.youtube.com/watch?v=oJ5Vrya3wCQ&t=1s
