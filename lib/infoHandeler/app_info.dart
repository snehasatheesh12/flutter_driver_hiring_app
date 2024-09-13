import 'package:flutter/material.dart';
import 'package:users/direction.dart';


class Appinfo extends ChangeNotifier{
  Direction?userPickuplocation,userDropoffLocation;
  int countTotalTrips=0;
  // List<String>historyTripsList=[];
  // List<TripsHistoryModel>allTripHistoryInformationList=[];/
  void updatePickupLocation(Direction userPickupAddress){
    userPickuplocation=userPickupAddress;
    notifyListeners();
  }
  void updateDropoffLocationAddress(Direction droppOffaddress){
    userDropoffLocation=droppOffaddress;
    notifyListeners();  
  }
}