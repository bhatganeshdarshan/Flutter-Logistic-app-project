import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logisticapp/constants/constants.dart';
import 'package:logisticapp/providers/supabase_manager.dart';
import 'package:logisticapp/utils/app_colors.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final orderData = SupabaseOrders();
  late dynamic orders;
  bool isLoading = true;

  @override
  void initState() {
    getOrders();
    super.initState();
  }

  getOrders() async {
    orders = await orderData.getOrders();
    setState(() {
      isLoading = false;
    });
    print("orders : $orders");
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    bool isExpanded = false;
    return !isLoading
        ? ListView.builder(
            padding: const EdgeInsets.only(top: 30),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              // return Column(
              //   children: [
              //     Text("order no : ${index + 1}"),
              //     Text("item name : ${orders[index]['item_name']}"),
              //     Text("ph.no : ${orders[index]['user_phone']}"),
              //     Text("pick location : ${orders[index]['pick_location']}"),
              //     Text("drop location : ${orders[index]['drop_location']}"),
              //     Text("amount : ${orders[index]['amount']}"),
              //     Text("driver : ${orders[index]['driver_name']}"),
              //     Text("driver phone : ${orders[index]['driver_phone']}"),
              //     const SizedBox(
              //       height: 30,
              //     )
              //   ],
              // );
              // 2
              // return Card(
              //   // color: isExpanded ? ApplicationColors.mainThemeBlue : null,
              //   child: InkWell(
              //     child: ExpansionTile(
              //       maintainState: true,
              //       // tilePadding: EdgeInsets.only(bottom: 40),
              //       backgroundColor:
              //           isExpanded ? null : ApplicationColors.mainThemeBlue,
              //       onExpansionChanged: (value) {
              //         setState(() {
              //           isExpanded = value;
              //         });
              //         print(isExpanded);
              //       },
              //       title: Text(
              //         orders[index]['item_name'],
              //         style: GoogleFonts.poppins(
              //           fontSize: 14,
              //         ),
              //       ),
              //       trailing: Column(
              //         children: [
              //           Text(
              //             "₹${orders[index]['amount']}",
              //             style: GoogleFonts.poppins(fontSize: 12),
              //           ),
              //           isExpanded
              //               ? const Icon(Icons.arrow_drop_up)
              //               : const Icon(Icons.arrow_drop_down)
              //         ],
              //       ),
              //       children: [
              //         Text(orders[index]['user_phone']),
              //       ],
              //     ),
              //   ),
              // );
              List<String> dateTime = orders[index]['ordered_at'].split("T");
              return Card(
                elevation: 3,
                margin: const EdgeInsets.only(left: 28, right: 28, bottom: 28),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                  child: SizedBox(
                    width: width,
                    height: 140,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "${dateTime[0]} ${dateTime[1]}",
                                style: GoogleFonts.poppins(
                                  color: Colors.black45,
                                ),
                              ),
                            ),
                            (orders[index]['is_delivered'] == true)
                                ? Text(
                                    "Delivered",
                                    style: GoogleFonts.poppins(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                : Text("Pending",
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.amber,
                                    )),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "₹ ${orders[index]['amount']}",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                "${orders[index]['item_name']}",
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(Colors
                                        .transparent), // Set background color
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        18.0), // Set rounded corners
                                  ),
                                ),
                                elevation: MaterialStateProperty.all<double>(0),
                              ),
                              onPressed: () {},
                              child: Row(
                                children: [
                                  Text(
                                    "View More",
                                    style: GoogleFonts.poppins(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Icon(
                                    Icons.arrow_forward,
                                    color: Colors.black,
                                  ),
                                ],
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
          )
        : const Center(
            child: CircularProgressIndicator(),
          );
  }
}
