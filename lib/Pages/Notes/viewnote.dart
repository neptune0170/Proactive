import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class ViewNote extends StatefulWidget {
  int? priorityIndex;
  Map data;
  String time;
  DocumentReference ref;

  ViewNote(this.priorityIndex, this.data, this.time, this.ref);

  @override
  _ViewNoteState createState() =>
      _ViewNoteState(priorityIndex, data, time, ref);
}

class _ViewNoteState extends State<ViewNote> {
  int? priorityIndex;
  Map? data;
  String? time;
  DocumentReference? ref;

  String? title;
  String? des;
  // int? priorityIndex;

  bool edit = true;

  List<String> priorityList = <String>[
    "Low",
    "Medium",
    "Urgent",
  ];
  int? savePriority = 0;
  GlobalKey<FormState> key = GlobalKey<FormState>();
  _ViewNoteState(this.priorityIndex, this.data, this.time, this.ref);

  @override
  void dispose() {
    // TODO: implement dispose
    print('tesxt');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    title = widget.data['title'];
    des = widget.data['description'];
    if (priorityIndex == null) {
      priorityIndex = 0;
    }
    savePriority = priorityIndex;
    return SafeArea(
      child: Scaffold(
//Save textButton
        // floatingActionButton: edit
        //     ? FloatingActionButton(
        //         onPressed: save,
        //         child: Icon(
        //           Icons.save_rounded,
        //           color: Colors.white,
        //         ),
        //         backgroundColor: Colors.grey[700],
        //       )
        //     : null,
        //
        resizeToAvoidBottomInset: false,
        //
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
                        save();
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
                    Row(
                      children: [
                        //#Edit Button Hide
                        // ElevatedButton(
                        //   onPressed: () {
                        //     setState(() {
                        //       edit = !edit;
                        //     });
                        //   },
                        //   child: Icon(
                        //     Icons.edit,
                        //     size: 24.0,
                        //   ),
                        //   style: ButtonStyle(
                        //     backgroundColor: MaterialStateProperty.all(
                        //       Colors.grey[700],
                        //     ),
                        //     padding: MaterialStateProperty.all(
                        //       EdgeInsets.symmetric(
                        //         horizontal: 15.0,
                        //         vertical: 8.0,
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        //
                        SizedBox(
                          width: 8.0,
                        ),
                        //
                        ElevatedButton(
                          onPressed: delete,
                          child: Icon(
                            Icons.delete_forever,
                            size: 24.0,
                          ),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                              Colors.red[300],
                            ),
                            padding: MaterialStateProperty.all(
                              EdgeInsets.symmetric(
                                horizontal: 15.0,
                                vertical: 8.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                //
                SizedBox(
                  height: 12.0,
                ),
                //
                Form(
                  key: key,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            const Text(
                              'Priority :',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
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
                            SizedBox(
                              width: 80,
                            ),
                            ElevatedButton.icon(
                                onPressed: () async {
                                  await Share.share(
                                      "*${widget.data['title']}* ${widget.data['description']} _*Shared by notesapp-6268f.web.app/*_");
                                },
                                icon: Icon(Icons.share),
                                label: Text("Share"))
                          ],
                        ),
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
                        initialValue: widget.data['title'],
                        enabled: edit,
                        onChanged: (_val) {
                          title = _val;
                        },
                        validator: (_val) {
                          if (_val!.isEmpty) {
                            return "Can't be empty !";
                          } else {
                            return null;
                          }
                        },
                      ),
                      //
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 12.0,
                          bottom: 12.0,
                        ),
                        child: Text(
                          widget.time,
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.grey,
                          ),
                        ),
                      ),

                      //

                      TextFormField(
                        decoration: InputDecoration.collapsed(
                          hintText: "Note Description",
                        ),
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.grey,
                        ),
                        initialValue: widget.data['description'],
                        enabled: edit,
                        onChanged: (_val) {
                          des = _val;
                        },
                        maxLines: 20,
                        validator: (_val) {
                          if (_val!.isEmpty) {
                            return "Can't be empty !";
                          } else {
                            return null;
                          }
                        },
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

  void delete() async {
    // delete from db
    await widget.ref.delete();
    Navigator.pop(context);
  }

  void save() async {
    if (key.currentState!.validate()) {
      // TODo : showing any kind of alert that new changes have been saved
      await widget.ref.update(
        {'title': title, 'description': des, 'Priority': savePriority},
      );
      Navigator.of(context).pop();
    }
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
              savePriority = index;
              print('index + ${priorityIndex}');
            }
          });
        },
      ),
    );
  }
}
