import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logisticapp/constants/constants.dart';
import 'package:logisticapp/entrypage.dart';
import 'package:logisticapp/global.dart';
import 'package:logisticapp/providers/supabase_manager.dart';
import 'package:logisticapp/map/track_order.dart';
import 'package:logisticapp/screens/calculate-fare/calculate_fare.dart';
import 'package:logisticapp/screens/home-page/place_order_screen.dart';
import 'package:logisticapp/screens/order-page/place_order.dart';
import 'package:logisticapp/utils/app_colors.dart';
import 'package:logisticapp/utils/app_constants.dart';
import 'package:logisticapp/widgets/checkout_row.dart';
import 'package:logisticapp/widgets/rounded_button.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../map/app_info.dart';
import '../../map/search_place_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  int? clickedCard;
  bool isClicked = false;
  bool isLoading = true;
  int? curIndex;
  final vehicleData = SupabaseManager();
  final supabaseOrders = SupabaseOrders();
  late dynamic vehicle;
  late AnimationController _animationController;
  String? tripDistance = tripDirectionDetailsInfo?.distance_text;
  late double? fare;
  late dynamic user;
  dynamic selectedPayment;
  dynamic userPickLocation;
  dynamic userDropLocation;
  int? fareInt;
  int? finalAmt;
  final userData = SupabaseUserManager();

  @override
  void initState() {
    readData();
    readUserData();

    super.initState();
    _animationController = AnimationController(vsync: this);
  }

  readUserData() async {
    user = await userData.readData();
    print(user);
  }

  readData() async {
    vehicle = await vehicleData.readData();
    setState(() {
      isLoading = false;
    });
    // print(vehicle);
    print("distanceeeeeeeeeeeeeeee : $tripDistance");
  }

  bool openNavigationDrawer = true;

  final stream = Supabase.instance.client
      .from('available_orders')
      .stream(primaryKey: [userId]).eq('user_id', userId);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error : ${snapshot.error}'),
            );
          } else {
            print(snapshot
                .data); // live location of driver can be fetched from the snapshot
            return Stack(
              children: [
                Scaffold(
                  body: isLoading
                      ? const Center(
                          child:
                              CircularProgressIndicator(), // Loading indicator
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.all(20.0),
                                            child: Icon(
                                              Icons.gps_fixed,
                                              color: ApplicationColors
                                                  .mainThemeBlue,
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              Provider.of<AppInfo>(context)
                                                          .userPickUpLocation !=
                                                      null
                                                  ? Provider.of<AppInfo>(
                                                          context)
                                                      .userPickUpLocation!
                                                      .locationName!
                                                  : "Enter Pickup Location",
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.poppins(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey[700],
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const TrackOrder()),
                                                );
                                              },
                                              icon: const Icon(
                                                Icons.add,
                                                color: ApplicationColors
                                                    .mainThemeBlue,
                                                size: 30,
                                              )),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.all(20.0),
                                            child: Icon(
                                              Icons.gps_not_fixed_outlined,
                                              color: ApplicationColors
                                                  .mainThemeBlue,
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              Provider.of<AppInfo>(context)
                                                          .userDropOffLocation !=
                                                      null
                                                  ? Provider.of<AppInfo>(
                                                          context)
                                                      .userDropOffLocation!
                                                      .locationName!
                                                  : "Enter Drop Location",
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
                                                var responseFromSearchScreen =
                                                    await Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (c) =>
                                                                const SearchPlacesScreen()));
                                                if (responseFromSearchScreen ==
                                                    "obtainedDropoff") {
                                                  setState(() {
                                                    openNavigationDrawer =
                                                        false;
                                                  });
                                                }
                                              },
                                              icon: const Icon(
                                                Icons.add,
                                                color: ApplicationColors
                                                    .mainThemeBlue,
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
                                          color: (isClicked &&
                                                  clickedCard == index)
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
                                            curIndex = index;
                                            print(index);
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
                                                  loadingBuilder: (context,
                                                      child, loadingProgress) {
                                                    if (loadingProgress ==
                                                        null) {
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
                                                      fontWeight:
                                                          FontWeight.normal),
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
                                                      fontWeight:
                                                          FontWeight.bold,
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
                  bottom: -10,
                  right: 0,
                  left: 0,
                  child: isClicked
                      ? (Provider.of<AppInfo>(context).userPickUpLocation !=
                                  null &&
                              Provider.of<AppInfo>(context)
                                      .userDropOffLocation !=
                                  null)
                          ? BottomSheet(
                              animationController: _animationController,
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              shadowColor: Colors.black,
                              backgroundColor: Colors.white,
                              onClosing: () {},
                              builder: (BuildContext context) {
                                fare = calculateFare(curIndex!);
                                fareInt = fare!.toInt();
                                int? taxAmt = (fare! * 0.18).toInt();
                                finalAmt = fareInt! + taxAmt;

                                // int taxAmt = (fareInt * 0.18) as int;
                                return SizedBox(
                                  height: 500,
                                  child: Center(
                                    // child: ElevatedButton(
                                    //     onPressed: () {}, child: const Text("Next")),
                                    child: Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          // Row(
                                          //   mainAxisAlignment:
                                          //       MainAxisAlignment.spaceAround,
                                          //   children: [
                                          //     Text(
                                          //       "Total",
                                          //       style: GoogleFonts.poppins(
                                          //         color: Colors.black87,
                                          //         fontSize: 16,
                                          //       ),
                                          //     ),
                                          //     const SizedBox(
                                          //       width: 30,
                                          //     ),
                                          //     (fareInt != null)
                                          //         ? Text(
                                          //             "₹$fareInt",
                                          //             style: GoogleFonts.poppins(
                                          //                 fontWeight: FontWeight.bold,
                                          //                 fontSize: 26),
                                          //           )
                                          //         : const CircularProgressIndicator()
                                          //   ],
                                          // ),
                                          // const SizedBox(
                                          //   height: 20,
                                          // ),
                                          // Material(
                                          //   color: Colors.transparent,
                                          //   child: Ink(
                                          //     decoration: BoxDecoration(
                                          //       color: ApplicationColors.mainThemeBlue,
                                          //       borderRadius: BorderRadius.circular(12),
                                          //     ),
                                          //     child: InkWell(
                                          //       onTap: () {
                                          //         print("clicked");
                                          //         Navigator.push(
                                          //             context,
                                          //             MaterialPageRoute(
                                          //               builder: (context) =>
                                          //                   const PlaceOrder(),
                                          //             ));
                                          //       },
                                          //       child: SizedBox(
                                          //         width: width - 30,
                                          //         height: 45,
                                          //         child: Center(
                                          //           child: Text(
                                          //             "Next",
                                          //             style: GoogleFonts.poppins(
                                          //                 color: Colors.white,
                                          //                 fontSize: 16),
                                          //           ),
                                          //         ),
                                          //       ),
                                          //     ),
                                          //   ),
                                          // ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 15),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                const Text(
                                                  "Checkout",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    Navigator.pushReplacement(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                MainScreen()));
                                                  },
                                                  child: Image.asset(
                                                    "assets/images/close.png",
                                                    width: 15,
                                                    height: 15,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const Divider(
                                            color: Colors.black26,
                                            height: 1,
                                          ),
                                          Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 15),
                                                child: Row(
                                                  children: [
                                                    const Text(
                                                      "Payment Type",
                                                      style: TextStyle(
                                                          color: Colors.black54,
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                    const Spacer(),
                                                    CupertinoSegmentedControl(
                                                        children: const {
                                                          0: Padding(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          8),
                                                              child:
                                                                  Text("COD")),
                                                          1: Padding(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          8),
                                                              child: Text(
                                                                  "Online")),
                                                        },
                                                        selectedColor:
                                                            Colors.black,
                                                        onValueChanged: (val) {
                                                          setState(() {
                                                            selectedPayment =
                                                                val;
                                                          });
                                                        }),
                                                  ],
                                                ),
                                              ),
                                              const Divider(
                                                color: Colors.black26,
                                                height: 1,
                                              ),
                                            ],
                                          ),

                                          Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              InkWell(
                                                onTap: () {},
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 15),
                                                  child: Row(
                                                    children: [
                                                      const Text(
                                                        "Payment",
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                      const Spacer(),
                                                      Image.asset(
                                                        "assets/images/master.png",
                                                        width: 30,
                                                      ),
                                                      const SizedBox(
                                                        width: 8,
                                                      ),
                                                      const Text(
                                                        "Select",
                                                        textAlign:
                                                            TextAlign.end,
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                      const SizedBox(
                                                        width: 15,
                                                      ),
                                                      Image.asset(
                                                        "assets/images/next.png",
                                                        height: 15,
                                                        color: Colors.black,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              const Divider(
                                                color: Colors.black26,
                                                height: 1,
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 15, right: 5),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 20),
                                                  child: Row(
                                                    children: [
                                                      const Text(
                                                        "Total",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black54,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                          "₹ $fareInt",
                                                          textAlign:
                                                              TextAlign.end,
                                                          style: const TextStyle(
                                                              color: Colors
                                                                  .black54,
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 20),
                                                  child: Row(
                                                    children: [
                                                      const Text(
                                                        "Tax (18% GST)",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black54,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                          "₹ $taxAmt",
                                                          textAlign:
                                                              TextAlign.end,
                                                          style: const TextStyle(
                                                              color: Colors
                                                                  .black54,
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 20),
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        "Discount ",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black54,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                          "- ₹ 7",
                                                          textAlign:
                                                              TextAlign.end,
                                                          style: TextStyle(
                                                              color: Colors.red,
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          CheckoutRow(
                                            title: "Final Total",
                                            value: "₹ ${fareInt! + taxAmt - 5}",
                                            onPressed: () {},
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 20),
                                            child: RichText(
                                              text: TextSpan(
                                                style: const TextStyle(
                                                    color: Colors.black54,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w500),
                                                children: [
                                                  const TextSpan(
                                                      text:
                                                          "By continuing you agree to our "),
                                                  TextSpan(
                                                      text: "Terms",
                                                      style: const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                      recognizer:
                                                          TapGestureRecognizer()
                                                            ..onTap = () {
                                                              print(
                                                                  "Terms of Service Click");
                                                            }),
                                                  const TextSpan(text: " and "),
                                                  TextSpan(
                                                      text: "Privacy Policy.",
                                                      style: const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                      recognizer:
                                                          TapGestureRecognizer()
                                                            ..onTap = () {
                                                              print(
                                                                  "Privacy Policy Click");
                                                            })
                                                ],
                                              ),
                                            ),
                                          ),
                                          RoundButton(
                                              title: "Place Order",
                                              onPressed: () async {
                                                setState(() {
                                                  finalAmt = fareInt! + taxAmt;
                                                });
                                                supabaseOrders.putOrders(
                                                    user[0]['id'],
                                                    clickedCard! + 1,
                                                    selectedPayment,
                                                    Provider.of<AppInfo>(
                                                            context,
                                                            listen: false)
                                                        .userPickUpLocation!
                                                        .locationLatitude,
                                                    Provider.of<AppInfo>(
                                                            context,
                                                            listen: false)
                                                        .userPickUpLocation!
                                                        .locationLongitude,
                                                    Provider.of<AppInfo>(
                                                            context,
                                                            listen: false)
                                                        .userDropOffLocation!
                                                        .locationLatitude,
                                                    Provider.of<AppInfo>(
                                                            context,
                                                            listen: false)
                                                        .userDropOffLocation!
                                                        .locationLongitude,
                                                    finalAmt);
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (c) =>
                                                            PlaceOrder()));
                                              }),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              })
                          : FloatingActionButton(
                              onPressed: () {},
                              child: const Icon(Icons.location_off),
                            )
                      : const SizedBox(),
                )
              ],
            );
          }
        });
  }
}
