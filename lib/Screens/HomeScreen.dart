// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:pathfinder/Pages/GuidersPage.dart';
import 'package:pathfinder/Pages/HomePage.dart';
import 'package:pathfinder/Pages/MessagesPage.dart';
import 'package:pathfinder/Pages/PlacesPage.dart';
import 'package:pathfinder/Screens/LoginScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  static final List<Widget> _pages = <Widget>[
    HomePage(),
    PlacesPage(),
    GuidersPage(),
    MessagesPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Image.asset(
              'assets/logo/hare-outlined.png',
              width: 20,
              height: 20,
            ),
          ),
          title: Text(
            'Pathfinder',
          ),
          actions: <Widget>[
            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {
                    logout();
                  },
                  child: Icon(
                    Icons.logout_rounded,
                    color: Colors.amber[800],
                    size: 26.0,
                  ),
                ))
          ],
        ),
        body: Center(
          child: _pages.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: CurvedNavigationBar(
          key: _bottomNavigationKey,
          items: const <Widget>[
            Icon(Icons.home_rounded),
            Icon(Icons.location_city_rounded),
            Icon(Icons.person_search_rounded),
            Icon(Icons.messenger_outline_rounded),
          ],
          index: _selectedIndex,
          height: 60,
          color: Colors.amber[800]!,
          buttonBackgroundColor: Colors.amber[800],
          backgroundColor: Colors.white,
          animationCurve: Curves.easeInOut,
          animationDuration: const Duration(milliseconds: 400),
          onTap: _onItemTapped,
        ));
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('userLogin', false);
    prefs.setString('userEmail', "");
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => const LoginScreen()),
        ModalRoute.withName('Login'));
  }
}
