import 'package:flutter/material.dart';
import 'package:logisticapp/map/app_info.dart';
import 'package:logisticapp/map/change_dropoff_location.dart';
import 'package:logisticapp/map/predicted_places.dart';
import 'package:logisticapp/map/request.dart';
import 'package:logisticapp/widgets/progress_dialog.dart';
import 'package:provider/provider.dart';

import '../global.dart';

import '../map/change_pickup_location.dart';
import '../map/direction.dart';
class PlacePredictionTileDesign extends StatefulWidget {


  final PredictedPlaces? predictedPlaces;
  PlacePredictionTileDesign({this.predictedPlaces});
  @override
  State<PlacePredictionTileDesign> createState() => _PlacePredictionTileDesignState();
}

class _PlacePredictionTileDesignState extends State<PlacePredictionTileDesign> {
  getPlaceDirectionDetails(String? placeId, context) async {
    showDialog(context: context,
        builder: (BuildContext context) =>
            ProgressDialog(
              message: "Setting up Drop_Off .Please wait.......",

            )
    );


    String placeDirectionDetailsUrl = "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$key";


    var responseApi = await RequestMethod.receiveRequest(
        placeDirectionDetailsUrl);

    Navigator.pop(context);
    if (responseApi == "Error Occurred.Failed.No Response.") {
      return;
    }

    if (responseApi["status"] == "OK") {
      Directions directions = Directions();
      directions.locationName = responseApi["result"]["name"];
      directions.locationId = placeId;
      directions.locationLatitude =
      responseApi["result"]["geometry"]["location"]["lat"];
      directions.locationLongitude =
      responseApi["result"]["geometry"]["location"]["lng"];

      Provider.of<AppInfo>(context, listen: false).updateDropOffLocationAddress(
          directions);
      setState(() {
        userDropOffAddress = directions.locationName!;
      });

      // Navigator.pop(context, "obtainedDropoff");
      Navigator.push(context, MaterialPageRoute(builder: (c)=> PreciseDropOffLocation()));
    }
  }


  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        getPlaceDirectionDetails(widget.predictedPlaces!.place_id, context);
      },
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: Colors.transparent,
        // Transparent background
        padding: EdgeInsets.zero, // Remove default padding
      ),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8.0),
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 3,
              offset: Offset(0, 2), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(Icons.location_on_sharp, color: Colors.blueAccent),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.predictedPlaces!.main_text!,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    widget.predictedPlaces!.secondary_text!,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}