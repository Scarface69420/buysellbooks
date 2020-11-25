import 'package:buysellbooks/constants.dart';
import 'package:dropdownfield/dropdownfield.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';

final firestoreInstance = FirebaseFirestore.instance;

class ComputerDepartment extends StatefulWidget {
  static const String id = 'computer_depart';

  @override
  _ComputerDepartmentState createState() => _ComputerDepartmentState();
}

class _ComputerDepartmentState extends State<ComputerDepartment> {
  List<QuerySnapshot> compBooksList = [];
  bool isListVisible = false;

  @override
  void initState() {
    super.initState();
  }

  final searchController = TextEditingController();
  String getYear;

  // yourMethod() async {
  //   var data;
  //   var documents = await firestoreInstance
  //       .collection('Computer')
  //       .where('year', isEqualTo: getYear)
  //       .get();
  //   var object = documents.docs.forEach((element) {
  //     data = element.data();
  //   });
  //   print(data);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Computer books'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            DropDownField(
              controller: searchController,
              hintText: 'Enter Year',
              labelText: 'Year',
              enabled: true,
              items: whichYear,
              onValueChanged: (value) {
                setState(() {
                  value != null ? isListVisible = true : isListVisible = false;
                  getYear = value;
                });
              },
            ),
            SizedBox(
              height: 8.0,
            ),
            Visibility(
              child: StreamBuilderWidget(getYear: getYear),
              visible: isListVisible,
            ),
          ],
        ),
      ),
    );
  }
}

class StreamBuilderWidget extends StatelessWidget {
  const StreamBuilderWidget({
    Key key,
    @required this.getYear,
  }) : super(key: key);

  final String getYear;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: firestoreInstance
          .collection('Books')
          .where('department', isEqualTo: 'Computer')
          .where('year', isEqualTo: getYear)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.white,
            ),
          );
        }
        final books = snapshot.data.docs;
        List<ListBooks> booksInComp = [];

        for (var book in books) {
          final bookName = book.data()['bookname'];
          final bookPrice = book.data()['bookprice'];
          final contactOfSeller = book.data()['contactofseller'];
          final nameOfSeller = book.data()['nameofseller'];
          // final documentID = book.data()['documentID'];
          final listBook = ListBooks(
              bookname: bookName,
              price: bookPrice,
              sellerContact: contactOfSeller,
              sellerName: nameOfSeller);
          booksInComp.add(listBook);
        }

        return Expanded(
          child: ListView(
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            children: booksInComp,
          ),
        );
      },
    );
  }
}

List<String> whichYear = ['Second Year', 'Third Year', 'Final Year'];

Future<void> _makePhoneCall(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

Future<void> _sendSMS(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

Future<void> _sendWhatsAppMessage(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

enum ConfirmationAction { CANCEL, CALL }

class ListBooks extends StatefulWidget {
  final String bookname;
  final String price;
  final String sellerName;
  final String sellerContact;

  ListBooks({this.bookname, this.price, this.sellerName, this.sellerContact});

  @override
  _ListBooksState createState() => _ListBooksState();
}

class _ListBooksState extends State<ListBooks> {
  Color color = kInActiveCardColor;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                color = kActiveCardColor;
                _asyncConfirmationDialog(context);
              });
            },
            child: Material(
              borderRadius: BorderRadius.all(Radius.circular(15.0)),
              color: color,
              elevation: 5.0,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                child: Column(
                  children: [
                    Text(
                      widget.bookname,
                      style: TextStyle(fontSize: 20.0),
                    ),
                    Text(
                      'Rs. ${widget.price}',
                      style: TextStyle(fontSize: 15.0),
                    ),
                    SizedBox(
                      height: 4.0,
                      child: Divider(
                        thickness: 1.0,
                        color: Colors.deepPurpleAccent,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'Seller : ${widget.sellerName}',
                          style: TextStyle(fontSize: 15.0),
                        ),
                        Text(
                          'Contact : ${widget.sellerContact}',
                          style: TextStyle(fontSize: 15.0),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<ConfirmationAction> _asyncConfirmationDialog(
      BuildContext context) async {
    return showDialog<ConfirmationAction>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Contact Book Owner',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: Text('How do you want to contact the Seller?'),
            actions: [
              FlatButton(
                child: Text(
                  'CANCEL',
                  style: TextStyle(color: Colors.red.shade300),
                ),
                onPressed: () {
                  Navigator.of(context).pop(ConfirmationAction.CANCEL);
                },
              ),
              FlatButton(
                child: Text(
                  'WhatsApp',
                  style: TextStyle(color: Colors.green),
                ),
                onPressed: () {
                  Clipboard.setData(new ClipboardData(
                      text:
                          'Hey ${widget.sellerName},\n\nI saw you have the book: ${widget.bookname} in the Book!nter apps bookstore.'
                          '\n\nI\'m willing to buy the book if its still with you :)'));
                  _sendWhatsAppMessage(
                      'https://wa.me/91${widget.sellerContact}');
                  // Navigator.of(context).pop(ConfirmationAction.CANCEL);
                },
              ),
              FlatButton(
                child: Text(
                  'SMS',
                  style: TextStyle(color: Colors.purple.shade300),
                ),
                onPressed: () {
                  Clipboard.setData(new ClipboardData(
                      text:
                          'Hey ${widget.sellerName},\n\nI saw you have the book: ${widget.bookname} in the Book!nter apps bookstore.'
                          '\n\nI\'m willing to buy the book if its still with you :)'));
                  _sendSMS('sms:${widget.sellerContact}');
                  // Navigator.of(context).pop(ConfirmationAction.CANCEL);
                },
              ),
              FlatButton(
                child: Text(
                  'CALL',
                  style: TextStyle(color: Colors.blue),
                ),
                onPressed: () {
                  _makePhoneCall('tel:${widget.sellerContact}');
                  // Navigator.of(context).pop(ConfirmationAction.CALL);
                },
              ),
            ],
          );
        });
  }
}
