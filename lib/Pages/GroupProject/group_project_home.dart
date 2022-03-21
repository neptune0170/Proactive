import 'dart:html';

import 'package:flutter/material.dart';
import 'package:notesapp/Pages/GroupProject/ChatApp/ChatPages/chat_home.dart';
import 'package:notesapp/Pages/GroupProject/ChatApp/ChatProvider/authentication_provider.dart';
import 'package:provider/provider.dart';

class GroupProject extends StatefulWidget {
  const GroupProject({Key? key}) : super(key: key);

  @override
  _GroupProjectState createState() => _GroupProjectState();
}

class _GroupProjectState extends State<GroupProject> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Center(child: Text('Group Project')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          // color: Colors.red,
          child: Row(
            children: [
              Expanded(
                child: const FilesWidget(),
                flex: 6,
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: const ChatWidget(),
                flex: 3,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class FilesWidget extends StatefulWidget {
  const FilesWidget({Key? key}) : super(key: key);

  @override
  _FilesWidgetState createState() => _FilesWidgetState();
}

class _FilesWidgetState extends State<FilesWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue[900],
      child: Center(
          child: Text(
        'Comming Soon...',
        style: TextStyle(
            color: Colors.white60, fontWeight: FontWeight.bold, fontSize: 74),
      )),
    );
  }
}

class ChatWidget extends StatefulWidget {
  const ChatWidget({Key? key}) : super(key: key);

  @override
  _ChatWidgetState createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthenticationProvider>(
          create: (BuildContext _context) {
            return AuthenticationProvider();
          },
        )
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              fontFamily: 'Montserrat',
              backgroundColor: Color.fromRGBO(36, 35, 49, 1.0),
              scaffoldBackgroundColor: Color.fromRGBO(36, 35, 49, 1.0),
              bottomNavigationBarTheme: BottomNavigationBarThemeData(
                backgroundColor: Color.fromRGBO(30, 29, 37, 1.0),
              )),
          home: ChatHome()),
    );
  }
}
