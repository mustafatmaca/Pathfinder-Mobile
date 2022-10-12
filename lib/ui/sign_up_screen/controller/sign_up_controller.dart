import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pathfinder/Entity/City.dart';
import 'package:pathfinder/app/api/api.dart';
import 'package:pathfinder/core/helper/request_helper.dart';

class SignUpController extends GetxController {
  String? email, name, phone, cityName, password;
  City? city;

  var selectedItem = "Choose".obs;

  var futureCity = RequestHelper().getCityList("Choose").obs;
}
