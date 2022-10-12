import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pathfinder/Entity/User.dart';
import 'package:pathfinder/app/api/api.dart';
import 'package:pathfinder/app/theme/app_colors.dart';
import 'package:pathfinder/app/theme/app_light_theme.dart';
import 'package:pathfinder/core/helper/regex_helper.dart';
import 'package:pathfinder/ui/base_screen/view/base_screen.dart';
import 'package:pathfinder/ui/login_screen/controller/login_controller.dart';
import 'package:pathfinder/ui/sign_up_screen/view/sign_up_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatelessWidget {
  final loginController = Get.put(LoginController());
  final regexHelper = RegexHelper();
  final api = Api();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  FormState? formState;

  LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: SafeArea(
        top: true,
        right: true,
        bottom: true,
        left: true,
        child: Scaffold(
          body: buildBody(context),
        ),
      ),
    );
  }

  buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/logo/hare-outlined.png',
                  width: 65,
                  height: 65,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Hi!",
                  style: AppLightTheme().textTheme.headline1,
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
                    key: formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          key: Key("username"),
                          style: AppLightTheme().textTheme.bodyText2,
                          onSaved: (value) {
                            loginController.username = value;
                          },
                          validator: (mail) {
                            regexHelper.checkEmail(mail);
                          },
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: AppColors.whiteBacground,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(
                                      width: 1.0, color: AppColors.button)),
                              hintText: 'Email',
                              hintStyle: AppLightTheme().textTheme.bodyText2),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        TextFormField(
                          key: Key("password"),
                          style: AppLightTheme().textTheme.bodyText2,
                          onSaved: (value) {
                            loginController.password = value;
                          },
                          validator: (password) {
                            regexHelper.checkPassword(password);
                          },
                          obscureText: true,
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: AppColors.whiteBacground,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(
                                      width: 1.0, color: AppColors.button)),
                              hintText: 'Password',
                              hintStyle: AppLightTheme().textTheme.bodyText2,
                              suffixIcon: Icon(Icons.remove_red_eye_outlined)),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 25,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "Recovery Password",
                  style: AppLightTheme().textTheme.bodyText2,
                )
              ],
            ),
            const SizedBox(
              height: 25,
            ),
            Row(
              children: [
                ElevatedButton(
                  child: const Text('Sign In'),
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      fixedSize: Size(MediaQuery.of(context).size.width * 0.92,
                          MediaQuery.of(context).size.height * 0.08)),
                  onPressed: () {
                    checkLogin();
                  },
                ),
              ],
            ),
            const SizedBox(
              height: 25,
            ),
            const Divider(
              thickness: 0.75,
              indent: 16,
              endIndent: 16,
            ),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  child: Icon(Icons.g_mobiledata),
                  style: ElevatedButton.styleFrom(
                      primary: AppColors.whiteBacground,
                      onPrimary: AppColors.button,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      fixedSize: Size(MediaQuery.of(context).size.width * 0.2,
                          MediaQuery.of(context).size.height * 0.1)),
                  onPressed: () {},
                ),
                ElevatedButton(
                  child: const Icon(Icons.face_rounded),
                  style: ElevatedButton.styleFrom(
                      primary: AppColors.whiteBacground,
                      onPrimary: AppColors.button,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      fixedSize: Size(MediaQuery.of(context).size.width * 0.2,
                          MediaQuery.of(context).size.height * 0.1)),
                  onPressed: () {},
                ),
                ElevatedButton(
                  child: const Icon(Icons.ac_unit),
                  style: ElevatedButton.styleFrom(
                      primary: AppColors.whiteBacground,
                      onPrimary: AppColors.button,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      fixedSize: Size(MediaQuery.of(context).size.width * 0.2,
                          MediaQuery.of(context).size.height * 0.1)),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(
              height: 25,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Not a member?",
                  style: AppLightTheme().textTheme.bodyText2,
                ),
                InkWell(
                  child: Text(
                    "Register Now",
                    style: AppLightTheme().textTheme.bodyText1,
                  ),
                  onTap: () {
                    Get.to(SignUpScreen());
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> checkLogin() async {
    formState = formKey.currentState;
    if (!formState!.validate()) {
      const SnackBar(content: Text('Please fix the errors.'));
    } else {
      formState!.save();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      Future<User> futureUser =
          api.checkLogin(loginController.username, loginController.password);
      futureUser.then((value) => value.id == null
          ? const SnackBar(content: Text("Wrong User"))
          : Get.to(() => BaseScreen()));
      prefs.setString('userEmail', loginController.username!);
      prefs.setBool('userLogin', true);
    }
  }
}
