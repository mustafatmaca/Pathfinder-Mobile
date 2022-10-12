import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pathfinder/app/theme/app_colors.dart';
import 'package:pathfinder/app/theme/app_light_theme.dart';
import 'package:pathfinder/ui/base_screen/controller/base_controller.dart';

class BaseScreen extends StatelessWidget {
  final baseController = Get.put(BaseController());
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  BaseScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      right: true,
      bottom: true,
      left: true,
      child: Scaffold(
        appBar: buildAppBar(),
        body: buildBody(),
        bottomNavigationBar: buildBottomNavigationBar(),
      ),
    );
  }

  buildAppBar() {
    return AppBar(
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          Text(
            'Pathfinder',
            style: AppLightTheme().textTheme.subtitle1,
          ),
        ],
      ),
      actions: <Widget>[
        Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {},
              child: Icon(
                Icons.logout_rounded,
                color: Colors.amber[800],
                size: 26.0,
              ),
            ))
      ],
    );
  }

  buildBody() {
    return Obx(
      () => Center(
        child:
            baseController.pages.elementAt(baseController.selectedIndex.value),
      ),
    );
  }

  buildBottomNavigationBar() {
    return Obx(() => CurvedNavigationBar(
          key: _bottomNavigationKey,
          items: const <Widget>[
            Icon(Icons.home_rounded),
            Icon(Icons.location_city_rounded),
            Icon(Icons.person_search_rounded),
            Icon(Icons.messenger_outline_rounded),
          ],
          index: baseController.selectedIndex.value,
          height: 60,
          color: AppColors.button,
          buttonBackgroundColor: AppColors.button,
          backgroundColor: AppColors.lightBackground,
          animationCurve: Curves.easeInOut,
          animationDuration: const Duration(milliseconds: 400),
          onTap: (index) {
            baseController.selectedIndex.value = index;
          },
        ));
  }
}
