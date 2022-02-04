import 'package:flutter/material.dart';
import 'package:notesapp/Pages/GroupProject/ChatApp/ChatPages/chats_page.dart';
import 'package:notesapp/Pages/GroupProject/ChatApp/ChatPages/users_page.dart';

class ChatHome extends StatefulWidget {
  const ChatHome({Key? key}) : super(key: key);

  @override
  _ChatHomeState createState() => _ChatHomeState();
}

class _ChatHomeState extends State<ChatHome> {
  int _currentPage = 0;
  final List<Widget> _pages = [ChatsPage(), UsersPage()];

  @override
  Widget build(BuildContext context) {
    return _buildUI();
  }

  Widget _buildUI() {
    return Scaffold(
      body: _pages[_currentPage],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentPage,
        onTap: (_index) {
          setState(() {
            _currentPage = _index;
          });
        },
        items: [
          BottomNavigationBarItem(
              label: "Chats", icon: Icon(Icons.chat_bubble_sharp)),
          BottomNavigationBarItem(
            label: "Users",
            icon: Icon(Icons.supervised_user_circle_sharp),
          )
        ],
      ),
    );
  }
}
