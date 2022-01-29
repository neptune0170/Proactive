// ignore_for_file: prefer_const_constructors

import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WhatsNew extends StatefulWidget {
  const WhatsNew({Key? key}) : super(key: key);

  @override
  _WhatsNewState createState() => _WhatsNewState();
}

String? des;
CollectionReference whatsnew =
    FirebaseFirestore.instance.collection('whatsnew');

class _WhatsNewState extends State<WhatsNew> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('What\'s New'),
        backgroundColor: Colors.black,
        actions: [
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                  onTap: () {
                    modalBottomSheet(context);
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.blue[900],
                    radius: 20,
                    child: Icon(
                      Icons.upload_file_outlined,
                      color: Colors.white,
                    ),
                  ))),
        ],
      ),
      body: SingleChildScrollView(
          child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: FutureBuilder<QuerySnapshot>(
          future: whatsnew
              .orderBy(
                'created',
              )
              .get(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.docs.length == 0) {
                return Center(
                  child: Text(
                    "You have not started !",
                    style: TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                );
              }
              return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    Map data = snapshot.data!.docs[index].data() as Map;
                    DateTime mydateTime = data['created'].toDate();
                    String Date =
                        DateFormat.yMMMd().add_jm().format(mydateTime);

                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Text(
                                Date,
                                style: TextStyle(
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              child: Text(data['title'],
                                  style: TextStyle(
                                      fontFamily: 'Lato',
                                      // fontWeight: FontWeight.bold,
                                      fontSize: 16)),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Divider(
                              color: Colors.grey,
                            )
                          ],
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
      )

          // Column(
          //   children: [
          //     Container(
          //       child: Text(
          //         'DATE',
          //         style: TextStyle(
          //             fontFamily: 'Lato',
          //             fontWeight: FontWeight.bold,
          //             fontSize: 24),
          //       ),
          //     ),
          //     SizedBox(
          //       height: 10,
          //     ),
          //     Container(
          //       child: Text('Detail',
          //           style: TextStyle(
          //               fontFamily: 'Lato',
          //               // fontWeight: FontWeight.bold,
          //               fontSize: 16)),
          //     )
          //   ],
          // ),
          ),
    );
  }

  void modalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Container(
            height: 350.0,
            color: Colors.transparent,
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0))),
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            height: 260,
                            width: MediaQuery.of(context).size.width,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                decoration: InputDecoration.collapsed(
                                  hintText: "Title",
                                ),
                                maxLines: 7,
                                style: TextStyle(
                                  fontSize: 32.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                                onChanged: (val) {
                                  des = val;
                                },
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                                onPressed: () {
                                  add();
                                },
                                child: Text('Upload')),
                          )
                        ],
                      ),
                    ))),
          );
        });
  }

  void add() async {
    // save to db
    CollectionReference ref = FirebaseFirestore.instance.collection('whatsnew');

    var data = {
      'title': des,
      'created': DateTime.now(),
    };

    ref.add(data);

    //
    Navigator.pop(context);

    Navigator.pop(context);
  }
}
