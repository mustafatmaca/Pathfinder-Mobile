import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_place/google_place.dart';
import 'package:location/location.dart' as lct;
import 'package:pathfinder/config.dart' as config;
import 'package:pathfinder/API/api.dart';
import 'package:pathfinder/Entity/User.dart';
import 'package:pathfinder/Pages/PlaceDetailPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  double? userLatitude;
  double? userLongitude;

  HomePage({Key? key, this.userLatitude, this.userLongitude}) : super(key: key);

  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  lct.Location location = lct.Location();
  lct.LocationData? currentLocation;
  double? userLatitude;
  double? userLongitude;
  late GooglePlace googlePlace;
  late Future<User> loginUser;
  Api api = const Api();
  List<SearchResult> predictions = [];

  @override
  void initState() {
    super.initState();
    googlePlace = GooglePlace(config.properties['api_key']);
    loginUser = getLoginUser();
    getUserLocation();
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
            FutureBuilder<User>(
              future: loginUser,
              builder: (context, snapshot) {
                if (snapshot.data == null) {
                  return Container(child: Center(child: Icon(Icons.error)));
                }
                return Column(
                  children: [
                    Text(
                      'Welcome ${snapshot.data!.name},',
                      style: GoogleFonts.ubuntu(
                          color: Colors.amber[800],
                          fontSize: 25,
                          decoration: TextDecoration.none),
                    ),
                  ],
                );

                // By default, show a loading spinner.
                return const CircularProgressIndicator();
              },
            ),
          ],
        ),
        const SizedBox(
          height: 12,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              children: [
                Text(
                  'Closest Place To You',
                  style: GoogleFonts.ubuntu(
                      color: Colors.amber[800],
                      fontSize: 18,
                      decoration: TextDecoration.none),
                ),
              ],
            ),
          ],
        ),
        Expanded(
          flex: 1,
          child: Container(
              margin: const EdgeInsets.all(2.0),
              child: ListView.builder(
                  itemCount: predictions.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: Container(
                        height: 100,
                        color: Colors.white,
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                alignment: Alignment.topLeft,
                                child: Column(
                                  children: [
                                    Expanded(
                                      flex: 5,
                                      child: ListTile(
                                        title: Text(
                                          predictions[index].name!,
                                          style: GoogleFonts.ubuntu(
                                              color: Colors.amber[800],
                                              fontSize: 18,
                                              decoration: TextDecoration.none),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 5,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          IconButton(
                                              iconSize: 30.0,
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        PlaceDetailPage(
                                                      placeId:
                                                          predictions[index],
                                                      googlePlace: googlePlace,
                                                    ),
                                                  ),
                                                );
                                              },
                                              icon: Icon(
                                                Icons.navigation_outlined,
                                                color: Colors.black87,
                                              )),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              flex: 8,
                            ),
                          ],
                        ),
                      ),
                      elevation: 1,
                      margin: EdgeInsets.all(20),
                      shape: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide(color: Colors.amber)),
                    );
                  })),
        ),
      ],
    );
  }

  void getUserLocation() async {
    bool serviceEnabled;
    lct.PermissionStatus permissionStatus;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionStatus = await location.hasPermission();
    if (permissionStatus == lct.PermissionStatus.denied) {
      permissionStatus = await location.requestPermission();
      if (permissionStatus != lct.PermissionStatus.granted) {
        return;
      }
    }

    currentLocation = await location.getLocation();
    userLatitude = currentLocation!.latitude;
    userLongitude = currentLocation!.longitude;
    getThreePlace(userLatitude, userLongitude);
  }

  void getThreePlace(userLatitude, userLongitude) async {
    var result = await googlePlace.search.getNearBySearch(
        Location(lat: userLatitude, lng: userLongitude), 1500,
        type: "tourist_attraction");
    if (result != null && result.results != null && mounted) {
      setState(() {
        for (var i = 0; i < result.results!.length; i++) {
          predictions.add(result.results![i]);
        }
        //predictions = result.results!;
      });
    }
  }
}
