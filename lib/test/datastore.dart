import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final _firestore = FirebaseFirestore.instance;

class BookStream extends StatelessWidget {
  static const String id = 'datastore';
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('books').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.white,
            ),
          );
        }
        final books = snapshot.data.docs;
        List<ListBook> booksInDatabase = [];

        for (var book in books) {
          final bookName = book.data()['bookname'];
          final listBook = ListBook(
            text: bookName,
          );
          booksInDatabase.add(listBook);
        }
        return Expanded(
          child: ListView(
            reverse: true,
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            children: booksInDatabase,
          ),
        );
      },
    );
  }
}

class ListBook extends StatelessWidget {
  final String text;

  ListBook({Key key, this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Material(
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
            color: Colors.blueGrey,
            elevation: 5.0,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              child: Text(
                text,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
