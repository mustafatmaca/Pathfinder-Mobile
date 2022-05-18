import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pathfinder/API/api.dart';
import 'package:pathfinder/Entity/User.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'HomeScreen.dart';
import 'SignUpScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? username, password;
  late Future<User> futureUser;
  Api api = const Api();

  String pattern =
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
      r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
      r"{0,253}[a-zA-Z0-9])?)*$";

  @override
  void initState() {
    super.initState();
    futureUser = api.checkLogin(username, password);
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/logo/hare-outlined.png',
                      width: 100,
                      height: 100,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Pathfinder',
                      style: GoogleFonts.ubuntu(
                          color: Colors.amber[800],
                          fontSize: 20,
                          decoration: TextDecoration.none),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Hi!",
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
                              key: Key("username"),
                              onSaved: (value) {
                                username = value;
                              },
                              validator: (mail) {
                                RegExp regex = RegExp(pattern);
                                if (mail == null ||
                                    mail.isEmpty ||
                                    !regex.hasMatch(mail)) {
                                  return 'Please enter a valid email';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      gapPadding: 10.0,
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: const BorderSide(
                                          width: 1.0,
                                          color: Color(0xFFFFC107))),
                                  prefixIcon: Icon(
                                    Icons.mail_outline,
                                    color: Colors.amber[800],
                                  ),
                                  hintText: 'Email'),
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            TextFormField(
                              key: Key("password"),
                              onSaved: (value) {
                                password = value;
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
                                  prefixIcon: Icon(
                                    Icons.lock_outline,
                                    color: Colors.amber[800],
                                  ),
                                  hintText: 'Password'),
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: ElevatedButton(
                                child: const Text('Sign In'),
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
                                onPressed: checkLogin,
                              ),
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Don't have an account?",
                                  style: GoogleFonts.ubuntu(
                                      color: Colors.black54,
                                      fontSize: 16,
                                      decoration: TextDecoration.none),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                const SignUpScreen()));
                                  },
                                  child: Text(
                                    " Sign Up",
                                    style: GoogleFonts.ubuntu(
                                        color: Colors.amber[800],
                                        fontSize: 16,
                                        decoration: TextDecoration.none),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                InkWell(
                                  child: Text(
                                    "Forgot your password?",
                                    style: GoogleFonts.ubuntu(
                                        color: Colors.amber[800],
                                        fontSize: 16,
                                        decoration: TextDecoration.none),
                                  ),
                                )
                              ],
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

  Future<void> checkLogin() async {
    final FormState? form = _formKey.currentState;
    if (!form!.validate()) {
      const SnackBar(content: Text('Please fix the errors.'));
    } else {
      form.save();
      futureUser = api.checkLogin(username, password);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('userLogin', true);
      futureUser.then((value) => prefs.setString('userEmail', value.mail!));
      futureUser.then((value) => Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => const HomeScreen()),
          ModalRoute.withName('Home')));
    }
  }
}
