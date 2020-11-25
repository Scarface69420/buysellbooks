import 'package:buysellbooks/components/rounded_button.dart';
import 'package:dropdownfield/dropdownfield.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:buysellbooks/searchservice.dart';

class Engineering extends StatefulWidget {
  static const String id = 'engineering';

  @override
  _EngineeringState createState() => _EngineeringState();
}

class _EngineeringState extends State<Engineering> {
  @override
  void initState() {
    super.initState();
  }

  final searchController = TextEditingController();
  String getYear;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Buy books'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            DropDownField(
              controller: searchController,
              hintText: 'Enter Year',
              labelText: 'Year',
              enabled: true,
              items: whichYear,
              onValueChanged: (value) {
                setState(() {
                  getYear = value;
                });
              },
            ),
            SizedBox(
              height: 8.0,
            ),
            RoundedButton(
              color: Colors.blueAccent,
              title: 'Search for books',
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}

List<String> whichYear = ['Second Year', 'Third Year', 'Final Year'];
