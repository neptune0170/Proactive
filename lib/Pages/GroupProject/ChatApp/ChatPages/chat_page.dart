import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notesapp/Pages/GroupProject/ChatApp/ChatProvider/authentication_provider.dart';
import 'package:notesapp/Pages/GroupProject/ChatApp/ChatProvider/chat_page_provider.dart';
import 'package:notesapp/Pages/GroupProject/ChatApp/chatModel/chat.dart';
import 'package:notesapp/Pages/GroupProject/ChatApp/chatModel/chat_message.dart';
import 'package:notesapp/Pages/GroupProject/ChatApp/chatWidgets/custom_list_view_tiles.dart';
import 'package:notesapp/Pages/GroupProject/ChatApp/chatWidgets/top_bar.dart';
import 'package:notesapp/widgets/custom_input_form_field.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  final Chat chat;
  ChatPage({required this.chat});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late double _deviceHeight;
  late double _deviceWidth;
  late AuthenticationProvider _auth;
  late ChatPageProvider _pageProvider;
  late GlobalKey<FormState> _messageFormState;
  late ScrollController _messagesListViewController;
  @override
  void initState() {
    super.initState();
    _messageFormState = GlobalKey<FormState>();
    _messagesListViewController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    _auth = Provider.of<AuthenticationProvider>(context);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ChatPageProvider>(
          create: (_) => ChatPageProvider(
              this.widget.chat.uid, _auth, _messagesListViewController),
        ),
      ],
      child: _buildUI(context),
    );
  }

  Widget _buildUI(BuildContext context) {
    return Builder(
      builder: (BuildContext _context) {
        _pageProvider = _context.watch<ChatPageProvider>();
        return Scaffold(
          body: Container(
            // color: Colors.blue[100],
            padding: EdgeInsets.all(5),
            height: _deviceHeight,
            width: _deviceWidth,
            child: Column(
              children: [
                TopBar(
                  this.widget.chat.title(),
                  fontSize: 10,
                  primaryAction: IconButton(
                    iconSize: 20,
                    icon: Icon(
                      Icons.delete,
                      color: Color.fromRGBO(0, 82, 218, 1.0),
                    ),
                    onPressed: () {
                      _pageProvider.deleteChat(context);
                    },
                  ),
                  secondaryAction: IconButton(
                    iconSize: 20,
                    icon: Icon(
                      Icons.arrow_back,
                      color: Color.fromRGBO(0, 82, 218, 1.0),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                SingleChildScrollView(
                  child: Container(
                    // color: Colors.blue[100],
                    padding: EdgeInsets.all(5),
                    height: _deviceHeight * .80,
                    width: _deviceWidth * .7,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // TopBar(
                        //   this.widget.chat.title(),
                        //   fontSize: 10,
                        //   primaryAction: IconButton(
                        //     icon: Icon(
                        //       Icons.delete,
                        //       color: Color.fromRGBO(0, 82, 218, 1.0),
                        //     ),
                        //     onPressed: () {
                        //       _pageProvider.deleteChat();
                        //     },
                        //   ),
                        //   secondaryAction: IconButton(
                        //     icon: Icon(
                        //       Icons.arrow_back,
                        //       color: Color.fromRGBO(0, 82, 218, 1.0),
                        //     ),
                        //     onPressed: () {
                        //       Navigator.of(context).pop();
                        //     },
                        //   ),
                        // ),
                        _messagesListView(),

                        _sendMessageForm(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _messagesListView() {
    if (_pageProvider.messages != null) {
      if (_pageProvider.messages!.length != 0) {
        return Container(
          // color: Colors.red[100],
          height: _deviceHeight * 0.71,
          child: ListView.builder(
            controller: _messagesListViewController,
            itemCount: _pageProvider.messages!.length,
            itemBuilder: (BuildContext _context, int _index) {
              ChatMessage _message = _pageProvider.messages![_index];
              bool _isOwnMessage = _message.senderID ==
                  FirebaseAuth.instance.currentUser!.uid.toString();
              return Container(
                child: CustomChatListViewTile(
                  deviceHeight: _deviceHeight,
                  width: _deviceWidth * 0.25,
                  message: _message,
                  isOwnMessage: _isOwnMessage,
                  sender: this
                      .widget
                      .chat
                      .members
                      .where((_m) => _m.uid == _message.senderID)
                      .first,
                ),
              );
            },
          ),
        );
      } else {
        return Align(
          alignment: Alignment.center,
          child: Text(
            "Be the first to say Hi!",
            style: TextStyle(color: Colors.white),
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
  }

  Widget _sendMessageForm() {
    return Container(
      height: _deviceHeight * 0.06,
      decoration: BoxDecoration(
        color: Color.fromRGBO(30, 29, 37, 1.0),
        borderRadius: BorderRadius.circular(100),
      ),
      // margin: EdgeInsets.symmetric(
      //   horizontal: _deviceWidth * 0.01,
      //   vertical: _deviceHeight * 0.01,
      // ),
      child: Form(
        key: _messageFormState,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _messageTextField(),
            _sendMessageButton(),
            // _imageMessageButton(),
          ],
        ),
      ),
    );
  }

  Widget _messageTextField() {
    return Container(
      child: SizedBox(
        width: _deviceWidth * 0.22,
        child: CustomTextFormField(
            onSaved: (_value) {
              _pageProvider.message = _value;
            },
            regEx: r"^(?!\s*$).+",
            hintText: "Type a message",
            obscureText: false),
      ),
    );
  }

  Widget _sendMessageButton() {
    double _size = _deviceHeight * 0.05;
    return Container(
      // color: Colors.red,
      height: _size,
      width: _size,
      child: IconButton(
        iconSize: 24,
        padding: EdgeInsets.all(0),
        icon: Icon(
          Icons.send,
          color: Colors.white,
        ),
        onPressed: () {
          if (_messageFormState.currentState!.validate()) {
            _messageFormState.currentState!.save();
            _pageProvider.sendTextMessage();
            _messageFormState.currentState!.reset();
          }
        },
      ),
    );
  }

  // Widget _imageMessageButton() {
  //   double _size = _deviceHeight * 0.04;
  //   return Container(
  //     height: _size,
  //     width: _size,
  //     child: FloatingActionButton(
  //       backgroundColor: Color.fromRGBO(
  //         0,
  //         82,
  //         218,
  //         1.0,
  //       ),
  //       onPressed: () {
  //         _pageProvider.sendImageMessage();
  //       },
  //       child: Icon(Icons.camera_enhance),
  //     ),
  //   );
  // }
}
