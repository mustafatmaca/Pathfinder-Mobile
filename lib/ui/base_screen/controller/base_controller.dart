import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pathfinder/Pages/GuidersPage.dart';
import 'package:pathfinder/Pages/HomePage.dart';
import 'package:pathfinder/Pages/MessagesPage.dart';
import 'package:pathfinder/Pages/PlacesPage.dart';

class BaseController extends GetxController {
  var selectedIndex = 0.obs;

  List<Widget> pages = <Widget>[
    HomePage(),
    PlacesPage(),
    GuidersPage(),
    MessagesPage(),
  ];
}
