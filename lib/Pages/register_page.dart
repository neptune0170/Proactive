//Packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notesapp/Pages/home_page.dart';

import 'package:notesapp/widgets/custom_input_form_field.dart';

import '../widgets/rounded_button.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RegisterPageState();
  }
}

class _RegisterPageState extends State<RegisterPage> {
  late double _deviceHeight;
  late double _deviceWidth;

  String? _email;
  String? _password;
  String? _name;

  final _registerFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return _buildUI();
  }

  Widget _buildUI() {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Icon(Icons.arrow_back)),
        backgroundColor: Colors.black,
      ),
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: _deviceWidth * 0.03,
          vertical: _deviceHeight * 0.02,
        ),
        height: _deviceHeight * 0.98,
        width: _deviceWidth * 0.97,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: _deviceHeight * 0.05,
            ),
            _registerForm(),
            SizedBox(
              height: _deviceHeight * 0.05,
            ),
            _registerButton(),
            SizedBox(
              height: _deviceHeight * 0.02,
            ),
          ],
        ),
      ),
    );
  }

  Widget _registerForm() {
    return Container(
      height: _deviceHeight * 0.35,
      child: Form(
        key: _registerFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomTextFormField(
                onSaved: (_value) {
                  setState(() {
                    _name = _value;
                  });
                },
                regEx: r'.{8,}',
                hintText: "Name",
                obscureText: false),
            CustomTextFormField(
                onSaved: (_value) {
                  setState(() {
                    _email = _value;
                  });
                },
                regEx:
                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                hintText: "Email",
                obscureText: false),
            CustomTextFormField(
                onSaved: (_value) {
                  setState(() {
                    _password = _value;
                  });
                },
                regEx: r".{8,}",
                hintText: "Password",
                obscureText: true),
          ],
        ),
      ),
    );
  }

  Widget _registerButton() {
    return RoundedButton(
      name: "Register",
      height: _deviceHeight * 0.065,
      width: _deviceWidth * 0.65,
      onPressed: () async {
        if (_registerFormKey.currentState!.validate()) {
          _registerFormKey.currentState!.save();

          final UserCredential authResult =
              await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: _email!,
            password: _password!,
          );
          final User? user = authResult.user;

          var userData = {
            'name': _name,
            'email': _email,
            'password': _password,
            'TimeStamp': DateTime.now().toString(),
          };
          CollectionReference users =
              FirebaseFirestore.instance.collection('users');
          users.doc(user!.uid).get().then((doc) {
            if (doc.exists) {
              doc.reference.update(userData);
            } else {
              users.doc(user.uid).set(userData);
            }
          });
          Navigator.of(context).pop();
          try {
            final UserCredential authResult = await FirebaseAuth.instance
                .signInWithEmailAndPassword(
                    email: _email!, password: _password!);

            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => HomePage(),
              ),
            );
          } on FirebaseAuthException {
            print("Error logging user into Firebase");
          } catch (e) {
            print(e);
          }
          setState(() {});

          // String? _uid = await _auth.registerUserUsingEmailAndPassword(
          //     _email!, _password!);
          // String? _imageURL =
          //     await _cloudStorage.saveUserImageToStorage(_uid!, _profileImage!);
          // await _db.createUser(_uid, _email!, _name!, _imageURL!);
          // await _auth.logout();
          // await _auth.loginUsingEmailAndPassword(_email!, _password!);
        }
      },
    );
  }
}
