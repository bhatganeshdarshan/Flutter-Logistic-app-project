import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:logisticapp/map/app_info.dart';
import 'package:logisticapp/map/direction.dart';
import 'package:logisticapp/map/request.dart';
import 'package:provider/provider.dart';

import '../global.dart';
import 'direction_details_model.dart';

class Methods{
  static Future<String> searchAddressForGeographicCordinates(Position position,context) async{

  String apiUrl =
      'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$key';
    String humanReadableAddress ="";
  var requestResponse =await RequestMethod.receiveRequest(apiUrl);

  if(requestResponse !="Error Occurred.Failed.No Response."){
    humanReadableAddress =requestResponse["results"][0]["formatted_address"];

    Directions userPickUpAddress =Directions();
    userPickUpAddress.locationLatitude =position.latitude;
    userPickUpAddress.locationLongitude=position.longitude;
    userPickUpAddress.locationName=humanReadableAddress;
    Provider.of<AppInfo>(context,listen: false).updatePickupLocationAddress(userPickUpAddress);
  }

  return humanReadableAddress;
  }

  static Future<DirectionDetailsInfo> obtainOriginToDestinationDirectionDetails(LatLng originPosition, LatLng destinationPosition) async{
  String urlOriginToDestinationDirectionDetails ="https://maps.googleapis.com/maps/api/directions/json?origin=${originPosition.latitude},${originPosition.longitude}&destination=${destinationPosition.latitude},${destinationPosition.longitude}&key=$key";

  var responseDirectionApi = await RequestMethod.receiveRequest(urlOriginToDestinationDirectionDetails);
  // if(responseDirectionApi =="Error Occurred.Failed.No Response."){
  //   return null;
  // }

  DirectionDetailsInfo directionDetailsInfo =DirectionDetailsInfo();
  directionDetailsInfo.e_points=responseDirectionApi["routes"][0]["overview_polyline"]["points"];
  directionDetailsInfo.distance_text=responseDirectionApi["routes"][0]["legs"][0]["distance"]["text"];
  directionDetailsInfo.distance_value=responseDirectionApi["routes"][0]["legs"][0]["distance"]["value"];

  directionDetailsInfo.duration_text=responseDirectionApi["routes"][0]["legs"][0]["duration"]["text"];
  directionDetailsInfo.duration_value=responseDirectionApi["routes"][0]["legs"][0]["duration"]["value"];


  return directionDetailsInfo;
  }






}