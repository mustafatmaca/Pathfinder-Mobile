import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pathfinder/Entity/City.dart';
import 'package:pathfinder/app/api/api.dart';

class SignUpController extends GetxController {
  String? email, name, phone, cityName, password;
  City? city;

  Api api = const Api();

  var futureCity = Api().fetchCityList("Choose").obs;
}
