import 'package:buysellbooks/screens/welcome_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';

final _auth = FirebaseAuth.instance;
User loggedInUser;
final usersStoredInfo = FirebaseFirestore.instance;
var imageURL;

class PersonalInfo extends StatefulWidget {
  static const String id = 'personal_info';

  @override
  _PersonalInfoState createState() => _PersonalInfoState();
}

class _PersonalInfoState extends State<PersonalInfo> {
  String name, contact;
  var userName, userContact;
  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      // usersStoredInfo.collection('Users').doc()
      if (user != null) {
        loggedInUser = user;

        // var image = usersStoredInfo
        //     .collection('users')
        //     .doc(loggedInUser.uid)
        //     .get()
        //     .then((value) {
        //   imageURL = value.data()['imageurl'];
        // });

        var names = await usersStoredInfo
            .collection('users')
            .where('userid', isEqualTo: loggedInUser.uid)
            .get();
        setState(() {
          userName = names.docs.first.data()['Name'];
        });

        print(userName);
        var contacts = await usersStoredInfo
            .collection('users')
            .where('userid', isEqualTo: loggedInUser.uid)
            .get();
        setState(() {
          userContact = contacts.docs.first.data()['Contact'];
        });

        print(userContact);
      }
    } catch (e) {
      print(e);
    }
  }

  TextStyle defaultText = TextStyle(
    color: Colors.white,
    fontSize: 30.0,
    fontFamily: 'Lobster',
    fontWeight: FontWeight.bold,
  );

  TextStyle linkTextStyle = TextStyle(color: Colors.grey, fontSize: 18.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.teal,
      // appBar: AppBar(
      //   title: Text('Account Info'),
      // ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 60.0,
              backgroundImage: AssetImage('images/user_avatar_three.jpg'),
            ),
            SizedBox(
              height: 2.0,
            ),
            Text(
              ' $userName ',
              style: defaultText,
            ),
            SizedBox(
              height: 20.0,
              width: 250.0,
              child: Divider(color: Colors.teal.shade100),
            ),
            Card(
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                child: ListTile(
                  leading: Icon(
                    Icons.phone,
                    color: Color(0xDD0A0E21),
                  ),
                  title: Text(
                    '+91 $userContact',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'SourceSansPro',
                      fontSize: 20.0,
                    ),
                  ),
                )),
            Card(
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
              child: ListTile(
                leading: Icon(
                  Icons.email,
                  color: Color(0xDD0A0E21),
                ),
                title: Text(
                  loggedInUser.email,
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'SourceSansPro',
                    fontSize: 20.0,
                  ),
                ),
              ),
            ),
            // Text(
            //   'Email : ${loggedInUser.email}',
            //   style: defaultText,
            // ),
            // Text(
            //   'Contact Number : $userContact',
            //   style: defaultText,
            // ),
            SizedBox(
              height: 20.0,
            ),
            RichText(
              text: TextSpan(
                  text: 'Click here to edit info',
                  style: linkTextStyle,
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      print('Redirect to page where you can edit your Info');
                    }),
            ),
            SizedBox(
              height: 40.0,
            ),
            FlatButton(
              autofocus: true,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              color: Colors.black,
              child: Text(' Logout ',
                  style: TextStyle(
                      color: Colors.white,
                      // backgroundColor: Colors.redAccent,
                      fontSize: 32.0)),
              onPressed: () {
                logoutUserInfo();
                prefs.clear();
                if (_auth != null) {
                  _auth.signOut();
                }
                Fluttertoast.showToast(
                  msg: 'Hope to see you soon $userName!',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  textColor: Colors.white,
                  backgroundColor: kButtonTextColor,
                );
                Navigator.pushNamed(context, WelcomeScreen.id);
              },
            )
          ],
        ),
      ),
    );
  }
}

void logoutUserInfo() async {
  // usersStoredInfo.collection('Users').where('userid', isEqualTo: ${user.u})
  prefs = await SharedPreferences.getInstance();
}
