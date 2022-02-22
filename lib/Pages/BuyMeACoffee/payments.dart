import 'dart:html';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notesapp/Pages/home_page.dart';
import 'UiFake.dart' if (dart.library.html) 'dart:ui' as ui;

class Webpayment extends StatelessWidget {
  final String? name;
  final String? image;
  final int? price;
  Webpayment({this.name, this.price, this.image});
  @override
  Widget build(BuildContext context) {
    ui.platformViewRegistry.registerViewFactory("rzp-html", (int viewId) {
      IFrameElement element = IFrameElement();
      window.onMessage.forEach((element) {
        print('Event Received in callback: ${element.data}');

        // else if (element.data == 'SUCCESS') {
        //   print('PAYMENT SUCCESSFULL!!!!!!!');

        // }
        Navigator.pop(context);

        // FirebaseFirestore.instance
        //     .collection('Products')
        //     .doc('iphone12')
        //     .update({'payment': "Done"});
      });

      element.src = 'assets/payments.html?name=$name&price=$price&image=$image';
      element.style.border = 'none';

      return element;
    });
    return Scaffold(
        body: Column(
      children: [
        SizedBox(height: 10),
        Text(
          '*Note: This feature is currently in Test Mode till 28th Feb 2022, till then we don\'t accept donations .',
          style: TextStyle(
              color: Colors.red, fontWeight: FontWeight.bold, fontSize: 15),
        ),
        SizedBox(
          height: 10,
        ),
        ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back_ios),
            label: Text('Go back')),
        Expanded(
          child: Builder(builder: (BuildContext context) {
            return Container(
              child: HtmlElementView(viewType: 'rzp-html'),
            );
          }),
        ),
      ],
    ));
  }
}
