import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddStreak extends StatefulWidget {
  const AddStreak({Key? key}) : super(key: key);

  @override
  _AddStreakState createState() => _AddStreakState();
}

class _AddStreakState extends State<AddStreak> {
  String? title;
  DateTime? lastDay;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Task Streak'),
        backgroundColor: Colors.black,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Image(
              image: AssetImage('assets/Images/flame.png'),
              height: 20,
              width: 20,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(
            12.0,
          ),
          child: Column(
            children: [
              Form(
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration.collapsed(hintText: "Title"),
                      style: TextStyle(
                        fontSize: 32.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                      onChanged: (_val) {
                        title = _val;
                      },
                      maxLines: 2,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .6,
                    ),
                    ElevatedButton(onPressed: add, child: Text('Create streak'))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void add() async {
    // save to db
    CollectionReference ref = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('streaks');

    var data = {
      'title': title,
      'created': DateFormat("dd-MM-yyyy").format(DateTime.now()),
      'current_streak': 0,
    };

    ref.add(data);
    Navigator.pop(context);
    Navigator.pop(context);
  }
}
