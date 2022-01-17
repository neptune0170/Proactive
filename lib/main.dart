import 'dart:io' show Platform;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notesapp/Pages/home_page.dart';
import 'package:notesapp/Pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notesapp/utils/user_simple_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // print(osVersion);
  await Firebase.initializeApp(
      options: FirebaseOptions(
    apiKey: "AIzaSyAIyZxxowQ5ZoYwN0JWQq-8IhPeuQGtQ7k",
    appId: "1:397151227980:web:bb1f1bce06099b7364e4e9",
    storageBucket: "notesapp-6268f.appspot.com",
    messagingSenderId: "397151227980",
    projectId: "notesapp-6268f",
  ));

  //firebase(mobile)
  // await Firebase.initializeApp();

  await UserSimplePreferences.init();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  final User? user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Notes App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
          primaryColor: Colors.white,
          accentColor: Colors.white,
          scaffoldBackgroundColor: Color(0xff070706),
        ),
        home: user == null ? LoginPage() : HomePage());
  }
}
