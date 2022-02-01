import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notesapp/utils/user_simple_preferences.dart';

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
    Future.delayed(Duration(seconds: 2)).then(
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
              'Setuping your App...',
              style: TextStyle(
                fontFamily: 'Montserrat',
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 21,
              ),
            )),
            SizedBox(
              height: 10,
            ),
            Center(
              child: CircularProgressIndicator(
                color: Colors.cyan,
              ),
            )
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
    // _registerServices();
  }
}
