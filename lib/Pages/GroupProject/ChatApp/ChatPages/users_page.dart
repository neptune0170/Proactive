//Packages
import 'package:flutter/material.dart';
import 'package:notesapp/Pages/GroupProject/ChatApp/ChatProvider/authentication_provider.dart';
import 'package:notesapp/Pages/GroupProject/ChatApp/ChatProvider/users_page_provider.dart';
import 'package:notesapp/Pages/GroupProject/ChatApp/chatModel/chat_user.dart';
import 'package:notesapp/Pages/GroupProject/ChatApp/chatWidgets/custom_list_view_tiles.dart';
import 'package:notesapp/Pages/GroupProject/ChatApp/chatWidgets/top_bar.dart';
import 'package:notesapp/widgets/custom_input_form_field.dart';
import 'package:notesapp/widgets/rounded_button.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';

class UsersPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _UsersPageState();
  }
}

class _UsersPageState extends State<UsersPage> {
  late double _deviceHeight;
  late double _deviceWidth;

  late AuthenticationProvider _auth;
  late UsersPageProvider _pageProvider;

  final TextEditingController _searchFieldTextEditingController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    _auth = Provider.of<AuthenticationProvider>(context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UsersPageProvider>(
          create: (_) => UsersPageProvider(_auth),
        ),
      ],
      child: _buildUI(),
    );
  }

  Widget _buildUI() {
    return Builder(
      builder: (BuildContext _context) {
        _pageProvider = _context.watch<UsersPageProvider>();
        return Container(
          padding: EdgeInsets.symmetric(
              horizontal: _deviceWidth * 0.01, vertical: _deviceHeight * 0.01),
          height: _deviceHeight * 0.98,
          width: _deviceWidth * 0.97,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TopBar(
                'Users',
              ),
              CustomTextField(
                onEditingComplete: (_value) {
                  _pageProvider.getUsers(name: _value);
                  FocusScope.of(context).unfocus();
                },
                hintText: "Search...",
                obscureText: false,
                controller: _searchFieldTextEditingController,
                icon: Icons.search,
              ),
              _usersList(),
              _createChatButton(),
            ],
          ),
        );
      },
    );
  }

  String imgurl =
      "data:image/png;base64,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";

  Widget _usersList() {
    List<ChatUser>? _users = _pageProvider.users;
    return Expanded(child: () {
      if (_users != null) {
        if (_users.length != 0) {
          return ListView.builder(
            itemCount: _users.length,
            itemBuilder: (BuildContext _context, int _index) {
              return CustomListViewTile(
                height: _deviceHeight * 0.10,
                title: _users[_index].name,
                subtitle: "Last Active: ${_users[_index].lastDayActive()}",
                imagePath: imgurl,
                isActive: _users[_index].wasRecentlyActive(),
                isSelected: _pageProvider.selectedUsers.contains(
                  _users[_index],
                ),
                onTap: () {
                  _pageProvider.updateSelectedUsers(
                    _users[_index],
                  );
                },
              );
            },
          );
        } else {
          return Center(
            child: Text(
              "No Users Found.",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          );
        }
      } else {
        return Center(
          child: CircularProgressIndicator(
            color: Colors.white,
          ),
        );
      }
    }());
  }

  Widget _createChatButton() {
    return Visibility(
      visible: _pageProvider.selectedUsers.isNotEmpty,
      child: RoundedButton(
        name: _pageProvider.selectedUsers.length == 1
            ? "Chat With ${_pageProvider.selectedUsers.first.name}"
            : "Create Group Chat",
        height: _deviceHeight * 0.08,
        width: _deviceWidth * 0.80,
        onPressed: () {
          _pageProvider.createChat();
        },
      ),
    );
  }
}