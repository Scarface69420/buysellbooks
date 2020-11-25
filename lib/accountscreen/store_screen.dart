import 'package:buysellbooks/constants.dart';
import 'package:buysellbooks/screens/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

final firestoreInstance = FirebaseFirestore.instance;

final _auth = FirebaseAuth.instance;
User loggedInUser;

String bookName, nameOfSeller;

class StoreScreen extends StatefulWidget {
  static const String id = 'store_screen';

  @override
  _StoreScreenState createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  var userName, userContact;
  bool isListVisible = false;

  var name = prefs.getString('name');

  @override
  void initState() {
    super.initState();
    getCurrentUserDetails();
    print(name);
  }

  final searchController = TextEditingController();
  String getYear;

  void getCurrentUserDetails() async {
    try {
      final user = _auth.currentUser;
      // usersStoredInfo.collection('Users').doc()
      if (user != null) {
        loggedInUser = user;

        var names = await firestoreInstance
            .collection('users')
            .where('userid', isEqualTo: loggedInUser.uid)
            .get();
        setState(() {
          userName = names.docs.first.data()['Name'];
        });

        print(userName);
        var contacts = await firestoreInstance
            .collection('users')
            .where('userid', isEqualTo: loggedInUser.uid)
            .get();
        setState(() {
          userContact = contacts.docs.first.data()['Contact'];
        });

        print(userContact);

        // await usersStoredInfo
        //     .collection('users')
        //     .doc(loggedInUser.uid)
        //     .get()
        //     .then((value) => name = value.data()['Name']);
        // await usersStoredInfo
        //     .collection('users')
        //     .doc(loggedInUser.uid)
        //     .get()
        //     .then((value) => contact = value.data()['Contact']);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Your books on Store'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            StreamBuilderBooks(getUser: userName),
          ],
        ),
      ),
    );
  }
}

class StreamBuilderBooks extends StatelessWidget {
  const StreamBuilderBooks({
    Key key,
    @required this.getUser,
  }) : super(key: key);

  final String getUser;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: firestoreInstance
          .collection('Books')
          .where('nameofseller', isEqualTo: getUser)
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
          final documentID = book.data()['documentID'];
          final listBook = ListBooks(
            bookname: bookName,
            price: bookPrice,
            sellerContact: contactOfSeller,
            sellerName: nameOfSeller,
            docID: documentID,
          );
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

class ListBooks extends StatefulWidget {
  final String bookname;
  final String price;
  final String sellerName;
  final String sellerContact;
  final String docID;

  ListBooks(
      {this.bookname,
      this.price,
      this.sellerName,
      this.sellerContact,
      this.docID});

  @override
  _ListBooksState createState() => _ListBooksState();
}

class _ListBooksState extends State<ListBooks> {
  Color color = kInActiveCardColor;
  bool firstPress = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GestureDetector(
            onTap: () {
              if (firstPress) {
                setState(() {
                  color = kActiveCardColor;
                  firstPress = false;
                });
              } else {
                setState(() {
                  color = kInActiveCardColor;
                  firstPress = true;
                });
              }
            },
            onLongPress: () {
              setState(() {
                color = Colors.red;
                _asyncConfirmationDialog(context);
              });
            },
            child: Material(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              color: color,
              elevation: 5.0,
              shadowColor: Colors.black,
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
            title: Text('Remove Book?'),
            content: Text('This book will be removed from the store.'),
            actions: [
              FlatButton(
                child: Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop(ConfirmationAction.CANCEL);
                },
              ),
              FlatButton(
                child: Text('REMOVE'),
                onPressed: () {
                  firestoreInstance
                      .collection('Books')
                      .doc(widget.docID)
                      .delete();
                  Fluttertoast.showToast(
                    msg: 'Book has been removed from the store!',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    textColor: Colors.black,
                    backgroundColor: kButtonTextColor,
                  );
                  Navigator.of(context).pop(ConfirmationAction.REMOVE);
                },
              ),
            ],
          );
        });
  }
}

// await Firestore.instance.runTransaction((Transaction myTransaction) async {
// await myTransaction.delete(snapshot.data.documents[index].reference);
// });

enum ConfirmationAction { CANCEL, REMOVE }
