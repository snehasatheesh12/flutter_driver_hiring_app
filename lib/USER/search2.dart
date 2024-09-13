import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:users/direction.dart';
import 'package:users/firebsae_auth.dart';
import 'package:users/infoHandeler/app_info.dart';

class MainScreen4 extends StatefulWidget {
  const MainScreen4({super.key});

  @override
  State<MainScreen4> createState() => _MainScreen4State();
}
  
class _MainScreen4State extends State<MainScreen4> {
  LatLng? pickuplocation;
  LatLng? dropofflocation;
  MapController mapController = MapController();
  String? _address;
  AuthServices authServices = AuthServices();
  Position? userCurrentPosition;
  LocationPermission? _locationPermission;
  String? _searchedPlace = "Where to?";


  Set<Marker> markerSet = {};
  late List<Marker> markers = [];
    List<LatLng> polylinePoints = [];

  
@override
  void setState(VoidCallback fn) {
    _drawLineBetweenPickupAndDropoff();
    super.setState(fn);
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
            FlutterMap(
              
              mapController: mapController,
              options: MapOptions(
                initialCenter: LatLng(10.8505, 76.2711),
                initialZoom:13.0 ,
                onTap: (tapPosition, point) {
                  setState(() {
                    pickuplocation = point;
                    markers.add(
                      Marker(
                        point: point,
                        child: Builder(builder: (context) => Icon(Icons.location_on, color: Colors.blue, size: 40),)
                      ),
                    );
                  });
                },
              ),
              children: [
                TileLayer(
                  urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c'],
                ),
               MarkerLayer(markers: markers.toList()),
                if (polylinePoints.isNotEmpty)
            
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: polylinePoints,
                        color: const Color.fromARGB(255, 8, 9, 9),
                        strokeWidth: 4.0,
                      ),
                    ],
                  ),              ],

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
                                            _address ?? "Not Getting address",
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
                                  child: GestureDetector(
                                    onTap: () async {
                                      String? placeName = await _showPlaceDialog(context, "Search Place");
                                      if (placeName != null && placeName.isNotEmpty) {
                                        _searchForPlace(placeName);
                                      }
                                    },
                                    child: Row(
                                      children: [
                                        Icon(Icons.location_on_outlined, color: Colors.green),
                                        SizedBox(width: 10),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "To",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                                 _searchedPlace ?? "Where to?",
                                              style: TextStyle(color: Colors.grey, fontSize: 14),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
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
                                      _searchForPlace(placeName);
                                    }
                                  },
                                  child: const Text("Search Place"),
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
            ),
          ],
          
        ),
        floatingActionButton: FloatingActionButton(
        onPressed: locateUserPosition,
        child: Icon(Icons.my_location),
        backgroundColor: Colors.blue,
      ),
        
      ),
    );
  }
  Future<void> locateUserPosition() async {
  try {
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
    mapController.move(latLngPosition, 15); // Move the map to the current position

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
  } catch (e) {
    print("Error occurred: $e");
  }
}

void _drawLineBetweenPickupAndDropoff() async {
  if (pickuplocation != null && dropofflocation != null) {
    try {
      // Construct API request URL for OpenRouteService directions
      String url =
          'https://api.openrouteservice.org/v2/directions/driving-car?api_key=5b3ce3597851110001cf62489ca8d68d613b4649a50535a6c7e45777&start=${pickuplocation!.longitude},${pickuplocation!.latitude}&end=${dropofflocation!.longitude},${dropofflocation!.latitude}';

      // Make HTTP GET request to fetch direction details
      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Check if route geometry exists in the response
        if (data["routes"] != null && data["routes"].isNotEmpty) {
          // Extract the geometry (list of coordinates)
          final routeGeometry = data["routes"][0]["geometry"]["coordinates"];

          // Convert the route geometry into LatLng objects for the polyline
          List<LatLng> polylineCoordinates = routeGeometry.map<LatLng>((point) {
            return LatLng(point[1], point[0]); // LatLng takes latitude first, then longitude
          }).toList();

          // Update the polyline points
          setState(() {
            polylinePoints = polylineCoordinates;
          });
        } else {
          print("No routes found in the API response");
        }
      } else {
        print("Failed to fetch direction details. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error drawing polyline: $e");
    }
  }
}



 Future<void> getAddressFromLatLng() async {
  if (pickuplocation == null) return;

  try {
    String apiUrl = "https://nominatim.openstreetmap.org/reverse?format=json&lat=${pickuplocation!.latitude}&lon=${pickuplocation!.longitude}&addressdetails=1";
    
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      // Access the address from the Nominatim API response
      String? humanReadableAddress = data['display_name'];

      // Update the provider with the location details
      Direction userPickupAddress = Direction();
      userPickupAddress.locationLatitude = pickuplocation!.latitude;
      userPickupAddress.locationLongitude = pickuplocation!.longitude;
      userPickupAddress.locationName = humanReadableAddress;
      
      setState(() {
        _address = humanReadableAddress;
      });
      
      Provider.of<Appinfo>(context, listen: false).updatePickupLocation(userPickupAddress);
    } else {
      print('Failed to fetch address');
    }
  } catch (e) {
    print("Error occurred while getting address: $e");
  }
}


 Future<void> _searchForPlace(String placeName) async {
  try {
    final url =
        "https://nominatim.openstreetmap.org/search?q=$placeName&format=json&limit=1";
    final response = await http.get(Uri.parse(url));
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      
      if (data != null && data.isNotEmpty) {
        double lat = double.parse(data[0]["lat"]);
        double lon = double.parse(data[0]["lon"]);
        
        setState(() {
          dropofflocation = LatLng(lat, lon);
          _searchedPlace = placeName;
          
          markers.add(
            Marker(
              point: dropofflocation!,
              child: Builder(builder: (context) => Icon(Icons.location_on, color: Colors.blue, size: 40),)
            ),
          );

          mapController.move(dropofflocation!, 14);
        });
      } else {
        print("No results found");
      }
    } else {
      print("Failed to search for place, status code: ${response.statusCode}");
    }
  } catch (e) {
    print("Error occurred while searching for place: $e");
  }
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
