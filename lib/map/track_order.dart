import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:logisticapp/global.dart';
import 'package:logisticapp/map/change_pickup_location.dart';

import 'package:logisticapp/map/methods.dart';
import 'package:logisticapp/map/search_place_screen.dart';
import 'package:logisticapp/utils/app_colors.dart';
import 'package:logisticapp/widgets/progress_dialog.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';

import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:provider/provider.dart';

import 'app_info.dart';
import 'direction.dart';

class TrackOrder extends StatefulWidget {
  TrackOrder({Key? key}) : super(key: key);

  @override
  State<TrackOrder> createState() => _TrackOrderState();
}

class _TrackOrderState extends State<TrackOrder> {
  LocationPermission? _locationPermission;
  bool _locationServiceEnabled = false;

  void _checkLocationService() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    setState(() {
      _locationServiceEnabled = serviceEnabled;
    });
  }

  void _checkLocationPermission() async {
    PermissionStatus status = await Permission.location.status;
    if (status.isDenied) {
      // Permission has not been granted, request it
      await Permission.location.request();
    } else if (status.isGranted) {
      // Permission has already been granted, proceed with getting the location
      locateUserPosition();
    } else if (status.isPermanentlyDenied) {
      // Permission is permanently denied, take the user to app settings
      openAppSettings();
    }
  }

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
  }

  LatLng? pickLocation;
  loc.Location location = loc.Location();
  String? _address;

  final Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController? newGoogleMapController;

  static CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(0, 0), // Initialize with a default value
    zoom: 14.4746,
  );

  GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();
  double searchLocatioinContainerHeight = 220;
  double waitingResonpseFromDriverContainerHeight = 0;
  double assignedDriverInfocontainerHeight = 0;

  Position? userCurrentPosition;
  var geoLocation = Geolocator();

  //  LocationPermission? _locationPermission;
  double bottomPaddingOfMap = 0;

  List<LatLng> pLineCoordinatedList = [];
  Set<Polyline> polylineSet = {};

  Set<Marker> markerSet = {};
  Set<Circle> circleSet = {};

  String userName = "";
  String userEmail = "";

  bool openNavigationDrawer = true;
  bool activeNearByDriverKeysLoaded = false;

  BitmapDescriptor? aciveNearByIcon;

  locateUserPosition() async {
    Position cPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    userCurrentPosition = cPosition;

    LatLng latLngPosition =
        LatLng(userCurrentPosition!.latitude, userCurrentPosition!.longitude);
    CameraPosition cameraPosition =
        CameraPosition(target: latLngPosition, zoom: 15);
    newGoogleMapController!
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    String humaReadalbeAddress =
        await Methods.searchAddressForGeographicCordinates(
            userCurrentPosition!, context);
    print("This is our address = " + humaReadalbeAddress);

    setState(() {
      _kGooglePlex = cameraPosition; // Update _kGooglePlex with user's position
    });

    userName = "Ajay Kumar";
    userEmail = "1231231230@gmail.com";
  }

  Future<void> drawPolyLineFromOriginToDestination() async {
    var originPosition =
        Provider.of<AppInfo>(context, listen: false).userPickUpLocation;
    var destinationPosition =
        Provider.of<AppInfo>(context, listen: false).userDropOffLocation;

    var originLatlng = LatLng(
        originPosition!.locationLatitude!, originPosition!.locationLongitude!);
    var destinationLatlag = LatLng(destinationPosition!.locationLatitude!,
        destinationPosition!.locationLongitude!);

    showDialog(
      context: context,
      builder: (BuildContext context) => ProgressDialog(
        message: "Please wait...",
      ),
    );

    var directionDetailsInfo =
        await Methods.obtainOriginToDestinationDirectionDetails(
            originLatlng, destinationLatlag);
    setState(() {
      tripDirectionDetailsInfo = directionDetailsInfo;
    });
    Navigator.pop(context);
    PolylinePoints pPoints = PolylinePoints();
    List<PointLatLng> decodePolyLinePointsResultList =
        pPoints.decodePolyline(directionDetailsInfo.e_points!);

    pLineCoordinatedList.clear();
    if (decodePolyLinePointsResultList.isNotEmpty) {
      decodePolyLinePointsResultList.forEach((PointLatLng pointLatLng) {
        pLineCoordinatedList
            .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
    }

    polylineSet.clear();
    setState(() {
      Polyline polyline = Polyline(
        color: Colors.blue,
        polylineId: const PolylineId("Polyline"),
        jointType: JointType.round,
        points: pLineCoordinatedList,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
        width: 5,
      );

      polylineSet.add(polyline);
    });

    LatLngBounds boundsLatlng;
    if (originLatlng.latitude > destinationLatlag.latitude &&
        originLatlng.longitude > destinationLatlag.longitude) {
      boundsLatlng =
          LatLngBounds(southwest: destinationLatlag, northeast: originLatlng);
    } else if (originLatlng.longitude > destinationLatlag.longitude) {
      boundsLatlng = LatLngBounds(
        southwest: LatLng(originLatlng.latitude, destinationLatlag.longitude),
        northeast: LatLng(destinationLatlag.latitude, originLatlng.longitude),
      );
    } else if (originLatlng.latitude > destinationLatlag.latitude) {
      boundsLatlng = LatLngBounds(
        southwest: LatLng(destinationLatlag.latitude, originLatlng.longitude),
        northeast: LatLng(originLatlng.latitude, destinationLatlag.longitude),
      );
    } else {
      boundsLatlng =
          LatLngBounds(southwest: originLatlng, northeast: destinationLatlag);
    }

    newGoogleMapController!
        .animateCamera(CameraUpdate.newLatLngBounds(boundsLatlng, 100));

    Marker originMarker = Marker(
      markerId: const MarkerId("OriginId"),
      infoWindow:
          InfoWindow(title: originPosition.locationName, snippet: "Origin"),
      position: originLatlng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    );

    Marker destinationMarker = Marker(
      markerId: MarkerId("destinationId"),
      infoWindow: InfoWindow(
          title: destinationPosition.locationName, snippet: "Destination"),
      position: destinationLatlag,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );

    setState(() {
      markerSet.add(originMarker);
      markerSet.add(destinationMarker);
    });
    Circle originCircle = Circle(
      circleId: CircleId("OriginID"),
      fillColor: Colors.green,
      radius: 12,
      strokeColor: Colors.white,
      strokeWidth: 3,
      center: originLatlng,
    );
    Circle destinationCircle = Circle(
      circleId: CircleId("destinationId"),
      fillColor: Colors.red,
      radius: 12,
      strokeColor: Colors.white,
      strokeWidth: 3,
      center: originLatlng,
    );
    setState(() {
      circleSet.add(originCircle);
      circleSet.add(destinationCircle);
    });
  }

  // Future<void> getAddressFromLatLng(LatLng position) async {
  //   try {
  //     // Fetch the address using the provided position
  //     List<Placemark> placemarks = await placemarkFromCoordinates(
  //       position.latitude,
  //       position.longitude,
  //     );
  //
  //     // Extract the first placemark (most accurate)
  //     Placemark placemark = placemarks.first;
  //
  //     // Extract the address components
  //     String address =
  //         "${placemark.name}, ${placemark.thoroughfare}, ${placemark.locality},${placemark.postalCode}, ${placemark.administrativeArea}, ${placemark.country}";
  //
  //     // Update the state with the address
  //     setState(() {
  //       Directions userPickUpAddress =Directions();
  //       userPickUpAddress.locationLatitude =pickLocation!.latitude;
  //       userPickUpAddress.locationLongitude=pickLocation!.longitude;
  //       userPickUpAddress.locationName=address;
  //       Provider.of<AppInfo>(context,listen: false).updatePickupLocationAddress(userPickUpAddress);
  //     //  _address = address;
  //     });
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.cyan,
            leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
            title: Text(
              "Search location",
              style: TextStyle(color: Colors.white),
            ),
            elevation: 0.0,
          ),
          body: Stack(
            children: [
              GoogleMap(
                padding: EdgeInsets.only(top: 100, bottom: bottomPaddingOfMap),
                mapType: MapType.normal,
                myLocationEnabled: true,
                zoomControlsEnabled: true,
                zoomGesturesEnabled: true,
                compassEnabled: true,
                initialCameraPosition: _kGooglePlex,
                polylines: polylineSet,
                circles: circleSet,
                markers: markerSet,
                onMapCreated: (GoogleMapController controller) {
                  _controllerGoogleMap.complete(controller);
                  newGoogleMapController = controller;

                  setState(() {
                    bottomPaddingOfMap = 200;
                  });
                  locateUserPosition();
                },
                // onCameraMove: (CameraPosition? position){
                //     if(pickLocation !=position!.target){
                //       setState(() {
                //         pickLocation=position.target;
                //       });
                //     }
                // },
                // onCameraIdle: () {
                //   if (pickLocation != null) {
                //     getAddressFromLatLng(pickLocation!);
                //   }
                //
                // },
              ),
              // Align(
              //   alignment: Alignment.center,
              //   child: Padding(
              //     padding: const EdgeInsets.only(bottom: 35.0),
              //     child: Image.asset("assets/images/pickup.png",height: 45,width: 45,),
              //   )
              // ),

              //ui for searching location
              Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(5.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.location_on_outlined,
                                            color:
                                                ApplicationColors.mainThemeBlue,
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  "From",
                                                  style: TextStyle(
                                                    color: ApplicationColors
                                                        .mainThemeBlue,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  Provider.of<AppInfo>(context)
                                                              .userPickUpLocation !=
                                                          null
                                                      ? Provider.of<AppInfo>(
                                                              context)
                                                          .userPickUpLocation!
                                                          .locationName!
                                                      : "Not Getting Address",
                                                  style: const TextStyle(
                                                      color: Colors.black45,
                                                      fontSize: 14),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    const Divider(
                                      height: 1,
                                      thickness: 2,
                                      color: ApplicationColors.mainThemeBlue,
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: GestureDetector(
                                        onTap: () async {
                                          //for search screen

                                          var responseFromSearchScreen =
                                              await Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (c) =>
                                                          const SearchPlacesScreen()));
                                          if (responseFromSearchScreen ==
                                              "obtainedDropoff") {
                                            setState(() {
                                              openNavigationDrawer = false;
                                            });
                                          }

                                          //polylines method
                                          await drawPolyLineFromOriginToDestination();
                                        },
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.location_on_outlined,
                                              color: Colors.cyan,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "To",
                                                    style: TextStyle(
                                                      color: Colors.cyan,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Text(
                                                    Provider.of<AppInfo>(
                                                                    context)
                                                                .userDropOffLocation !=
                                                            null
                                                        ? Provider.of<AppInfo>(
                                                                context)
                                                            .userDropOffLocation!
                                                            .locationName!
                                                        : "Where to ?",
                                                    style: TextStyle(
                                                        color: Colors.black45,
                                                        fontSize: 14),
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (c) =>
                                                  PrecisePickUpScreen()));
                                    },
                                    child: Text(
                                      "Locate on the Map",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.cyan,
                                        textStyle: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        )),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ))

              // Positioned(
              //   top: 40,
              //   right: 20,
              //   left: 20,
              //   child: Container(
              //     decoration: BoxDecoration(
              //       border:  Border.all(color: Colors.black),
              //       color: Colors.white
              //     ),
              //     padding: EdgeInsets.all(20),
              //     child: Text(
              //       Provider.of<AppInfo>(context).userPickUplocation !=null ?
              //       (Provider.of<AppInfo>(context).userPickUplocation!.locationName!).substring(0,24) +"...":"Not Getting Address",
              //       overflow: TextOverflow.ellipsis, // Handle Overflow
              //       maxLines: 3,
              //     ),
              //   ),
              // ),
            ],
          ),
        ));
  }
}
