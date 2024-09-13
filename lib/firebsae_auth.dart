import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;  // Import the http package
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:users/USER/direction_detail_info.dart';
import 'package:users/config_map.dart';
import 'package:users/direction.dart';
import 'package:users/infoHandeler/app_info.dart';

class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return result.user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
  Future<User?> registerAdminWithEmailAndPassword(
  String email,
  String password,
  String username, {
  File? imageFile,
}) async {
  try {
    UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    User? user = result.user;
    String? imageUrl;
    if (imageFile != null) {
      imageUrl = await uploadImage(user!.uid, imageFile);
    }

    Map<String, dynamic> adminData = {
      'email': email,
      'username': username,
      'role': 'admin',
      'imageUrl': imageUrl,
    };

    // Save the admin data to Firestore
    await _firestore.collection('users').doc(user!.uid).set(adminData);

    return user;
  } catch (e) {
    print(e.toString());
    return null;
  }
}
Future<User?> signInAdminWithEmailAndPassword(String email, String password) async {
  try {
    UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
    User? user = result.user;

    // Check if the user has an admin role
    if (user != null && await isAdmin(user.uid)) {
      return user;
    } else {
      print("This user is not an admin");
      await signOut();
      return null;
    }
  } catch (e) {
    print(e.toString());
    return null;
  }
}
Future<User?> signInDriverWithEmailAndPassword(String email, String password, BuildContext context) async {
  try {
    UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
    User? user = result.user;

    if (user != null) {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();
      if (userDoc.exists && userDoc['role'] == 'driver') {
        bool isApproved = userDoc['isApproved'] ?? false;
        if (isApproved) {
          // Navigate to the driver dashboard
          Navigator.pushReplacementNamed(context, '/driverDashboard');
        } else {
          // Redirect to a pending approval page
          Navigator.pushReplacementNamed(context, '/pendingApproval');
        }
        return user;
      } else {
        print("This user is not a driver.");
        await signOut();
        return null;
      }
    } else {
      return null;
    }
  } catch (e) {
    print("Error during driver sign-in: $e");
    return null;
  }
}


Future<bool> isAdmin(String uid) async {
  try {
    DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
    return doc['role'] == 'admin';
  } catch (e) {
    print("Error checking admin status: ${e.toString()}");
    return false;
  }
}



  Future<User?> registerWithEmailAndPassword(
  String email,
  String password,
  String username,
  String phonenumber,
  String role,  
  String address, {
  File? imageFile,
  File? nonCriminalCertificate,
  
}) async {
  try {
    UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    User? user = result.user;
    String? imageUrl;
    if (imageFile != null) {
      imageUrl = await uploadImage(user!.uid, imageFile);
    }

    Map<String, dynamic> userData = {
      'email': email,
      'username': username,
      'phonenumber': phonenumber,
      'address': address,
      'role': role,
      'imageUrl': imageUrl,
    };

    if (role == 'driver') {
      userData['isApproved'] = false;
       if (nonCriminalCertificate != null) {
        String? certificateUrl = await uploadCertificate(user!.uid, nonCriminalCertificate);
        userData['nonCriminalCertificateUrl'] = certificateUrl;
      }
    }

    await _firestore.collection('users').doc(user!.uid).set(userData);

    return user;
  } catch (e) {
    print(e.toString());
    return null;
  }
}
Future<String?> uploadCertificate(String uid, File certificateFile) async {
  try {
    // Correct usage of string interpolation for the file name
    final storageRef = _storage.ref().child('driver_certificates').child('${uid}_certificate.jpg');
    await storageRef.putFile(certificateFile);
    return await storageRef.getDownloadURL();
  } catch (e) {
    print(e.toString());
    return null;
  }
}



  Future<String?> uploadImage(String uid, File imageFile) async {
    try {
      final storageRef = _storage.ref().child('user_images').child('$uid.jpg');
      await storageRef.putFile(imageFile);
      return await storageRef.getDownloadURL();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<String?> getUserRole(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
      return doc['role'];
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<Map<String, dynamic>?> getUserDetails(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
      return doc.data() as Map<String, dynamic>?;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
 Future<String?> searchAddressForGeographicCoordinates(Position position, BuildContext context) async {
  try {
    String apiUrl = "https://nominatim.openstreetmap.org/reverse?format=json&lat=${position.latitude}&lon=${position.longitude}&addressdetails=1";

    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      // Access the address from the Nominatim API response
      String? humanReadableAddress = data['display_name'];

      // Update the provider with the location details
      Direction userPickupAddress = Direction();
      userPickupAddress.locationLatitude = position.latitude;
      userPickupAddress.locationLongitude = position.longitude;
      userPickupAddress.locationName = humanReadableAddress;
      
      Provider.of<Appinfo>(context, listen: false).updateDropoffLocationAddress(userPickupAddress);
      
      return humanReadableAddress;
    } else {
      return 'Failed to fetch address';
    }
  } catch (e) {
    print("Error: $e");
    return null;
  }
}
 Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e.toString());
    }
  }

Future<DirectionsDetailinfo> obtainOriginToDestinationDirectionDetails(
  LatLng originPosition, LatLng destinationLatLng) async {
  
  // Constructing the URL with proper longitude,latitude order
  String urlOrigintoDestinationDirectionDetails =
      'https://api.openrouteservice.org/v2/directions/driving-car?api_key=$orsApiKey&start=${originPosition.longitude},${originPosition.latitude}&end=${destinationLatLng.longitude},${destinationLatLng.latitude}';
      print(urlOrigintoDestinationDirectionDetails);

  try {
    // Making the HTTP GET request
    final response = await http.get(Uri.parse(urlOrigintoDestinationDirectionDetails));
    print(response);

    // Check if the response is successful
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      // Extract the necessary details from the response
      DirectionsDetailinfo directionsDetailInfo = DirectionsDetailinfo();

      // Extract geometry data (list of coordinates)
      directionsDetailInfo.e_points = data['routes'][0]['geometry']['coordinates'];

      // Extract distance and duration from the summary
      var summary = data['routes'][0]['summary'];
      directionsDetailInfo.distance_value = summary['distance'];
      directionsDetailInfo.duration_value = summary['duration'];

      return directionsDetailInfo;

    } else {
      // If the response is not successful, throw an exception
      throw Exception("Failed to get directions: ${response.reasonPhrase}");
    }
  } catch (e) {
    // Catch any error that occurs during the process and throw it
    throw Exception("Error occurred: $e");
  }
}

}

  
