import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notesapp/Pages/Notes/viewnote.dart';

class CompletedNotes extends StatefulWidget {
  const CompletedNotes({Key? key}) : super(key: key);

  @override
  _CompletedNotesState createState() => _CompletedNotesState();
}

class _CompletedNotesState extends State<CompletedNotes> {
  CollectionReference notesref = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('notes');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Completed Notes'),
      ),
      body: completedNotesWidget(),
    );
  }

  Widget completedNotesWidget() {
    return Container(
      height: 200,
      width: MediaQuery.of(context).size.width,
      child: FutureBuilder<QuerySnapshot>(
        future: notesref.where('Completed', isEqualTo: true).get(),
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
                  // Random random = new Random();
                  Color bg = Colors.grey;
                  Map data = snapshot.data!.docs[index].data() as Map;
                  DateTime mydateTime = data['created'].toDate();
                  String formattedTime =
                      DateFormat.yMMMd().add_jm().format(mydateTime);
                  return InkWell(
                    onLongPress: () {
                      markAsNotCompleted(
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
                                  "${data['title']}",
                                  style: TextStyle(
                                    decoration: TextDecoration.lineThrough,
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  "${data['description']}",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 4,
                                  style: TextStyle(
                                    decoration: TextDecoration.lineThrough,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[350],
                                  ),
                                ),
                                //
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 5,
                        right: 30,
                        child: Container(
                          alignment: Alignment.centerRight,
                          child: Text(
                            formattedTime,
                            style: TextStyle(
                              fontSize: 15.0,
                              color: Colors.grey[350],
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

  markAsNotCompleted(BuildContext context, DocumentReference ref) {
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
        var userData = {'Completed': false};
        ref.update(userData);
        Navigator.of(context).pop();
        setState(() {});
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("AlertDialog"),
      content: Text("Do you want Mark this task as Not completed"),
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
