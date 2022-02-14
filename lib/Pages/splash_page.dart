import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notesapp/Pages/GroupProject/ChatApp/Chatservices/cloud_storage.dart';
import 'package:notesapp/Pages/GroupProject/ChatApp/Chatservices/media_service.dart';
import 'package:notesapp/Pages/GroupProject/ChatApp/Chatservices/navigation_service.dart';
import 'package:notesapp/utils/user_simple_preferences.dart';
import 'package:get_it/get_it.dart';
import 'GroupProject/ChatApp/Chatservices/database_service.dart';

class SplashPage extends StatefulWidget {
  final VoidCallback onInitializationComplete;
  const SplashPage({required Key key, required this.onInitializationComplete})
      : super(key: key);
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 0)).then(
      (_) {
        _setup().then(
          (_) => widget.onInitializationComplete(),
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Notes App',
      theme: ThemeData(
        backgroundColor: Colors.black,
        scaffoldBackgroundColor: Colors.black,
      ),
      home: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.contain,
                    image: AssetImage('assets/Images/NotesApp.png'),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 100,
            ),
            Center(
                child: Text(
              '',
              style: TextStyle(
                fontFamily: 'Montserrat',
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 21,
              ),
            )),
            SizedBox(
              height: 25,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _setup() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
        options: FirebaseOptions(
      apiKey: "AIzaSyAIyZxxowQ5ZoYwN0JWQq-8IhPeuQGtQ7k",
      appId: "1:397151227980:web:bb1f1bce06099b7364e4e9",
      storageBucket: "notesapp-6268f.appspot.com",
      messagingSenderId: "397151227980",
      projectId: "notesapp-6268f",
    ));
    await UserSimplePreferences.init();
    _registerServices();
  }

  void _registerServices() {
    GetIt.instance.registerSingleton<NavigationService>(
      NavigationService(),
    );
    GetIt.instance.registerSingleton<MediaService>(
      MediaService(),
    );
    GetIt.instance.registerSingleton<CloudStorageService>(
      CloudStorageService(),
    );
    GetIt.instance.registerSingleton<DatabaseService>(
      DatabaseService(),
    );
  }
}
