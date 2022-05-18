import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pathfinder/API/api.dart';
import 'package:pathfinder/Entity/City.dart';
import 'package:pathfinder/Entity/User.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'HomeScreen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? email, name, phone, cityName, password;
  City? city;
  String dropDownValue = 'Choose';
  late Future<List<String>> futureCity;
  Api api = const Api();

  String pattern =
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
      r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
      r"{0,253}[a-zA-Z0-9])?)*$";

  @override
  void initState() {
    super.initState();
    futureCity = api.fetchCityList(dropDownValue);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Sign Up",
                      style: GoogleFonts.ubuntu(
                          color: Colors.amber[800],
                          fontSize: 32,
                          decoration: TextDecoration.none),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 25,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            TextFormField(
                              key: Key("email"),
                              onSaved: (newValue) {
                                email = newValue;
                              },
                              validator: (email) {
                                RegExp regex = RegExp(pattern);
                                if (email == null ||
                                    email.isEmpty ||
                                    !regex.hasMatch(email)) {
                                  return 'Please enter a valid email';
                                }
                              },
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      gapPadding: 10.0,
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: const BorderSide(
                                          width: 1.0,
                                          color: Color(0xFFFFC107))),
                                  hintText: 'Email'),
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            TextFormField(
                              key: Key("name"),
                              onSaved: (newValue) {
                                name = newValue;
                              },
                              validator: (name) {
                                if (name == null || name.isEmpty) {
                                  return 'Please enter your name';
                                }
                              },
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      gapPadding: 10.0,
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: const BorderSide(
                                          width: 1.0,
                                          color: Color(0xFFFFC107))),
                                  hintText: 'Name'),
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            TextFormField(
                              key: Key("phone"),
                              onSaved: (newValue) {
                                phone = newValue;
                              },
                              validator: (phone) {
                                if (phone == null || phone.isEmpty) {
                                  return 'Please enter your phone';
                                }
                              },
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      gapPadding: 10.0,
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: const BorderSide(
                                          width: 1.0,
                                          color: Color(0xFFFFC107))),
                                  hintText: 'Phone'),
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            FutureBuilder<List<String>>(
                              future: futureCity,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return DropdownButtonFormField(
                                    key: Key("city"),
                                    onSaved: (String? newValue) {
                                      cityName = newValue;
                                    },
                                    validator: (String? city) {
                                      if (city == null || city == "Choose") {
                                        return 'Please select your city';
                                      }
                                    },
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          gapPadding: 10.0,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          borderSide: const BorderSide(
                                              width: 1.0,
                                              color: Color(0xFFFFC107))),
                                    ),
                                    value: dropDownValue,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        dropDownValue = newValue!;
                                      });
                                    },
                                    icon: const Icon(
                                        Icons.arrow_downward_outlined),
                                    items: snapshot.data!
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  );
                                } else if (snapshot.hasError) {
                                  return Text('${snapshot.error}');
                                }

                                // By default, show a loading spinner.
                                return const CircularProgressIndicator();
                              },
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            TextFormField(
                              key: Key("password"),
                              onSaved: (newValue) {
                                password = newValue;
                              },
                              validator: (password) {
                                if (password == null || password.isEmpty) {
                                  return 'Please enter your password';
                                }
                              },
                              obscureText: true,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      gapPadding: 10.0,
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: const BorderSide(
                                          width: 1.0,
                                          color: Color(0xFFFFC107))),
                                  hintText: 'Password'),
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: ElevatedButton(
                                child: const Text('Sign Up'),
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.amber[800],
                                    onPrimary: Colors.black87,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    textStyle: GoogleFonts.ubuntu(
                                      fontSize: 16,
                                    ),
                                    fixedSize: const Size(355, 50)),
                                onPressed: createUser,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> createUser() async {
    final FormState? form = _formKey.currentState;
    if (!form!.validate()) {
      const SnackBar(content: Text("Please fix the errors."));
    } else {
      form.save();
      City apiCity = await api.fetchCity(cityName);
      inspect(apiCity);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('userLogin', true);
      prefs.setString('userEmail', email!);

      User response =
          await api.createUser(email, name, phone, password, apiCity);
      if (response != null) {
        inspect(response);
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => const HomeScreen()),
            ModalRoute.withName('Home'));
      }
    }
  }
}
