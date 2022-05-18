// ignore_for_file: camel_case_types

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pathfinder/Entity/City.dart';
import 'package:pathfinder/Entity/Message.dart';
import 'package:pathfinder/Entity/User.dart';

class Api {
  const Api();

  Future<List<String>> fetchCityList(String dropDownValue) async {
    final response = await http
        .get(Uri.parse('https://pathfinder-mobile.herokuapp.com/Cities/'));
    var data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      List<String> cities = [];
      for (var i in data) {
        City city = City(
            id: i["id"],
            name: i["name"],
            latitude: i["latitude"],
            longitude: i["longitude"]);
        cities.add(city.name);
      }
      cities.add(dropDownValue);
      return cities;
    } else {
      throw Exception('Failed');
    }
  }

  Future<City> fetchCity(String? city) async {
    final response = await http
        .get(Uri.parse('https://pathfinder-mobile.herokuapp.com/Cities/$city'));
    var data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      City city = City(
          id: data["id"],
          name: data["name"],
          latitude: data["latitude"],
          longitude: data["longitude"]);
      return city;
    } else {
      throw Exception('Failed');
    }
  }

  Future<List<User>> fetchGuider() async {
    final response = await http.get(Uri.parse(
        'https://pathfinder-mobile.herokuapp.com/Users/Guiders/guiders'));
    var data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      List<User> guiders = [];
      for (var i in data) {
        User guider = User(
            id: i["id"],
            mail: i["mail"],
            password: i["password"],
            name: i["name"],
            gsm: i["gsm"],
            role: i["role"],
            city: i["city"],
            messages: i["messages"]);
        guiders.add(guider);
      }
      return guiders;
    } else {
      throw Exception('Failed');
    }
  }

  Future<List<Message>> fetchMessage() async {
    final response = await http
        .get(Uri.parse('https://pathfinder-mobile.herokuapp.com/Messages/'));
    var data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      List<Message> messages = [];
      for (var i in data) {
        Message message = Message(
            id: i["id"],
            sender: i["sender"],
            toUser: i["toUser"],
            context: i["context"]);
        messages.add(message);
      }
      return messages;
    } else {
      throw Exception('Failed');
    }
  }

  Future<User> checkLogin(String? mail, String? password) async {
    final response = await http.get(Uri.parse(
        'https://pathfinder-mobile.herokuapp.com/Users/$mail/$password'));
    var data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      User user = User(
          id: data["id"],
          mail: data["mail"],
          password: data["password"],
          name: data["name"],
          gsm: data["gsm"],
          role: data["role"],
          city: data["city"],
          messages: data["messages"]);
      return user;
    } else {
      throw Exception('Failed');
    }
  }

  Future<User> getUser(String? mail) async {
    final response = await http
        .get(Uri.parse('https://pathfinder-mobile.herokuapp.com/Users/$mail'));
    var data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      User user = User(
          id: data["id"],
          mail: data["mail"],
          password: data["password"],
          name: data["name"],
          gsm: data["gsm"],
          role: data["role"],
          city: data["city"],
          messages: data["messages"]);
      return user;
    } else {
      throw Exception('Failed');
    }
  }

  Future<User> createUser(
      String? email, name, phone, password, City? city) async {
    final response = await http.post(
      Uri.parse('https://pathfinder-mobile.herokuapp.com/Users/'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "id": null,
        "mail": email,
        "password": password.toString(),
        "name": name,
        "gsm": phone,
        "role": "tourist",
        "city": city!.toJson(),
        "messages": null,
      }),
    );

    String responseString = response.body;
    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed');
    }
  }
}
