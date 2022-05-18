import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'LoginScreen.dart';

int currentPosition = 0;
final List<String> imgList = [
  'https://cdn.pixabay.com/photo/2020/09/27/08/47/castle-5606120_960_720.jpg',
  'https://cdn.pixabay.com/photo/2020/01/20/17/24/india-4780852_960_720.jpg',
  'https://cdn.pixabay.com/photo/2013/07/08/20/35/eiffel-tower-144023_960_720.jpg'
];

class GreetingsScreen extends StatefulWidget {
  const GreetingsScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _GreetingsScreenState();
}

class _GreetingsScreenState extends State<GreetingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Builder(builder: (context) {
          final double height = MediaQuery.of(context).size.height;
          return CarouselSlider(
            options: CarouselOptions(
              height: height,
              viewportFraction: 1,
              enlargeCenterPage: false,
              autoPlay: true,
              onPageChanged: (index, reason) => {
                setState(() {
                  currentPosition = index;
                })
              },
            ),
            items: imgList
                .map((item) => Center(
                        child: Image.network(
                      item,
                      fit: BoxFit.cover,
                      height: height,
                    )))
                .toList(),
          );
        }),
        Positioned(
          top: 50,
          left: 20,
          child: Text(
            "Pathfinder",
            style: GoogleFonts.ubuntu(
                color: Colors.amber[800],
                fontSize: 32,
                decoration: TextDecoration.none),
          ),
        ),
        Positioned(
          top: 160,
          left: 20,
          child: Text(
            """Are you ready 
to explore World? """,
            style: GoogleFonts.ubuntu(
                color: Colors.amber[800],
                fontSize: 32,
                decoration: TextDecoration.none),
          ),
        ),
        Positioned(
          bottom: 150,
          right: 188,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: imgList.map((url) {
              int index = imgList.indexOf(url);
              return Container(
                width: 8.0,
                height: 8.0,
                margin:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: currentPosition == index
                        ? Colors.amber[800]
                        : Colors.black45),
              );
            }).toList(),
          ),
        ),
        Positioned(
          bottom: 75,
          right: 29,
          child: ElevatedButton(
            child: const Text('Get Started'),
            style: ElevatedButton.styleFrom(
              primary: Colors.amber[800],
              onPrimary: Colors.black87,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              textStyle: GoogleFonts.ubuntu(
                fontSize: 16,
              ),
              fixedSize: const Size(350, 50),
            ),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => const LoginScreen()),
                  ModalRoute.withName('Login'));
            },
          ),
        )
      ],
    );
  }
}
