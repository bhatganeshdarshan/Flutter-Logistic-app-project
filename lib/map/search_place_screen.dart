import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logisticapp/constants/constants.dart';
import 'package:logisticapp/map/predicted_places.dart';
import 'package:logisticapp/map/request.dart';
import 'package:logisticapp/utils/app_colors.dart';
import 'package:logisticapp/widgets/place_prediction_tile.dart';

import '../constants/constants.dart';
import '../global.dart';

class SearchPlacesScreen extends StatefulWidget {
  const SearchPlacesScreen({super.key});

  @override
  State<SearchPlacesScreen> createState() => _SearchPlacesScreenState();
}

class _SearchPlacesScreenState extends State<SearchPlacesScreen> {
  List<PredictedPlaces> placesPredictedList = [];
  findPlaceAutoCompleteSearch(String inputText) async {
    if (inputText.length > 1) {
      String urlAutoCompleteSearch =
          "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$inputText&key=$key&components=country:IN";
      var responseAutoCompleteSearch =
          await RequestMethod.receiveRequest(urlAutoCompleteSearch);

      if (responseAutoCompleteSearch == "Error Occurred.Failed.No Response.") {
        return;
      }

      if (responseAutoCompleteSearch["status"] == "OK") {
        var placePredictions = responseAutoCompleteSearch["predictions"];
        var placePredictionsList = (placePredictions as List)
            .map((jsonData) => PredictedPlaces.fromJson(jsonData))
            .toList();

        setState(() {
          placesPredictedList = placePredictionsList;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: ApplicationColors.mainThemeBlue,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          title: Text(
            "Search location",
            style: GoogleFonts.poppins(color: Colors.white),
          ),
          elevation: 0,
        ),
        body: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                  color: ApplicationColors.mainThemeBlue,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.white,
                        blurRadius: 8,
                        spreadRadius: 0.5,
                        offset: Offset(
                          0.7,
                          0.7,
                        ))
                  ],
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15))),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          color: Colors.white,
                          size: 40.0,
                        ),
                        // const SizedBox(
                        //   height: 18.0,
                        // ),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.only(
                              bottom: 16, top: 8, left: 8, right: 8),
                          child: TextField(
                            onChanged: (value) {
                              findPlaceAutoCompleteSearch(value);
                            },
                            decoration: const InputDecoration(
                              hintText: "Search Location here...",
                              fillColor: Colors.white54,
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: EdgeInsets.only(
                                  left: 11, top: 8, bottom: 8, right: 8),
                            ),
                          ),
                        ))
                      ],
                    )
                  ],
                ),
              ),
            ),
            // display places prediction result
            (placesPredictedList.isNotEmpty)
                ? Expanded(
                    child: ListView.builder(
                    itemCount: placesPredictedList.length,
                    physics: const ClampingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return PlacePredictionTileDesign(
                        predictedPlaces: placesPredictedList[index],
                      );
                    },
                  ))
                : Container()
          ],
        ),
      ),
    );
  }
}
