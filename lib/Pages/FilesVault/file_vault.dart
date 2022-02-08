import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notesapp/Pages/Images/services/cloud_storage.dart';
import 'package:url_launcher/url_launcher.dart';

class FileValut extends StatefulWidget {
  const FileValut({Key? key}) : super(key: key);

  @override
  _FileValutState createState() => _FileValutState();
}

CollectionReference imageref = FirebaseFirestore.instance
    .collection('users')
    .doc(FirebaseAuth.instance.currentUser!.uid)
    .collection('Images');
CollectionReference fileref = FirebaseFirestore.instance
    .collection('users')
    .doc(FirebaseAuth.instance.currentUser!.uid)
    .collection('Files');
Uint8List? file;
String? fileName = '';
String? fileExt = '';

class _FileValutState extends State<FileValut> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Center(child: Text('File Vault')),
      ),
      body: Container(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 8),
          child: Column(
            children: [
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
              SizedBox(
                height: 30,
              ),
              uploadArea()
            ],
          ),
        ),
      ),
    );
  }

  Widget uploadArea() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.blueGrey[900],
      ),
      height: MediaQuery.of(context).size.height * .2,
      width: MediaQuery.of(context).size.width * .7,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                icon: file != null
                    ? Icon(Icons.upload)
                    : Icon(Icons.photo_size_select_actual_rounded),
                onPressed: () async {
                  if (file == null) {
                    saveImageInFirebase();
                  } else {
                    uploadImage();
                    file = null;
                  }

                  setState(() {});
                },
                label: Text(
                  file == null ? 'Select Image' : 'Upload',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ),
              file != null
                  ? Text(
                      fileName.toString(),
                      style: TextStyle(color: Colors.white),
                    )
                  : Container()
            ],
          ),
          SizedBox(
            width: 20,
          ),
          ElevatedButton.icon(
            icon: Icon(Icons.upload),
            onPressed: () {},
            label: Text(
              'Files',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }

  final User? user = FirebaseAuth.instance.currentUser!;
  void saveImageInFirebase() async {
    try {
      FilePickerResult? result =
          await FilePicker.platform.pickFiles(type: FileType.image);
      if (result != null) {
        file = result.files.first.bytes;
        fileName = result.files.first.name;
        fileExt = result.files.first.extension!;
        // print(file);
        setState(() {});

        // String? _downloadURL = await CloudStorageService()
        //     .saveChatImageToStorage(user!.uid, file!, fileName!);
        // String? imagebytefile = file.toString();
        // var data = {
        //   'FileName': fileName,
        //   'FileExt': fileExt,
        //   'content': _downloadURL!,
        //   'created': DateTime.now(),
        // };
        // imageref.add(data);
        // setState(() {});
      }
    } catch (e) {
      print("Error sending image message.");
      print(e);
    }
  }

  void uploadImage() async {
    String? _downloadURL = await CloudStorageService()
        .saveChatImageToStorage(user!.uid, file!, fileName!);
    var data = {
      'FileName': fileName,
      'FileExt': fileExt,
      'content': _downloadURL!,
      'created': DateTime.now(),
    };
    imageref.add(data);
    setState(() {});
  }

  Widget ImageWidget() {
    return Container(
      height: 180,
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
                      height: 180,
                      width: 180,
                      child: Card(
                        color: Colors.grey[850],
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
                                      color: Colors.blue,
                                    ),
                                  )),
                                ),
                                Positioned(
                                  bottom: 5,
                                  right: 5,
                                  child: Text(
                                    formattedTime,
                                    style: TextStyle(
                                      color: Color(0xff757575),
                                      fontWeight: FontWeight.w700,
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

  Widget PdfFilesWidget() {
    return Container(
      height: 180,
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
                      height: 180,
                      width: 180,
                      child: Card(
                        color: Colors.grey[850],
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
                                      color: Colors.blue,
                                    ),
                                  )),
                                ),
                                Positioned(
                                  bottom: 5,
                                  right: 5,
                                  child: Text(
                                    formattedTime,
                                    style: TextStyle(
                                      color: Color(0xff757575),
                                      fontWeight: FontWeight.w700,
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

  Widget buildUploadStatus(UploadTask task) => StreamBuilder<TaskSnapshot>(
        stream: task.snapshotEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final snap = snapshot.data!;
            final progress = snap.bytesTransferred / snap.totalBytes;
            final percentage = (progress * 100).toStringAsFixed(2);

            return Text(
              '$percentage %',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            );
          } else {
            return Container();
          }
        },
      );
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
          ),
        ),
      ),
    );
  }
}
