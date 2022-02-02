import 'package:flutter/material.dart';

class AuthLoading extends StatelessWidget {
  const AuthLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: Column(
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
}
