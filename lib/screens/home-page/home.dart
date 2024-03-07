import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logisticapp/providers/supabase_manager.dart';

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

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body: isLoading
              ? Center(
                  child: CircularProgressIndicator(), // Loading indicator
                )
              : Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 26, horizontal: 20),
                      // color: Colors.amber,
                      height: 220,
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
                                  const Icon(
                                    Icons.gps_fixed,
                                    color: Color(0xFF30b9b2),
                                  ),
                                  Text(
                                    "Enter Pickup Location",
                                    style: GoogleFonts.poppins(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                  IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                        Icons.add,
                                        color: Color(0xFF30b9b2),
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
                                  const Icon(
                                    Icons.gps_not_fixed_outlined,
                                    color: Color(0xFF30b9b2),
                                  ),
                                  Text(
                                    "Enter Drop Location    ",
                                    style: GoogleFonts.poppins(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                  IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                        Icons.add,
                                        color: Color(0xFF30b9b2),
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
                        itemCount: vehicle.length,
                        itemBuilder: (context, index) {
                          return Container(
                            // color: Colors.red,
                            height: 180,
                            width: double.infinity,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(
                                  color: (isClicked && clickedCard == index)
                                      ? const Color(0xFF30b9b2)
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
                                         Image.asset(
                                           'assets/icons/${vehicle[index]['id']}.png',
                                           width: 60,
                                           height: 60,

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
