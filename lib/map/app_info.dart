import 'package:flutter/material.dart';
import 'package:logisticapp/map/direction.dart';

class AppInfo extends ChangeNotifier{
  Directions? userPickUpLocation,userDropOffLocation;
  int countTotalTrips =0;
  // List<String> historyTripsKeysList=[];
  // List<TripHistoryModel> allTripshistoryInformationList =[];

  void updatePickupLocationAddress(Directions userPickUpAddress){
    userPickUpLocation=userPickUpAddress;
    notifyListeners();
  }
  void updateDropOffLocationAddress(Directions dropOffAddress){
    userDropOffLocation=dropOffAddress;
    notifyListeners();
  }

}