import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart' as loc;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import 'app_info.dart';
import 'direction.dart';
import 'methods.dart';
class PrecisePickUpScreen extends StatefulWidget {
  const PrecisePickUpScreen({super.key});

  @override
  State<PrecisePickUpScreen> createState() => _PrecisePickUpScreenState();
}

class _PrecisePickUpScreenState extends State<PrecisePickUpScreen> {

  LatLng ? pickLocation;
  loc.Location location =loc.Location();
  String? _address;
  Position? userCurrentPosition;
  double bottomPaddingOfMap =0;
  final Completer<GoogleMapController> _controllerGoogleMap =
  Completer();
  GoogleMapController? newGoogleMapController;


  static CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(0, 0), // Initialize with a default value
    zoom: 14.4746,
  );

  GlobalKey<ScaffoldState> _scaffoldState =GlobalKey<ScaffoldState>();




  locateUserPosition() async {
    Position cPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    userCurrentPosition = cPosition;

    LatLng latLngPosition = LatLng(
        userCurrentPosition!.latitude, userCurrentPosition!.longitude);
    CameraPosition cameraPosition = CameraPosition(
        target: latLngPosition, zoom: 15);
    newGoogleMapController!.animateCamera(
        CameraUpdate.newCameraPosition(cameraPosition));
    String humaReadalbeAddress = await Methods
        .searchAddressForGeographicCordinates(userCurrentPosition!, context);
    print("This is our address = "+humaReadalbeAddress);


    setState(() {
      _kGooglePlex = cameraPosition; // Update _kGooglePlex with user's position
    });


  }
Future<void> getAddressFromLatLng(LatLng position) async {
    try {
      // Fetch the address using the provided position
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      // Extract the first placemark (most accurate)
      Placemark placemark = placemarks.first;

      // Extract the address components
      String address =
          "${placemark.name}, ${placemark.thoroughfare}, ${placemark.locality},${placemark.postalCode}, ${placemark.administrativeArea}, ${placemark.country}";

      // Update the state with the address
      setState(() {
        Directions userPickUpAddress =Directions();
        userPickUpAddress.locationLatitude =pickLocation!.latitude;
        userPickUpAddress.locationLongitude=pickLocation!.longitude;
        userPickUpAddress.locationName=address;
        Provider.of<AppInfo>(context,listen: false).updatePickupLocationAddress(userPickUpAddress);
      //  _address = address;
      });
    } catch (e) {
      print(e);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
   body:  Stack(
     children: [
       GoogleMap(
         padding: EdgeInsets.only(top: 100,bottom: bottomPaddingOfMap),
         mapType: MapType.normal,
         myLocationEnabled: true,
         zoomControlsEnabled: true,
         zoomGesturesEnabled: true,
         compassEnabled: true,
         initialCameraPosition:_kGooglePlex,
         onMapCreated: (GoogleMapController controller){
           _controllerGoogleMap.complete(controller);
           newGoogleMapController =controller;

           setState(() {
            bottomPaddingOfMap=100;
           });
           locateUserPosition();
         },
         onCameraMove: (CameraPosition? position){
             if(pickLocation !=position!.target){
               setState(() {
                 pickLocation=position.target;
               });
             }
         },
         onCameraIdle: () {
           if (pickLocation != null) {
             getAddressFromLatLng(pickLocation!);
           }

         },

       ),
       Align(
         alignment: Alignment.center,
         child: Padding(
           padding: const EdgeInsets.only(top:60,bottom: 100),
           child: Image.asset("assets/images/pickup.png",height: 45,width: 45,),
         )
       ),
       Positioned(
         top: 40,
         right: 20,
         left: 20,
         child: Container(
           decoration: BoxDecoration(
             borderRadius: BorderRadius.circular(20.0),
             border:  Border.all(color: Colors.black,width: 1.0),
             color: Colors.white70
           ),
           padding: EdgeInsets.all(20),
           child: Text(
             Provider.of<AppInfo>(context).userPickUpLocation !=null ?
             Provider.of<AppInfo>(context).userPickUpLocation!.locationName!:"Not Getting Address",
             overflow: TextOverflow.ellipsis, // Handle Overflow
             maxLines: 3,
           ),
         ),
       ),

       Positioned(
           bottom:0,left: 0,right: 0,
           child: Padding(
             padding: EdgeInsets.all(12),
             child: ElevatedButton(
               onPressed: (){
                 Navigator.pop(context);

               },
               style: ElevatedButton.styleFrom(
                   backgroundColor: Colors.cyanAccent,
                   textStyle: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.white
               )
               ),
              child: Text("Set Current Location",style:
                TextStyle(color: Colors.white),),


             ),
           ))
     ],
   ),

    );
  }
}
