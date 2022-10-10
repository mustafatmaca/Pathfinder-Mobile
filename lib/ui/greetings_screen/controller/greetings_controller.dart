import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GreetingsController extends GetxController {
  final List<String> imgList = [
    'https://cdn.pixabay.com/photo/2020/09/27/08/47/castle-5606120_960_720.jpg',
    'https://cdn.pixabay.com/photo/2020/01/20/17/24/india-4780852_960_720.jpg',
    'https://cdn.pixabay.com/photo/2013/07/08/20/35/eiffel-tower-144023_960_720.jpg'
  ];

  var currentPosition = 0.obs;
}
