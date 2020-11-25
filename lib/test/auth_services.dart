import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  User user = FirebaseAuth.instance.currentUser;
  String name;
  String contact;

  void getUserDetail() async {
    await _firestore
        .collection('users')
        .doc(user.uid)
        .get()
        .then((value) => name = value.data()['Name']);
    await _firestore
        .collection('users')
        .doc(user.uid)
        .get()
        .then((value) => contact = value.data()['Contact']);
  }

  // Stream<String> get onAuthStateChange =>
  //     _auth.authStateChanges().map((User user) => user?.uid);

  Future<String> createUserWithEmailAndPassword(
      String email, String password, String name, String contactNumber) async {
    final currentUser = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);

    user = FirebaseAuth.instance.currentUser;

    _firestore.collection('Users').doc(user.uid).set({
      'userid': user.uid,
      'Name': name,
      'Contact': contactNumber,
    });
    return user.uid;
  }
}

// class AuthenticationService {
//   final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
//   ...
//   Future<bool> isUserLoggedIn() async {
//     var user = await _firebaseAuth.currentUser();
//     return user != null;
//   }
// }
