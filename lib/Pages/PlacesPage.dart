import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_place/google_place.dart';
import 'package:pathfinder/config.dart' as config;
import 'package:pathfinder/API/api.dart';
import 'package:pathfinder/Entity/City.dart';
import 'package:pathfinder/Entity/User.dart';
import 'package:pathfinder/Pages/PlaceDetailPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlacesPage extends StatefulWidget {
  const PlacesPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => PlacesPageState();
}

class PlacesPageState extends State<PlacesPage> {
  late GooglePlace googlePlace;
  late Future<User> loginUser;
  City? city;
  Api api = const Api();
  List<SearchResult> predictions = [];

  @override
  void initState() {
    googlePlace = GooglePlace(config.properties['api_key']);
    loginUser = getLoginUser();
    autoCompleteSearch();
    super.initState();
  }

  Future<User> getLoginUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return loginUser = api.getUser(prefs.getString('userEmail'));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 12,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Places',
              style: GoogleFonts.ubuntu(
                  color: Colors.amber[800],
                  fontSize: 25,
                  decoration: TextDecoration.none),
            ),
          ],
        ),
        const SizedBox(
          height: 12,
        ),
        Expanded(
          flex: 1,
          child: Container(
              margin: const EdgeInsets.all(2.0),
              child: ListView.builder(
                  itemCount: predictions.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                        dense: true,
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size: 12,
                          color: Colors.amber[800],
                        ),
                        title: Text(
                          predictions[index].name!,
                          style: GoogleFonts.ubuntu(
                              color: Colors.amber[800],
                              fontSize: 18,
                              decoration: TextDecoration.none),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PlaceDetailPage(
                                placeId: predictions[index],
                                googlePlace: googlePlace,
                              ),
                            ),
                          );
                        });
                  })),
        ),
      ],
    );
  }

  void autoCompleteSearch() async {
    await loginUser
        .then((value) async => city = await api.fetchCity(value.city['name']));
    var result = await googlePlace.search.getNearBySearch(
        Location(lat: city!.latitude, lng: city!.longitude), 1500,
        type: "tourist_attraction");
    if (result != null && result.results != null && mounted) {
      setState(() {
        predictions = result.results!;
        inspect(predictions[9]);
      });
    }
  }
}
