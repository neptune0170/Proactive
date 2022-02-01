import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddNote extends StatefulWidget {
  @override
  _AddNoteState createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  String? title;
  String? des;
  int priorityIndex = 0;
  final List<String> priorityList = <String>[
    "Low",
    "Medium",
    "Urgent",
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(
              12.0,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      },
                      child: Icon(
                        Icons.arrow_back_ios_outlined,
                        size: 24.0,
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          Colors.grey[700],
                        ),
                        padding: MaterialStateProperty.all(
                          EdgeInsets.symmetric(
                            horizontal: 25.0,
                            vertical: 8.0,
                          ),
                        ),
                      ),
                    ),
                    //
                    title != null
                        ? ElevatedButton(
                            onPressed: add,
                            child: Text(
                              "Save",
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.white,
                              ),
                            ),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                Colors.grey[700],
                              ),
                              padding: MaterialStateProperty.all(
                                EdgeInsets.symmetric(
                                  horizontal: 25.0,
                                  vertical: 8.0,
                                ),
                              ),
                            ),
                          )
                        : Container(),
                  ],
                ),
                //
                SizedBox(
                  height: 12.0,
                ),
                //
                Form(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Priority :',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xffffffff),
                                fontSize: 21),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            height: 38,
                            width: 300,
                            child: ListView.builder(
                              itemCount: priorityList.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return priorityChip(context, index);
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      TextFormField(
                        decoration: InputDecoration.collapsed(
                          hintText: "Title",
                        ),
                        style: TextStyle(
                          fontSize: 32.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                        onChanged: (_val) {
                          setState(() {
                            title = _val;
                          });
                        },
                      ),
                      //
                      Container(
                        height: MediaQuery.of(context).size.height * 0.75,
                        padding: const EdgeInsets.only(top: 12.0),
                        child: TextFormField(
                          decoration: InputDecoration.collapsed(
                            hintText: "Note Description",
                          ),
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.grey,
                          ),
                          onChanged: (_val) {
                            des = _val;
                          },
                          maxLines: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
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
        .collection('notes');

    var data = {
      'title': title,
      'description': des,
      'created': DateTime.now(),
      'Completed': false,
      'Priority': priorityIndex,
    };

    ref.add(data);

    //
    Navigator.pop(context);

    Navigator.pop(context);
  }

  Widget priorityChip(BuildContext context, int index) {
    return Padding(
      padding: EdgeInsets.only(right: 10),
      child: ChoiceChip(
        selected: priorityIndex == index,
        label: Text(priorityList[index].toString(),
            style: TextStyle(
                color: priorityIndex == index ? Colors.white : Colors.black)),
        backgroundColor: Color(0xffededed),
        selectedColor: priorityList[index] == 'Urgent'
            ? Colors.red
            : (priorityList[index] == 'Medium'
                ? Colors.yellow[700]
                : priorityList[index] == 'Low'
                    ? Colors.green
                    : Colors.blue),
        onSelected: (bool selected) {
          setState(() {
            if (selected) {
              priorityIndex = index;
              print('index + ${priorityIndex}');
            }
          });
        },
      ),
    );
  }
}
