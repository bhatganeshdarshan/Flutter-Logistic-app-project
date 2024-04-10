import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logisticapp/providers/supabase_manager.dart';
import 'package:logisticapp/map/track_order.dart';
import 'package:logisticapp/utils/app_colors.dart';
import 'package:provider/provider.dart';

import '../../map/app_info.dart';
import '../../map/search_place_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int? clickedCard;
  bool isClicked = false;
  bool isLoading = true;
  final vehicleData = SupabaseManager();
  late dynamic vehicle;

  @override
  void initState() {

    readData();
    super.initState();
  }

  readData() async {
    vehicle = await vehicleData.readData();
    setState(() {
      isLoading = false;
    });
    // print(vehicle);
  }
  bool openNavigationDrawer=true;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body: isLoading
              ? const Center(
                  child: CircularProgressIndicator(), // Loading indicator
                )
              : Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 26, horizontal: 20),
                      // color: Colors.amber,
                      height: 180,
                      width: double.infinity,
                      child: Card(
                        elevation: 4,
                        shadowColor: Colors.black,
                        child: Column(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: const Icon(
                                      Icons.gps_fixed,
                                      color: ApplicationColors.mainThemeBlue,
                                    ),
                                  ),
                                   Expanded(
                                     child: Text(
                                       Provider.of<AppInfo>(context).userPickUpLocation !=null ?
                                       Provider.of<AppInfo>(context).userPickUpLocation!.locationName!
                                           :"Enter Pickup Location",
                                         overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.poppins(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                   ),
                                  IconButton(
                                      onPressed: ()  {
                                        Navigator.push(
                                             context,
                                           MaterialPageRoute(builder: (context) => TrackOrder()),
                                          );},
                                      icon: const Icon(
                                        Icons.add,
                                        color: ApplicationColors.mainThemeBlue,
                                        size: 30,
                                      )),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: const Icon(
                                      Icons.gps_not_fixed_outlined,
                                      color: ApplicationColors.mainThemeBlue,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      Provider.of<AppInfo>(context).userDropOffLocation !=null ?
                                      Provider.of<AppInfo>(context).userDropOffLocation!.locationName!
                                          :"Enter Drop Location",
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.poppins(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                      onPressed: () async {
                                        var responseFromSearchScreen =await Navigator.push(context, MaterialPageRoute(builder: (c)=>SearchPlacesScreen()));
                                        if(responseFromSearchScreen=="obtainedDropoff"){
                                          setState(() {
                                            openNavigationDrawer=false;
                                          });
                                        }
                                      },
                                      icon: const Icon(
                                        Icons.add,
                                        color: ApplicationColors.mainThemeBlue,
                                        size: 30,
                                      )),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.only(bottom: 30),
                        itemCount: vehicle.length,
                        itemBuilder: (context, index) {
                          return SizedBox(
                            // color: Colors.red,
                            height: 180,
                            width: double.infinity,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(
                                  color: (isClicked && clickedCard == index)
                                      ? ApplicationColors.mainThemeBlue
                                      : Colors.transparent,
                                  width: 3,
                                ),
                              ),
                              shadowColor: Colors.black,
                              elevation: 5,
                              margin: const EdgeInsets.only(
                                  left: 20, right: 20, top: 20),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    // isClicked = !isClicked;
                                    if (clickedCard == index &&
                                        isClicked == true) {
                                      isClicked = false;
                                    } else {
                                      isClicked = true;
                                    }
                                    clickedCard = index;
                                  });
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Image.network(
                                          '${vehicle[index]['vehicle_img']}',
                                          width: 60,
                                          height: 60,
                                          loadingBuilder: (context, child,
                                              loadingProgress) {
                                            if (loadingProgress == null) {
                                              return child;
                                            } else {
                                              return const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              );
                                            }
                                          },
                                        ),
                                        Text(
                                          "${vehicle[index]['wheels']} Wheeler",
                                          style: GoogleFonts.poppins(
                                              color: Colors.black54,
                                              fontWeight: FontWeight.normal),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(
                                          "${vehicle[index]['vehicle_name']}",
                                          style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 24,
                                              color: Colors.black54),
                                        ),
                                        Text(
                                          "Max ${vehicle[index]['capacity']}KG",
                                          style: GoogleFonts.poppins(
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
        ),
        Positioned(
          bottom: 20,
          right: 20,
          child: isClicked
              ? FloatingActionButton(
                  onPressed: () {},
                  child: const Icon(Icons.forward),
                )
              : SizedBox(),
        )
      ],
    );
  }
}
