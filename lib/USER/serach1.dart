import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place_plus/google_place_plus.dart';
import 'package:location/location.dart' as loc;
import 'package:provider/provider.dart';
import 'package:users/direction.dart';

import 'package:users/firebsae_auth.dart';
import 'package:users/infoHandeler/app_info.dart';

class MainScreen1 extends StatefulWidget {
  const MainScreen1({super.key});

  @override
  State<MainScreen1> createState() => _MainScreen1State();
}

class _MainScreen1State extends State<MainScreen1> {
  bool openNavigationDrawer = false;
  LatLng? pickuplocation;
  LatLng? dropofflocation;
  loc.Location location = loc.Location();
  String? _address;
  

  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(10.8505, 76.2711), // Latitude and Longitude of Kerala, India
    zoom: 14.4746,
  );

  GoogleMapController? newgooglemapcontroller;
  GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

  Position? userCurrentPosition;
  LocationPermission? _locationPermission;

  Set<Marker> markerSet = {};
  Set<Circle> circleSet = {};
  Set<Polyline> polylineSet = {};
  AuthServices authServices = AuthServices();

  // Initialize GooglePlace correctly
  late GooglePlace googlePlace;

  @override
  void initState() {
    super.initState();
    googlePlace = GooglePlace("AIzaSyCN-F_GuqrjgclmIllrMna_vntLdf52KJw");
    checkIfPermissionAllowed();
  }

  Future<void> locateUserPosition() async {
    // Check location permission
    _locationPermission = await Geolocator.checkPermission();
    if (_locationPermission == LocationPermission.denied || _locationPermission == LocationPermission.deniedForever) {
      _locationPermission = await Geolocator.requestPermission();
      if (_locationPermission != LocationPermission.whileInUse && _locationPermission != LocationPermission.always) {
        return; // Permission denied; exit method
      }
    }

    // Get current position
    Position cPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    userCurrentPosition = cPosition;

    LatLng latLngPosition = LatLng(userCurrentPosition!.latitude, userCurrentPosition!.longitude);
    CameraPosition cameraPosition = CameraPosition(target: latLngPosition, zoom: 15);

    // Animate camera to user's current position
    newgooglemapcontroller?.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    if (userCurrentPosition != null) {
      String? humanReadableAddress = await authServices.searchAddressForGeographicCoordinates(userCurrentPosition!, context);
      if (humanReadableAddress != null) {
        setState(() {
          _address = humanReadableAddress;
        });
        print("This is our address: $humanReadableAddress");
      } else {
        print("Failed to get human-readable address");
      }
    } else {
      print("User's current position is null");
    }

    // Get user details
    var userDetails = await authServices.getUserDetails(FirebaseAuth.instance.currentUser!.uid);
    if (userDetails != null) {
      var userName = userDetails['username'];
      var userEmail = userDetails['email'];
      print("Username: $userName, Email: $userEmail");
    }
  }
  Future<void> getAddressFromLatLng() async {
    if (pickuplocation == null) return;

    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        pickuplocation!.latitude,
        pickuplocation!.longitude,
      );
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        setState(() {
          _address = '${place.street}, ${place.locality}, ${place.postalCode}, ${place.country}';

          Direction userPickupAddress = Direction();
          userPickupAddress.locationLatitude = pickuplocation!.latitude;
          userPickupAddress.locationLongitude = pickuplocation!.longitude;
          userPickupAddress.locationName = _address;
          Provider.of<Appinfo>(context, listen: false).updatePickupLocation(userPickupAddress);
        });
      }
    } catch (e) {
      print("Error occurred while getting address: $e");
    }
  }

  Future<void> searchForPlace(String placeName) async {
    var result = await googlePlace.search.getTextSearch(placeName);
    if (result != null && result.results != null && result.results!.isNotEmpty) {
      var place = result.results![0];
      LatLng location = LatLng(place.geometry!.location!.lat!, place.geometry!.location!.lng!);

      setState(() {
        if (pickuplocation == null) {
          pickuplocation = location;
          markerSet.add(Marker(
            markerId: MarkerId('pickupLocation'),
            position: pickuplocation!,
            infoWindow: InfoWindow(title: 'Pickup Location'),
          ));
        } else {
          dropofflocation = location;
          markerSet.add(Marker(
            markerId: MarkerId('dropoffLocation'),
            position: dropofflocation!,
            infoWindow: InfoWindow(title: 'Dropoff Location'),
          ));
          _drawPolyline(pickuplocation!, dropofflocation!);
        }
      });
    }
  }

  void _drawPolyline(LatLng pickup, LatLng dropoff) {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.red,
      points: [pickup, dropoff],
      width: 5,
    );
    setState(() {
      polylineSet.add(polyline);
    });
  }

  Future<void> checkIfPermissionAllowed() async {
    _locationPermission = await Geolocator.requestPermission();
    if (_locationPermission == LocationPermission.denied) {
      _locationPermission = await Geolocator.requestPermission();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: Stack(
          children: [
            GoogleMap(
              mapType: MapType.normal,
              myLocationEnabled: true,
              zoomGesturesEnabled: true,
              zoomControlsEnabled: true,
              polylines: polylineSet,
              markers: markerSet,
              circles: circleSet,
              initialCameraPosition: _kGooglePlex,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
                newgooglemapcontroller = controller;
                locateUserPosition();
              },
            ),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 35.0),
                child: Image.asset('assets/images/map.png', height: 45, width: 45),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(2),
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Row(
                                    children: [
                                      Icon(Icons.location_on_outlined, color: Colors.green),
                                      SizedBox(width: 10),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "From",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                          Provider.of<Appinfo>(context).userPickuplocation != null
                                                ? Provider.of<Appinfo>(context).userPickuplocation!.locationName!.substring(0, 24) + "..."
                                                : "Not Getting address",
                                            style: TextStyle(color: Colors.grey, fontSize: 14),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 5),
                                Divider(
                                  height: 1,
                                  thickness: 2,
                                  color: Colors.grey,
                                ),
                                SizedBox(height: 5),
                                Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Row(
                                    children: [
                                      Icon(Icons.location_on_outlined, color: Colors.red),
                                      SizedBox(width: 10),
                                      Text(
                                        "To",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 22),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      onPressed: () async {
                        String? placeName = await _showPlaceDialog(context, "Search Place");
                        if (placeName != null && placeName.isNotEmpty) {
                          searchForPlace(placeName);
                        }
                      },
                      child: const Text("Search Place"),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String?> _showPlaceDialog(BuildContext context, String title) async {
    TextEditingController searchController = TextEditingController();
    return await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: TextField(
            controller: searchController,
            decoration: InputDecoration(hintText: "Enter place name"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, searchController.text),
              child: Text("Search"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, null),
              child: Text("Cancel"),
            ),
          ],
        );
      },
    );
  }
}
