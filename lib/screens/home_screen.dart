import 'package:buysellbooks/accountscreen/store_screen.dart';
import 'package:buysellbooks/constants.dart';
import 'package:buysellbooks/courses/engineering.dart';
import 'package:buysellbooks/department/civil_depart.dart';
import 'package:buysellbooks/department/computer_depart.dart';
import 'package:buysellbooks/department/entc_depart.dart';
import 'package:buysellbooks/department/mechanical_depart.dart';
import 'package:buysellbooks/accountscreen/personal_info.dart';
import 'package:buysellbooks/test/datastore.dart';
import 'package:buysellbooks/sellingscreen/selling_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  static const String id = 'home_screen';

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Home Page'),
          bottom: TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.shop),
                text: 'Buy',
              ),
              Tab(
                icon: Icon(Icons.store),
                text: 'Sell',
              ),
              Tab(
                icon: Icon(Icons.account_circle),
                text: 'Account',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Container(
              // color: Colors.black,
              padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: 5.0,
                    ),
                    ButtonCourse(
                      image: 'images/computer_engineering.jpg',
                      text: 'COMPUTER',
                      onTap: () {
                        Navigator.pushNamed(context, ComputerDepartment.id);
                      },
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    ButtonCourse(
                        image: 'images/mechanical_engineering.jpg',
                        text: 'MECHANICAL',
                        onTap: () {
                          Navigator.pushNamed(context, MechanicalDepartment.id);
                        }),
                    SizedBox(
                      height: 10.0,
                    ),
                    ButtonCourse(
                        image: 'images/entc_engineering.jpg',
                        text: 'ENTC',
                        onTap: () {
                          Navigator.pushNamed(context, ENTCDepartment.id);
                        }),
                    SizedBox(
                      height: 10.0,
                    ),
                    ButtonCourse(
                        image: 'images/civil_engineering.jpg',
                        text: 'CIVIL',
                        onTap: () {
                          Navigator.pushNamed(context, CivilDepartment.id);
                        }),
                  ],
                ),
              ),
            ),
            Container(
              // color: Colors.black,
              padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: 5.0,
                    ),
                    SellBooks(
                      image: 'images/sellbooks.jpg',
                      text: 'SELL YOUR BOOKS',
                      // onTap: () {
                      //   Navigator.pushNamed(context, Engineering.id);
                      // },
                    ),
                    // SizedBox(
                    //   height: 10.0,
                    // ),
                    // SellBooks(
                    //   image: 'images/mechanical_engineering.jpg',
                    //   text: 'MECHANICAL',
                    // ),
                    // SizedBox(
                    //   height: 10.0,
                    // ),
                    // SellBooks(
                    //   image: 'images/entc_engineering.jpg',
                    //   text: 'ENTC',
                    // ),
                    // SizedBox(
                    //   height: 10.0,
                    // ),
                    // SellBooks(
                    //   image: 'images/civil_engineering.jpg',
                    //   text: 'CIVIL',
                    // )
                  ],
                ),
              ),
            ),
            Container(
              // color: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 5.0,
                  ),
                  AccountDetails(
                    image: 'images/profile_background.jpg',
                    text: 'Personal Info',
                    onTap: () {
                      Navigator.pushNamed(context, PersonalInfo.id);
                    },
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  AccountDetails(
                    image: 'images/your_store.jpg',
                    text: 'Store',
                    onTap: () {
                      Navigator.pushNamed(context, StoreScreen.id);
                    },
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  AccountDetails(
                    image: 'images/cart.jpg',
                    text: 'Cart',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ButtonCourse extends StatelessWidget {
  final String image;
  final String text;

  final Function onTap;

  ButtonCourse({Key key, this.image, this.text, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      //     () {
      //   Navigator.pushNamed(context, Engineering.id);
      // },
      child: Container(
        height: 120.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          image: DecorationImage(
            image: AssetImage(image),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: kInkWellTextStyle,
          ),
        ),
      ),
    );
  }
}

class AccountDetails extends StatelessWidget {
  final String image;
  final String text;
  final Function onTap;

  AccountDetails({Key key, this.image, this.text, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 150.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          image: DecorationImage(
            image: AssetImage(image),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: kInkWellTextStyle,
          ),
        ),
      ),
    );
  }
}

class SellBooks extends StatelessWidget {
  final String image;
  final String text;
  // final Function onTap;

  SellBooks({Key key, this.image, this.text});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, SellingScreen.id);
      },
      child: Container(
        height: 170.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          image: DecorationImage(
            image: AssetImage(image),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: kInkWellTextStyle,
          ),
        ),
      ),
    );
  }
}
