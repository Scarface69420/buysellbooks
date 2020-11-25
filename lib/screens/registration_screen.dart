import 'package:buysellbooks/constants.dart';
import 'package:buysellbooks/screens/home_screen.dart';
import 'package:buysellbooks/screens/login_screen.dart';
import 'package:buysellbooks/screens/welcome_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:buysellbooks/components/rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:buysellbooks/test/auth_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:buysellbooks/main.dart';

AuthServices auth;

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  final firebase = FirebaseFirestore.instance;
  bool showSpinner = false;
  String email, password, name, contact;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/books.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.name,
                onChanged: (value) {
                  name = value;
                },
                decoration:
                    kTextFieldDecoration.copyWith(hintText: 'Enter your name'),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.phone,
                onChanged: (value) {
                  contact = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Enter your phone number'),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  email = value;
                },
                decoration:
                    kTextFieldDecoration.copyWith(hintText: 'Enter your email'),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  password = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Enter your password'),
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                title: 'Register',
                color: Colors.blueAccent,
                onPressed: () async {
                  setState(() {
                    showSpinner = true;
                  });
                  try {
                    // final newUser = await _auth.createUserWithEmailAndPassword(
                    //     email: email, password: password);
                    // final newUser = await auth.createUserWithEmailAndPassword(
                    //     email, password, name, contact);
                    final newUser = await _auth
                        .createUserWithEmailAndPassword(
                            email: email, password: password)
                        .then((onValue) {
                      firebase.collection('users').doc(onValue.user.uid).set({
                        'userid': onValue.user.uid,
                        'Name': name,
                        'Contact': contact,
                        // 'imageurl': null,
                      }).then((userInfoValue) {
                        // Navigator.pushNamed(context, LoginScreen.id);
                      });
                    }).catchError((onError) {
                      print(onError);
                    });

                    if (newUser != null) {
                      User user = FirebaseAuth.instance.currentUser;

                      prefs = await SharedPreferences.getInstance();
                      prefs.setString('email', user.email);
                      prefs.setString('name', name);
                      prefs.setString('contact', contact);

                      Fluttertoast.showToast(
                        msg: 'Log in using ${user.email}',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        textColor: Colors.white,
                        backgroundColor: kButtonTextColor,
                      );
                    }

                    Navigator.pushNamed(context, LoginScreen.id);

                    setState(() {
                      showSpinner = false;
                    });
                  } catch (e) {
                    print(e);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
