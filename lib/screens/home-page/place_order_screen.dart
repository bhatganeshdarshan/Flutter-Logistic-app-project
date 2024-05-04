import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:logisticapp/map/active_nearby_driver.dart';
import 'package:logisticapp/global.dart';
import 'package:logisticapp/map/change_pickup_location.dart';
import 'package:logisticapp/map/grofire_assistant.dart';

import 'package:logisticapp/map/methods.dart';
import 'package:logisticapp/map/search_place_screen.dart';
import 'package:logisticapp/providers/supabase_manager.dart';
import 'package:logisticapp/utils/app_colors.dart';
import 'package:logisticapp/utils/app_constants.dart';
import 'package:logisticapp/widgets/progress_dialog.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';

import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:provider/provider.dart';
import 'package:logisticapp/global.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../map/app_info.dart';

class PlaceOrder extends StatefulWidget {
  @override
  _PlaceOrderState createState() => _PlaceOrderState();
}

class _PlaceOrderState extends State with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  double? fare = 200;
  String expectedTime = "15 mins";

  double calculateFare(int index) {
    // Placeholder for fare calculation logic
    return 100.0; // Example fare
  }

  LocationPermission? _locationPermission;
  bool _locationServiceEnabled = false;
  final SupabaseOrders supabaseOrders = SupabaseOrders();

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
    setState(() {
      isLoading = false;
    });
  }

  bool isLoading = true;
  late SupabaseStreamBuilder stream;

  @override
  void initState() {
    super.initState();
    stream = Supabase.instance.client
        .from('available_orders')
        .stream(primaryKey: [userId]).eq('user_id', userId);
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

  BitmapDescriptor? activeNearByIcon;

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

    initializedGeoFireListener();
  }

  initializedGeoFireListener() {
    Geofire.initialize("activeDrivers");
    Geofire.queryAtLocation(
            userCurrentPosition!.latitude, userCurrentPosition!.longitude, 10)!
        .listen((map) {
      print(map);
      if (map != null) {
        var callBack = map["callBack"];
        switch (callBack) {
          //whenever any driver become active/ online
          case Geofire.onKeyEntered:
            ActiveNearByAvailableDrivers activeNearByAvailableDrivers =
                ActiveNearByAvailableDrivers();
            activeNearByAvailableDrivers.locationLongitude = map["latitude"];
            activeNearByAvailableDrivers.locationLatitude = map["longitude"];
            activeNearByAvailableDrivers.driverId = map["key"];

            GeoFireAssistant.activeNearByAvailableDriversList
                .add(activeNearByAvailableDrivers);
            if (activeNearByDriverKeysLoaded == true) {
              displayActiveDriverOnUserMap();
            }
            break;
          //Whenever any driver become non-active/online
          case Geofire.onKeyExited:
            GeoFireAssistant.deleteOffLineDriverFromList(map["key"]);
            displayActiveDriverOnUserMap();
            break;
          // whenever driver moves -update driver location
          case Geofire.onKeyMoved:
            ActiveNearByAvailableDrivers activeNearByAvailableDrivers =
                ActiveNearByAvailableDrivers();
            activeNearByAvailableDrivers.locationLatitude = map["latitude"];
            activeNearByAvailableDrivers.locationLongitude = map["longitude"];
            activeNearByAvailableDrivers.driverId = map["key"];
            GeoFireAssistant.updateActiveNearByAvailableDriverLocation(
                activeNearByAvailableDrivers);
            displayActiveDriverOnUserMap();
            break;
          //display those online a active driver on user's map
          case Geofire.onGeoQueryReady:
            activeNearByDriverKeysLoaded = true;
            displayActiveDriverOnUserMap();
            break;
        }
      }
      setState(() {});
    });
  }

  displayActiveDriverOnUserMap() {
    setState(() {
      markerSet.clear();
      circleSet.clear();
      Set<Marker> driverMarkerSet = Set<Marker>();
      for (ActiveNearByAvailableDrivers eachDriver
          in GeoFireAssistant.activeNearByAvailableDriversList) {
        LatLng eachDriverActivePosition =
            LatLng(eachDriver.locationLatitude!, eachDriver.locationLongitude!);
        Marker marker = Marker(
          markerId: MarkerId(eachDriver.driverId!),
          position: eachDriverActivePosition,
          icon: activeNearByIcon!,
          rotation: 360,
        );

        driverMarkerSet.add(marker);
      }
      setState(() {
        markerSet = driverMarkerSet;
      });
    });
  }

  createActiveNearByDriverIconMarker() {
    if (activeNearByIcon == null) {
      ImageConfiguration imageConfiguration =
          createLocalImageConfiguration(context, size: Size(0.2, 0.2));
      BitmapDescriptor.fromAssetImage(
              imageConfiguration, "assets/images/car.png")
          .then((value) {
        activeNearByIcon = value;
      });
    }
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
      for (var pointLatLng in decodePolyLinePointsResultList) {
        pLineCoordinatedList
            .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      }
    }

    polylineSet.clear();
    setState(() {
      Polyline polyline = Polyline(
        color: ApplicationColors.mainThemeBlue,
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
      markerId: const MarkerId("destinationId"),
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
      circleId: const CircleId("OriginID"),
      fillColor: Colors.green,
      radius: 12,
      strokeColor: Colors.white,
      strokeWidth: 3,
      center: originLatlng,
    );
    Circle destinationCircle = Circle(
      circleId: const CircleId("destinationId"),
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

  @override
  Widget build(BuildContext context) {
    return (isLoading == false)
        ? Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              title: const Text(
                "Confirming Order",
                style: TextStyle(color: Colors.cyanAccent),
              ),
              backgroundColor: Colors.transparent,
              elevation: 0, // Removes the shadow from the app bar
              leading: Padding(
                padding: const EdgeInsets.all(
                    8.0), // Padding around the button for a nicer look
                child: FloatingActionButton(
                  onPressed: () {
                    // Action to go back
                    supabaseOrders.cancelCurrentOrder(userId);
                    Navigator.of(context).pop();
                  }, // Icon inside the button
                  backgroundColor: Colors.white,
                  child: const Icon(Icons.arrow_back,
                      color: Colors.black), // Background color of the button
                ),
              ),
            ),
            body: StreamBuilder(
                stream: stream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        semanticsLabel: "Assigning Driver",
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error : ${snapshot.error}'),
                    );
                  } else {
                    print(snapshot.data);
                    return Stack(alignment: Alignment.center, children: [
                      GoogleMap(
                        padding: EdgeInsets.only(
                            top: 100, bottom: bottomPaddingOfMap),
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

                          drawPolyLineFromOriginToDestination();
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
                    ]);
                  }
                }),
            bottomSheet: BottomSheet(
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              shadowColor: Colors.black,
              backgroundColor: Colors.white,
              onClosing: () {},
              builder: (BuildContext context) {
                // int fareInt = fare?.toInt() ?? 0;
                // int taxAmt = ((fare ?? 0) * 0.18).toInt();
                return StreamBuilder(
                    stream: stream,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(
                            semanticsLabel: "Assigning Driver",
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text('Error : ${snapshot.error}'),
                        );
                      } else {
                        print("snapshot.data : ${snapshot.data}");
                        return SizedBox(
                          height: MediaQuery.of(context).size.height * 0.4,
                          child: SingleChildScrollView(
                            child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: ((snapshot.data![0]['driver_id']) !=
                                        null)
                                    ? Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  const CircleAvatar(
                                                    radius: 24.0,
                                                    backgroundImage: AssetImage(
                                                        'assets/images/driver.png'), // Placeholder image
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        '${snapshot.data![0]['driver_id']}',
                                                        style: const TextStyle(
                                                          fontSize: 20.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      const Row(
                                                        children: [
                                                          Icon(Icons.star,
                                                              color:
                                                                  Colors.amber,
                                                              size: 18),
                                                          Text('4.9')
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              IconButton(
                                                icon: const Icon(
                                                    Icons.info_outline,
                                                    color: Colors.green),
                                                onPressed: () {
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        AlertDialog(
                                                      title: Text(
                                                          'Driver Details'),
                                                      content: Text(
                                                          'Additional information about the driver.'),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () =>
                                                              Navigator.of(
                                                                      context)
                                                                  .pop(),
                                                          child: Text('Close'),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              ),
                                            ],
                                          ),

                                          Text(
                                              'Total fare :${snapshot.data![0]['fare']}',
                                              style: TextStyle(
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.cyanAccent)),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                  'Total Distance : ${tripDirectionDetailsInfo?.distance_text}',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.blue)),
                                              SizedBox(
                                                width: 20,
                                              ),
                                              Text(
                                                  'Estd Time :${tripDirectionDetailsInfo?.duration_text}',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.blue)),
                                            ],
                                          ),

                                          // Your existing content here

                                          _buildVehicleDetails(),
                                          SizedBox(height: 20.0),

                                          _buildPaymentMethodSection(),
                                          SizedBox(height: 20.0),
                                          _buildLocationSection(
                                              Icons.my_location,
                                              "Pickup Location",
                                              Provider.of<AppInfo>(context)
                                                  .userPickUpLocation!
                                                  .locationName!,
                                              Colors.blue),
                                          SizedBox(height: 10.0),
                                          _buildLocationSection(
                                              Icons.place,
                                              "Dropoff Location",
                                              Provider.of<AppInfo>(context)
                                                  .userDropOffLocation!
                                                  .locationName!,
                                              Colors.red),
                                          const SizedBox(height: 20.0),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              ElevatedButton(
                                                onPressed: () async {
                                                  supabaseOrders
                                                      .cancelCurrentOrder(
                                                          userId);
                                                  Navigator.pop(context);
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors
                                                      .red, // Background color
                                                ),
                                                child: const Text('Cancel Ride',
                                                    style: TextStyle(
                                                        color: Colors.white)),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )
                                    : const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Text("Assigning Driver"),
                                          CircularProgressIndicator(),
                                        ],
                                      )),
                          ),
                        );
                      }
                    });
              },
            ),
          )
        : const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
  }

  Widget _buildPaymentMethodSection() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          // isOnlinePayment ? "Online Payment" :
          "Cash on Delivery",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        // if (isOnlinePayment)
        Icon(Icons.check_circle, color: Colors.green, size: 24),
      ],
    );
  }

  Widget _buildVehicleDetails() {
    return const Card(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      elevation: 4.0,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Vehicle Details',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
            Divider(),
            Row(
              children: [
                Icon(Icons.motorcycle, color: Colors.blueAccent),
                SizedBox(width: 10),
                Text('Type: Two wheeler'),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.directions_car, color: Colors.blueAccent),
                SizedBox(width: 10),
                Text('Model: ABC123'),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.color_lens, color: Colors.blueAccent),
                SizedBox(width: 10),
                Text('Color: White'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationSection(
      IconData icon, String label, String address, Color iconColor) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: 28),
        SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Text(
                address,
                style: TextStyle(fontSize: 14),
                overflow: TextOverflow.ellipsis,
                softWrap: true,
                maxLines: 2,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
