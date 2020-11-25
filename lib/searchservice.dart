import 'package:cloud_firestore/cloud_firestore.dart';

class SearchService {
  searchByName(String searchField) async {
    return await FirebaseFirestore.instance
        .collection('books')
        .where('searchKey',
            isEqualTo: searchField.substring(0, 1).toUpperCase())
        .get();
  }
}
