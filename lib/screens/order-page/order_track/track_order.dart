import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logisticapp/utils/app_constants.dart';

class TrackOrder extends StatefulWidget {
  const TrackOrder({super.key});

  @override
  State<TrackOrder> createState() => _TrackOrderState();
}

class _TrackOrderState extends State<TrackOrder> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const LatLng sourceLocation = LatLng(13.129892, 77.571452);
  static const LatLng destinLocation = LatLng(13.143349, 77.569577);

  List<LatLng> polyCoord = [];

  static const CameraPosition _loc1 = CameraPosition(
    target: sourceLocation,
    zoom: 15,
  );

  static const CameraPosition _loc2 = CameraPosition(
    target: destinLocation,
    zoom: 15,
  );

  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult res = await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey,
      PointLatLng(sourceLocation.latitude, sourceLocation.longitude),
      PointLatLng(destinLocation.latitude, destinLocation.longitude),
    );
    if (res.points.isEmpty) {
      res.points.forEach((PointLatLng points) {
        polyCoord.add(LatLng(points.latitude, points.longitude));
      });
      setState(() {});
    }
  }

  @override
  void initState() {
    getPolyPoints();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text("Track your order"),
        ),
      ),
      body: GoogleMap(
        mapType: MapType.normal,
        markers: {
          const Marker(
            markerId: MarkerId("Source"),
            position: sourceLocation,
          ),
          const Marker(
            markerId: MarkerId("Destination"),
            position: destinLocation,
          ),
        },
        initialCameraPosition: _loc1,
        polylines: {
          Polyline(
            polylineId: const PolylineId("route"),
            points: polyCoord,
          ),
        },
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }
}
