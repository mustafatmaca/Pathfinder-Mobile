import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pathfinder/Entity/City.dart';
import 'package:pathfinder/Entity/User.dart';
import 'package:pathfinder/app/theme/app_colors.dart';
import 'package:pathfinder/app/theme/app_light_theme.dart';
import 'package:pathfinder/core/helper/regex_helper.dart';
import 'package:pathfinder/core/helper/request_helper.dart';
import 'package:pathfinder/ui/login_screen/view/login_screen.dart';
import 'package:pathfinder/ui/sign_up_screen/controller/sign_up_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpScreen extends StatelessWidget {
  final signUpController = Get.put(SignUpController());
  final regexHelper = RegexHelper();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus!.unfocus();
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
      padding: EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Sign Up",
                  style: AppLightTheme().textTheme.headline1,
                )
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
                      children: [
                        TextFormField(
                          key: Key("email"),
                          style: AppLightTheme().textTheme.bodyText2,
                          onSaved: (value) {
                            signUpController.email = value;
                          },
                          validator: (email) {
                            regexHelper.checkEmail(email);
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
                          key: Key("name"),
                          style: AppLightTheme().textTheme.bodyText2,
                          onSaved: (value) {
                            signUpController.name = value;
                          },
                          validator: (name) {
                            regexHelper.checkEmail(name);
                          },
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: AppColors.whiteBacground,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(
                                      width: 1.0, color: AppColors.button)),
                              hintText: 'Name',
                              hintStyle: AppLightTheme().textTheme.bodyText2),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        TextFormField(
                          key: Key("phone"),
                          style: AppLightTheme().textTheme.bodyText2,
                          onSaved: (value) {
                            signUpController.phone = value;
                          },
                          validator: (phone) {
                            regexHelper.checkPhone(phone);
                          },
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: AppColors.whiteBacground,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(
                                      width: 1.0, color: AppColors.button)),
                              hintText: 'Phone',
                              hintStyle: AppLightTheme().textTheme.bodyText2),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        Obx(
                          () => FutureBuilder<List<String>>(
                            future: signUpController.futureCity.value,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return DropdownButtonFormField(
                                  key: Key("city"),
                                  value: signUpController.selectedItem.value,
                                  onChanged: (value) {
                                    signUpController.selectedItem.value =
                                        value.toString();
                                  },
                                  validator: (String? city) {
                                    regexHelper.checkCity(city);
                                  },
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: AppColors.whiteBacground,
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: const BorderSide(
                                            width: 1.0,
                                            color: Color(0xFFFFC107))),
                                  ),
                                  icon:
                                      const Icon(Icons.arrow_downward_outlined),
                                  items: snapshot.data!
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem(
                                      value: value,
                                      child: Text(
                                        value,
                                        style:
                                            AppLightTheme().textTheme.bodyText2,
                                      ),
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
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        TextFormField(
                          key: Key("password"),
                          style: AppLightTheme().textTheme.bodyText2,
                          onSaved: (value) {
                            signUpController.phone = value;
                          },
                          validator: (phone) {
                            regexHelper.checkPassword(phone);
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
                              hintStyle: AppLightTheme().textTheme.bodyText2),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        Row(
                          children: [
                            ElevatedButton(
                              child: const Text('Sign Up'),
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  fixedSize: Size(
                                      MediaQuery.of(context).size.width * 0.92,
                                      MediaQuery.of(context).size.height *
                                          0.08)),
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
                              "Already have an account?",
                              style: AppLightTheme().textTheme.bodyText2,
                            ),
                            InkWell(
                              child: Text(
                                "Sign In",
                                style: AppLightTheme().textTheme.bodyText1,
                              ),
                              onTap: () {
                                Get.to(LoginScreen());
                              },
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
    );
  }
}
