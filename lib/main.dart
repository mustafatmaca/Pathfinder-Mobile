import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:pathfinder/app/theme/app_light_theme.dart';
import 'package:pathfinder/app/theme/get_theme.dart';
import 'package:pathfinder/ui/greetings_screen/view/greetings_screen.dart';
import 'package:pathfinder/ui/login_screen/view/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Screens/HomeScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Pathfinder',
      theme: getTheme(AppLightTheme()),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
    with AfterLayoutMixin<SplashScreen> {
  Future checkGreetingsScreen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool check = (prefs.getBool('check') ?? false);
    bool userLogin = (prefs.getBool('userLogin') ?? false);

    //test code
    check = false;

    if (check) {
      if (userLogin) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => const HomeScreen()),
            ModalRoute.withName('Home'));
      } else {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => LoginScreen()));
      }
    } else {
      await prefs.setBool('check', true);
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => GreetingsScreen()));
    }
  }

  @override
  void afterFirstLayout(BuildContext context) => checkGreetingsScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SpinKitDoubleBounce(
          color: Colors.amber,
          size: 50.0,
        ),
      ),
    );
  }
}
