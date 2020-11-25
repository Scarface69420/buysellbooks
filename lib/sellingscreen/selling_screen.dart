import 'package:buysellbooks/components/rounded_button.dart';
import 'package:buysellbooks/constants.dart';
import 'package:buysellbooks/screens/welcome_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dropdownfield/dropdownfield.dart';

final _firestore = FirebaseFirestore.instance;

final _auth = FirebaseAuth.instance;

class SellingScreen extends StatefulWidget {
  static const String id = 'selling_screen';
  @override
  _SellingScreenState createState() => _SellingScreenState();
}

class _SellingScreenState extends State<SellingScreen> {
  final textControllerB = TextEditingController();
  final textControllerP = TextEditingController();
  final departmentController = TextEditingController();
  final yearController = TextEditingController();

  String department = '';
  String year = '';

  String bookName;
  String bookPrice;
  String nameOfSeller, contactOfSeller;

  // Future<String> getName() async {
  //   final nameOfSeller = await _firestore
  //       .collection('users')
  //       .doc(_auth.currentUser.uid)
  //       .get()
  //       .then((value) => value.data()['Name']);
  //   return nameOfSeller;
  // }
  //
  // Future<void> name() async {
  //   getName().then((value) => nameOfSellerR = value);
  // }
  //
  // final contactOfSeller = _firestore
  //     .collection('users')
  //     .doc(_auth.currentUser.uid)
  //     .get()
  //     .then((value) => value.data()['Contact']);
  @override
  void initState() {
    super.initState();
    getDetails();
  }

  void getDetails() async {
    prefs = await SharedPreferences.getInstance();
    nameOfSeller = prefs.getString('name');
    contactOfSeller = prefs.getString('contact');
    print(nameOfSeller);
    print(contactOfSeller);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                DropDownField(
                  controller: departmentController,
                  required: true,
                  hintText: 'Select department',
                  labelText: 'Department',
                  enabled: true,
                  items: whichDepartment,
                  onValueChanged: (value) {
                    setState(() {
                      department = value;
                    });
                  },
                ),
                SizedBox(height: 4.0),
                DropDownField(
                  controller: yearController,
                  hintText: 'Select Year',
                  labelText: 'Year',
                  required: true,
                  items: whichYear,
                  onValueChanged: (value) {
                    setState(() {
                      year = value;
                    });
                  },
                ),
                SizedBox(
                  height: 4.0,
                ),
                Text(
                  'Name of the Book',
                  style: TextStyle(
                    fontSize: 19.0,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 5.0,
                ),
                TextField(
                  controller: textControllerB,
                  decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Enter Book\'s Name'),
                  onChanged: (value) {
                    setState(() {
                      bookName = value;
                    });
                  },
                ),
                SizedBox(
                  height: 8.0,
                ),
                Text(
                  'Price of the Book',
                  style: TextStyle(
                    fontSize: 19.0,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 5.0,
                ),
                TextField(
                  controller: textControllerP,
                  keyboardType: TextInputType.number,
                  decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Enter Book\'s Price '),
                  onChanged: (value) {
                    setState(() {
                      bookPrice = value;
                    });
                  },
                ),
                SizedBox(
                  height: 12.0,
                ),
                RoundedButton(
                  color: kActiveCardColor,
                  title:
                      '                       Add to Store                       ',
                  onPressed: () {
                    textControllerP.clear();
                    textControllerB.clear();
                    departmentController.clear();
                    yearController.clear();
                    // _firestore.collection('Books').add({
                    //   'department': department,
                    //   'year': year,
                    //   'bookname': bookName,
                    //   'bookprice': bookPrice,
                    //   'nameofseller': nameOfSeller != null
                    //       ? nameOfSeller
                    //       : _auth.currentUser.email,
                    //   'contactofseller': contactOfSeller,
                    // });

                    DocumentReference docRef =
                        _firestore.collection('Books').doc();
                    docRef.set({
                      'department': department,
                      'year': year,
                      'bookname': bookName,
                      'bookprice': bookPrice,
                      'nameofseller': nameOfSeller != null
                          ? nameOfSeller
                          : _auth.currentUser.email,
                      'contactofseller': contactOfSeller,
                      'documentID': docRef.id,
                    });

                    Fluttertoast.showToast(
                      msg: 'Book added to Store!',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      textColor: Colors.black,
                      backgroundColor: kButtonTextColor,
                    );
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // void showInSnackBar(String value) {
  //   Scaffold.of(context).showSnackBar(SnackBar(content: Text(value)));
  // }
}

List<String> whichDepartment = ['Computer', 'Mechanical', 'Civil', 'ENTC'];
List<String> whichYear = ['Second Year', 'Third Year', 'Final Year'];

// DocumentReference docRef =
// _firestore.collection('TestBooks').doc();
// docRef.set({
// 'department': department,
// 'year': year,
// 'bookname': bookName,
// 'bookprice': bookPrice,
// 'nameofseller': nameOfSeller != null
// ? nameOfSeller
//     : _auth.currentUser.email,
// 'contactofseller': contactOfSeller,
// 'documentID': docRef.id,
// });
