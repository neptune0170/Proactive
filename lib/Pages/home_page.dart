import 'dart:async';
import 'dart:html';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notesapp/Pages/File/file_cloud_storage.dart';
import 'package:notesapp/Pages/Images/services/cloud_storage.dart';

import 'package:notesapp/Pages/Notes/addnotes.dart';
import 'package:notesapp/Pages/Notes/completed_note.dart';
import 'package:notesapp/Pages/Notes/viewnote.dart';
import 'package:notesapp/Pages/Streak/add_streak_page.dart';
import 'package:notesapp/Pages/login_page.dart';
import 'package:notesapp/Pages/sideMenu/side_menu.dart';
import 'package:notesapp/Provider/timeleft.info.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

@override
class _HomePageState extends State<HomePage> {
  CollectionReference ref = FirebaseFirestore.instance.collection('users');
  CollectionReference notesref = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('notes');
  CollectionReference imageref = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('Images');
  CollectionReference fileref = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('Files');
  CollectionReference streaksref = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('streaks');

  final User? user = FirebaseAuth.instance.currentUser!;
  @override
  List<Color?> myColors = [
    Color(0xff006fc9),
    Colors.deepPurple[200],
    Color(0xff2ea8ff),
    Colors.purple[200],
    Color(0xff6a8fab),
    Color(0xff916736),
    Color(0xff8400d6),
    Color(0xffa19664),
    Color(0xff577550),
    Color(0xff923c96),
    Color(0xff484666),
  ];

  @override
  void initState() {
    Timer.periodic(Duration(seconds: 1), (t) {
      var timerInfo = Provider.of<TimerInfo>(context, listen: false);
      timerInfo.updateRemainingTime();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          modalBottomSheetMenu(context);
        },
      ),
      appBar: AppBar(
        title: Consumer<TimerInfo>(
          builder: (context, data, child) {
            return Center(child: Text(data.getRemainingTime() + ' Left'));
          },
        ),
        backgroundColor: Colors.black,
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                  onTap: () {
                    showAlertDialog(context);
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.blue[900],
                    radius: 20,
                    child: Icon(
                      Icons.logout_rounded,
                      color: Colors.white,
                    ),
                  ))),
        ],
      ),
      body: Row(
        children: [
          if (MediaQuery.of(context).size.width > 800) SideMenu(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        fileTypeWidget(
                          text1: 'Notes',
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .push(
                                MaterialPageRoute(
                                  builder: (context) => CompletedNotes(),
                                ),
                              )
                                  .then((value) {
                                setState(() {});
                              });
                            },
                            child: Text(
                              'Completed Notes',
                              style: TextStyle(color: Colors.blue),
                            ))
                      ],
                    ),
                  ),
                  //Notes Widget
                  notesWidget(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: fileTypeWidget(
                      text1: 'Streaks',
                    ),
                  ),
                  StreaksWidget(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: fileTypeWidget(
                      text1: 'Images',
                    ),
                  ),
                  ImageWidget(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: fileTypeWidget(
                      text1: 'PDF/FILES',
                    ),
                  ),
                  PdfFilesWidget(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

//Functions and widgets  -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
  void modalBottomSheetMenu(context) {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return new Container(
            height: 350.0,
            color: Colors.transparent,
            child: new Container(
                decoration: new BoxDecoration(
                    color: Colors.white,
                    borderRadius: new BorderRadius.only(
                        topLeft: const Radius.circular(10.0),
                        topRight: const Radius.circular(10.0))),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.padding_rounded,
                            color: Colors.black,
                            size: 50,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AddNote()),
                                ).then((value) {
                                  setState(() {});
                                });
                              },
                              child: Text('Add Notes')),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Image(
                            image: AssetImage('assets/Images/addImage.png'),
                            height: 50,
                            width: 50,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          ElevatedButton(
                              onPressed: () async {
                                saveImageInFirebase();
                                setState(() {});
                                Navigator.of(context).pop();
                                setState(() {});
                              },
                              child: Text('Add Images')),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Image(
                            image: AssetImage('assets/Images/addFile.png'),
                            height: 50,
                            width: 50,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          ElevatedButton(
                              onPressed: () async {
                                saveFilesInFirebase();
                                setState(() {});
                                Navigator.of(context).pop();
                                setState(() {});
                              },
                              child: Text('Add PDF/Files')),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Image(
                            image: AssetImage('assets/Images/flame.png'),
                            height: 50,
                            width: 50,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => AddStreak()))
                                    .then((_) {
                                  setState(() {});
                                });
                              },
                              child: Text('Create Task Streak')),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                )),
          );
        });
  }

  void saveFilesInFirebase() async {
    try {
      FilePickerResult? result =
          await FilePicker.platform.pickFiles(type: FileType.any);
      if (result != null) {
        Uint8List? file = result.files.first.bytes;
        String fileName = result.files.first.name;
        String fileExt = result.files.first.extension!;
        // print(file);
        String? _downloadURL = await FileCloudStorageService()
            .saveFileToStorage(user!.uid, file!, fileName);
        // String? imagebytefile = file.toString();
        var data = {
          'FileName': fileName,
          'FileExt': fileExt,
          'content': _downloadURL!,
          'created': DateTime.now(),
        };
        fileref.add(data);
        setState(() {});
      }
    } catch (e) {
      print("Error sending image message.");
      print(e);
    }
  }

//Streaks widgets  -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
  Widget StreaksWidget() {
    return Container(
      height: 200,
      width: MediaQuery.of(context).size.width,
      child: FutureBuilder<QuerySnapshot>(
        future: streaksref.get(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.docs.length == 0) {
              return Center(
                child: Text(
                  "You have no saved Files !",
                  style: TextStyle(
                    color: Colors.white70,
                  ),
                ),
              );
            }
            return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  Map data = snapshot.data!.docs[index].data() as Map;

                  return InkWell(
                    onLongPress: () async {
                      await showDialogForImageDelete(
                          context, snapshot.data!.docs[index].reference);
                    },
                    child: Stack(children: [
                      Container(
                        height: 200,
                        width: 200,
                        child: Card(
                          color: Colors.white,
                          child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.date_range,
                                          color: Colors.grey,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Container(
                                          width: 120,
                                          child: Text('${data['title']}',
                                              style: TextStyle(
                                                  fontFamily: 'lato',
                                                  color: Colors.black),
                                              overflow: TextOverflow.ellipsis),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Center(
                                      child: Container(
                                        height: 60,
                                        width: 100,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Image(
                                              image: AssetImage(
                                                  'assets/Images/flame.png'),
                                              height: 40,
                                              width: 40,
                                            ),
                                            Text(
                                              '${data['current_streak']}',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 40),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Center(
                                      child: data['streak_last_update_date'] !=
                                              DateFormat("dd-MM-yyyy")
                                                  .format(DateTime.now())
                                                  .toString()
                                          ? ElevatedButton(
                                              onPressed: () {
                                                snapshot
                                                    .data!.docs[index].reference
                                                    .update({
                                                  'current_streak':
                                                      data['current_streak'] +
                                                          1,
                                                  'streak_last_update_date':
                                                      DateFormat("dd-MM-yyyy")
                                                          .format(
                                                              DateTime.now())
                                                });
                                                setState(() {});
                                              },
                                              child: Text('+1'))
                                          : Text(
                                              'Today\'s Task Completed',
                                              style: TextStyle(
                                                  color: Colors.green),
                                            ),
                                    )
                                  ])),
                        ),
                      ),
                    ]),
                  );
                });
          } else
            return Center(
              child: Text('Loading'),
            );
        },
      ),
    );
  }

//Pdf Files widgets  -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
  Widget PdfFilesWidget() {
    return Container(
      height: 200,
      width: MediaQuery.of(context).size.width,
      child: FutureBuilder<QuerySnapshot>(
        future: fileref.get(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.docs.length == 0) {
              return Center(
                child: Text(
                  "You have no saved Files !",
                  style: TextStyle(
                    color: Colors.white70,
                  ),
                ),
              );
            }
            return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  Map data = snapshot.data!.docs[index].data() as Map;
                  DateTime mydateTime = data['created'].toDate();
                  String formattedTime =
                      DateFormat.yMMMd().add_jm().format(mydateTime);
                  final url = data['content'];
                  return InkWell(
                    onLongPress: () async {
                      await showDialogForImageDelete(
                          context, snapshot.data!.docs[index].reference);
                    },
                    onTap: () async {
                      if (await canLaunch(url)) {
                        launch(url);
                      }
                    },
                    child: Container(
                      height: 200,
                      width: 200,
                      child: Card(
                        child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Stack(
                              children: [
                                Container(
                                  child: Center(
                                      child: Text(
                                    '${data['FileName']}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 21,
                                      fontFamily: 'lato',
                                      color: Colors.blue,
                                    ),
                                  )),
                                ),
                                Positioned(
                                  bottom: 5,
                                  right: 20,
                                  child: Text(
                                    formattedTime,
                                    style: TextStyle(
                                      color: Color(0xff757575),
                                      fontWeight: FontWeight.w700,
                                      fontFamily: "Roboto",
                                      fontStyle: FontStyle.normal,
                                      fontSize: 15.0,
                                    ),
                                  ),
                                ),
                              ],
                            )),
                      ),
                    ),
                  );
                });
          } else
            return Center(
              child: Text('Loading'),
            );
        },
      ),
    );
  }

  void saveImageInFirebase() async {
    try {
      FilePickerResult? result =
          await FilePicker.platform.pickFiles(type: FileType.image);
      if (result != null) {
        Uint8List? file = result.files.first.bytes;
        String fileName = result.files.first.name;
        String fileExt = result.files.first.extension!;
        // print(file);
        String? _downloadURL = await CloudStorageService()
            .saveChatImageToStorage(user!.uid, file!, fileName);
        String? imagebytefile = file.toString();
        var data = {
          'FileName': fileName,
          'FileExt': fileExt,
          'content': _downloadURL!,
          'created': DateTime.now(),
        };
        imageref.add(data);
        setState(() {});
      }
    } catch (e) {
      print("Error sending image message.");
      print(e);
    }
  }

//Image widgets  -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
  Widget ImageWidget() {
    return Container(
      height: 200,
      width: MediaQuery.of(context).size.width,
      child: FutureBuilder<QuerySnapshot>(
        future: imageref.get(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.docs.length == 0) {
              return Center(
                child: Text(
                  "You have no saved Image !",
                  style: TextStyle(
                    color: Colors.white70,
                  ),
                ),
              );
            }
            return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  Map data = snapshot.data!.docs[index].data() as Map;
                  DateTime mydateTime = data['created'].toDate();
                  String formattedTime =
                      DateFormat.yMMMd().add_jm().format(mydateTime);
                  final url = data['content'];
                  return InkWell(
                    onLongPress: () async {
                      await showDialogForImageDelete(
                          context, snapshot.data!.docs[index].reference);
                    },
                    onTap: () async {
                      if (await canLaunch(url)) {
                        launch(url);
                      }
                    },
                    child: Container(
                      height: 200,
                      width: 200,
                      child: Card(
                        child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Stack(
                              children: [
                                Container(
                                  child: Center(
                                      child: Text(
                                    '${data['FileName']}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 21,
                                      fontFamily: 'lato',
                                      color: Colors.blue,
                                    ),
                                  )),
                                ),
                                Positioned(
                                  bottom: 5,
                                  right: 20,
                                  child: Text(
                                    formattedTime,
                                    style: TextStyle(
                                      color: Color(0xff757575),
                                      fontWeight: FontWeight.w700,
                                      fontFamily: "Roboto",
                                      fontStyle: FontStyle.normal,
                                      fontSize: 15.0,
                                    ),
                                  ),
                                ),
                              ],
                            )),
                      ),
                    ),
                  );
                });
          } else
            return Center(
              child: Text('Loading'),
            );
        },
      ),
    );
  }

  //NOTES widgets  -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
  Widget notesWidget() {
    return Container(
      height: 200,
      width: MediaQuery.of(context).size.width,
      child: FutureBuilder<QuerySnapshot>(
        future: notesref
            .where(
              'Completed',
              isEqualTo: false,
            )
            .get(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.docs.length == 0) {
              return Center(
                child: Text(
                  "You have no saved Notes !",
                  style: TextStyle(
                    color: Colors.white70,
                  ),
                ),
              );
            }
            return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  Random random = new Random();
                  Color bg = myColors[random.nextInt(10)]!;
                  Map data = snapshot.data!.docs[index].data() as Map;
                  DateTime mydateTime = data['created'].toDate();
                  String formattedTime =
                      DateFormat.yMMMd().add_jm().format(mydateTime);
                  return InkWell(
                    onLongPress: () {
                      markAsCompleted(
                          context, snapshot.data!.docs[index].reference);
                    },
                    onTap: () {
                      Navigator.of(context)
                          .push(
                        MaterialPageRoute(
                          builder: (context) => ViewNote(
                            data['Priority'],
                            data,
                            formattedTime,
                            snapshot.data!.docs[index].reference,
                          ),
                        ),
                      )
                          .then((value) {
                        setState(() {});
                      });
                    },
                    child: Stack(children: [
                      Container(
                        height: 200,
                        width: 200,
                        child: Card(
                          color: bg,
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${data['title']}".toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontFamily: "lato",
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  "${data['description']}",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 4,
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    fontFamily: "lato",
                                    color: Colors.white,
                                  ),
                                ),
                                //
                              ],
                            ),
                          ),
                        ),
                      ),
                      data['Priority'] != null
                          ? Positioned(
                              top: 12,
                              right: 12,
                              child: Container(
                                height: 12,
                                width: 12,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: data['Priority'] == 2
                                        ? Colors.red
                                        : (data['Priority'] == 1
                                            ? Colors.yellow[700]
                                            : Colors.green)),
                              ))
                          : Container(),
                      Positioned(
                        bottom: 5,
                        right: 30,
                        child: Container(
                          child: Text(
                            formattedTime,
                            style: TextStyle(
                              fontSize: 14.0,
                              fontFamily: "lato",
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    ]),
                  );
                });
          } else
            return Center(
              child: Text('Loading'),
            );
        },
      ),
    );
  }

  markAsCompleted(BuildContext context, DocumentReference ref) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text("Yes"),
      onPressed: () {
        var userData = {'Completed': true};
        ref.update(userData);
        Navigator.of(context).pop();
        setState(() {});
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("AlertDialog"),
      content: Text("Do you want Mark this task as completed"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showDialogForImageDelete(BuildContext context, DocumentReference ref) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text("Yes"),
      onPressed: () {
        ref.delete();
        Navigator.of(context).pop();
        setState(() {});
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("AlertDialog"),
      content: Text("Do you want delete this File"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

class fileTypeWidget extends StatelessWidget {
  final String? text1;
  fileTypeWidget({this.text1});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text1!,
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 35,
              fontFamily: 'lato'),
        ),
      ),
    );
  }
}

showAlertDialog(BuildContext context) {
  // set up the buttons
  Widget cancelButton = TextButton(
    child: Text("Cancel"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );
  Widget continueButton = TextButton(
    child: Text("Yes"),
    onPressed: () {
      Navigator.of(context).pop();
      FirebaseAuth.instance.signOut();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ),
      );
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("AlertDialog"),
    content: Text("Do you want to signout?"),
    actions: [
      cancelButton,
      continueButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
