import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:pathfinder/config.dart' as config;

class NavigationPage extends StatefulWidget {
  final double? destinationLatitude;
  final double? destinationLongitude;
  final String? destinationName;

  NavigationPage(
      {Key? key,
      required this.destinationLatitude,
      required this.destinationLongitude,
      required this.destinationName})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => NavigationPageState(
      this.destinationLatitude,
      this.destinationLongitude,
      this.destinationName);
}

class NavigationPageState extends State<NavigationPage> {
  Location location = Location();
  LocationData? currentLocation;
  CameraPosition _initialLocation = CameraPosition(target: LatLng(0.0, 0.0));
  BitmapDescriptor locationIcon = BitmapDescriptor.defaultMarker;

  double? userLatitude;
  double? userLongitude;
  final double? destinationLatitude;
  final double? destinationLongitude;
  final String? destinationName;

  List<LatLng> polylineCoordinates = [];
  Map<PolylineId, Polyline> polylines = {};
  late PolylinePoints polylinePoints;

  Set<Marker> markers = {};

  late GoogleMapController mapController;

  NavigationPageState(this.destinationLatitude, this.destinationLongitude,
      this.destinationName);

  @override
  void initState() {
    super.initState();
    getUserLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          GoogleMap(
            markers: Set<Marker>.from(markers),
            initialCameraPosition: _initialLocation,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            mapType: MapType.normal,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: false,
            polylines: Set<Polyline>.of(polylines.values),
            onMapCreated: (GoogleMapController controller) {
              mapController = controller;
            },
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 10.0, bottom: 10.0),
                child: ClipOval(
                  child: Material(
                    color: Colors.orange.shade100, // button color
                    child: InkWell(
                      splashColor: Colors.amber[800], // inkwell color
                      child: SizedBox(
                        width: 56,
                        height: 56,
                        child: Icon(Icons.my_location),
                      ),
                      onTap: () {
                        mapController.animateCamera(
                          CameraUpdate.newCameraPosition(
                            CameraPosition(
                              target: LatLng(
                                userLatitude!,
                                userLongitude!,
                              ),
                              zoom: 18.0,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  child: const Text('Navigate'),
                  style: ElevatedButton.styleFrom(
                      primary: Colors.amber[800],
                      onPrimary: Colors.black87,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      fixedSize: const Size(150, 25)),
                  onPressed: () {
                    setState(() {
                      getUserLocation();
                    });
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void getUserLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionStatus;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionStatus = await location.hasPermission();
    if (permissionStatus == PermissionStatus.denied) {
      permissionStatus = await location.requestPermission();
      if (permissionStatus != PermissionStatus.granted) {
        return;
      }
    }

    currentLocation = await location.getLocation();
    userLatitude = currentLocation!.latitude;
    userLongitude = currentLocation!.longitude;
    mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(userLatitude!, userLongitude!), zoom: 18.0)));
    drawingRoute(
        userLatitude, userLongitude, destinationLatitude, destinationLongitude);
    await _createPolylines(
        userLatitude, userLongitude, destinationLatitude, destinationLongitude);
  }

  drawingRoute(
      userLatitude, userLongitude, destinationLatitude, destinationLongitude) {
    Marker startMarker = Marker(
        markerId: MarkerId("Start Coordinates"),
        position: LatLng(userLatitude, userLongitude),
        infoWindow: InfoWindow(
          title: "Your Location",
          snippet: "Your Location",
        ),
        icon: locationIcon,
        visible: true);

    // Destination Location Marker
    Marker destinationMarker = Marker(
        markerId: MarkerId("Destination Coordinates"),
        position: LatLng(destinationLatitude, destinationLongitude),
        infoWindow: InfoWindow(
          title: destinationName,
          snippet: destinationName,
        ),
        icon: locationIcon,
        visible: true);

    // Adding the markers to the list
    markers.add(startMarker);
    markers.add(destinationMarker);

    double miny = (userLatitude <= destinationLatitude)
        ? userLatitude
        : destinationLatitude;
    double minx = (userLongitude <= destinationLongitude)
        ? userLongitude
        : destinationLongitude;
    double maxy = (userLatitude <= destinationLatitude)
        ? destinationLatitude
        : userLatitude;
    double maxx = (userLongitude <= destinationLongitude)
        ? destinationLongitude
        : userLongitude;

    double southWestLatitude = miny;
    double southWestLongitude = minx;

    double northEastLatitude = maxy;
    double northEastLongitude = maxx;

    // Accommodate the two locations within the
    // camera view of the map
    mapController.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          northeast: LatLng(northEastLatitude, northEastLongitude),
          southwest: LatLng(southWestLatitude, southWestLongitude),
        ),
        100.0,
      ),
    );
  }

  _createPolylines(
    double? userLatitude,
    double? userLongitude,
    double? destinationLatitude,
    double? destinationLongitude,
  ) async {
    polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      config.properties['api_key'], // Google Maps API Key
      PointLatLng(userLatitude!, userLongitude!),
      PointLatLng(destinationLatitude!, destinationLongitude!),
      travelMode: TravelMode.transit,
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }

    PolylineId id = PolylineId('poly');
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.amber,
      points: polylineCoordinates,
      width: 5,
    );
    polylines[id] = polyline;
  }
}
