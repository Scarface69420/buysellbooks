import 'package:buysellbooks/accountscreen/store_screen.dart';
import 'package:buysellbooks/courses/engineering.dart';
import 'package:buysellbooks/department/civil_depart.dart';
import 'package:buysellbooks/department/computer_depart.dart';
import 'package:buysellbooks/department/entc_depart.dart';
import 'package:buysellbooks/department/mechanical_depart.dart';
import 'package:buysellbooks/screens/home_screen.dart';
import 'package:buysellbooks/accountscreen/personal_info.dart';
import 'package:buysellbooks/test/datastore.dart';
import 'package:buysellbooks/sellingscreen/selling_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:buysellbooks/screens/login_screen.dart';
import 'package:buysellbooks/screens/registration_screen.dart';
import 'package:buysellbooks/screens/welcome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(BuySellBooks());
}

class BuySellBooks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // String screen = logIn() != null ? 'WelcomeScreen.id' : 'HomeScreen.id';
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        primaryColor: Color(0xFF0A0F30),
        scaffoldBackgroundColor: Color(0xFF0A0E21),
      ),
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        HomeScreen.id: (context) => HomeScreen(),
        Engineering.id: (context) => Engineering(),
        BookStream.id: (context) => BookStream(),
        SellingScreen.id: (context) => SellingScreen(),
        PersonalInfo.id: (context) => PersonalInfo(),
        ComputerDepartment.id: (context) => ComputerDepartment(),
        MechanicalDepartment.id: (context) => MechanicalDepartment(),
        ENTCDepartment.id: (context) => ENTCDepartment(),
        CivilDepartment.id: (context) => CivilDepartment(),
        StoreScreen.id: (context) => StoreScreen(),
      },
    );
  }
}

// Future<dynamic> logIn() async {
//   prefs = await SharedPreferences.getInstance();
//   var email = prefs.getString('email');
//   print(email);
//   if (email != null) {
//     return email;
//   }
// }
