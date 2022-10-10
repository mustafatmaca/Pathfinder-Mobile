import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pathfinder/app/theme/app_colors.dart';
import 'package:pathfinder/app/theme/app_light_theme.dart';
import 'package:pathfinder/ui/greetings_screen/controller/greetings_controller.dart';

class GreetingsScreen extends StatelessWidget {
  final greetingsController = Get.put(GreetingsController());

  final CarouselController _controller = CarouselController();

  GreetingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        top: true,
        right: true,
        bottom: true,
        left: true,
        child: Scaffold(
          body: buildBody(context),
        ));
  }

  buildBody(BuildContext context) {
    return Stack(
      children: [
        Builder(
          builder: (context) {
            final height = MediaQuery.of(context).size.height;
            return CarouselSlider(
              carouselController: _controller,
              options: CarouselOptions(
                height: height,
                viewportFraction: 1,
                enlargeCenterPage: false,
                autoPlay: true,
                onPageChanged: (index, reason) =>
                    {greetingsController.currentPosition.value = index},
              ),
              items: greetingsController.imgList
                  .map((item) => Center(
                        child: Image.network(
                          item,
                          fit: BoxFit.cover,
                          height: height,
                        ),
                      ))
                  .toList(),
            );
          },
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Pathfinder",
                        style: AppLightTheme().textTheme.headline1,
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Text(
                        """Are you ready 
to explore World? """,
                        style: AppLightTheme().textTheme.subtitle1,
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                children: [
                  Obx(
                    () => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: greetingsController.imgList.map((url) {
                        int index = greetingsController.imgList.indexOf(url);
                        return Container(
                          width: 8.0,
                          height: 8.0,
                          margin: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 2.0),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color:
                                  greetingsController.currentPosition.value ==
                                          index
                                      ? AppColors.button
                                      : AppColors.darkBackground),
                        );
                      }).toList(),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        child: const Text('Get Started'),
                        style: ElevatedButton.styleFrom(
                          primary: AppColors.button,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          fixedSize: Size(
                              MediaQuery.of(context).size.width * 0.9,
                              MediaQuery.of(context).size.height * 0.08),
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}
