// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:pathfinder/Pages/GuidersPage.dart';
import 'package:pathfinder/Pages/HomePage.dart';
import 'package:pathfinder/Pages/MessagesPage.dart';
import 'package:pathfinder/Pages/PlacesPage.dart';
import 'package:pathfinder/app/theme/app_colors.dart';
import 'package:pathfinder/app/theme/app_light_theme.dart';
import 'package:pathfinder/ui/login_screen/view/login_screen.dart';
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
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              Text(
                'Pathfinder',
                style: AppLightTheme().textTheme.subtitle1,
              ),
            ],
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
          color: AppColors.button,
          buttonBackgroundColor: AppColors.button,
          backgroundColor: AppColors.lightBackground,
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
        MaterialPageRoute(builder: (BuildContext context) => LoginScreen()),
        ModalRoute.withName('Login'));
  }
}
