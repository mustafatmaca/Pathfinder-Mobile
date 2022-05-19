import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_place/google_place.dart';
import 'package:pathfinder/Pages/NavigationPage.dart';

class PlaceDetailPage extends StatefulWidget {
  final SearchResult placeId;
  final GooglePlace googlePlace;

  const PlaceDetailPage(
      {Key? key, required this.placeId, required this.googlePlace})
      : super(key: key);

  @override
  State<StatefulWidget> createState() =>
      PlaceDetailPageState(this.placeId, this.googlePlace);
}

class PlaceDetailPageState extends State<PlaceDetailPage> {
  final SearchResult placeId;
  final GooglePlace googlePlace;

  PlaceDetailPageState(this.placeId, this.googlePlace);

  late DetailsResult detailsResult;
  List<Uint8List> images = [];

  @override
  void initState() {
    super.initState();
    getPhoto();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${placeId.name}",
          style: GoogleFonts.ubuntu(
              color: Colors.amber[800],
              fontSize: 18,
              decoration: TextDecoration.none),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.amber,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.only(right: 20, left: 20, top: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: images.length,
                  itemBuilder: (context, index) {
                    return Container(
                      width: 370,
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Image.memory(
                            images[index],
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: ListView(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(left: 15, top: 10),
                        child: Text(
                          "Details",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      placeId != null && placeId.types != null
                          ? Container(
                              margin: EdgeInsets.only(left: 15, top: 10),
                              height: 50,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: placeId.types!.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    margin: EdgeInsets.only(right: 10),
                                    child: Chip(
                                      label: Text(
                                        placeId.types![index],
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                      backgroundColor: Colors.amber[800],
                                    ),
                                  );
                                },
                              ),
                            )
                          : Container(),
                      Container(
                        margin: const EdgeInsets.only(left: 15, top: 10),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.amber[800],
                            child: Icon(Icons.location_on, color: Colors.black),
                          ),
                          title: Text('${placeId.vicinity}'),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 15, top: 10),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.amber[800],
                            child: Icon(Icons.star_rate_rounded,
                                color: Colors.black),
                          ),
                          title: Text('Ratings: ${placeId.rating.toString()}'),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 15, top: 10),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.amber[800],
                            child: Icon(Icons.timelapse, color: Colors.black),
                          ),
                          title: Text(
                            placeId.openingHours != null
                                ? 'Open Now: ${placeId.openingHours?.openNow.toString()}'
                                : 'Open Now: No info',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  child: const Text('Navigate'),
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
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NavigationPage(
                          destinationLatitude: placeId.geometry!.location!.lat,
                          destinationLongitude: placeId.geometry!.location!.lng,
                          destinationName: placeId.name,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void getPhoto() async {
    var firstResult = await this.googlePlace.photos.get(
        placeId.photos!.first.photoReference!,
        placeId.photos!.first.height!,
        placeId.photos!.first.width!);

    if (firstResult != null && mounted) {
      setState(() {
        images.add(firstResult);
      });
    }
  }
}
