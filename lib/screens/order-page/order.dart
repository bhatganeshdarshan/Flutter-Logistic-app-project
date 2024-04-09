import 'package:flutter/material.dart';
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
                elevation: 6,
                margin: const EdgeInsets.only(left: 28, right: 28, bottom: 28),
                color: Colors.white,
                child: SizedBox(
                  width: width,
                  height: 150,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("${dateTime[0]} ${dateTime[1]}"),
                            (orders[index]['is_delivered'] == true)
                                ? Text("Delivered")
                                : Text("Pending")
                          ]),
                      Text("₹${orders[index]['amount']}"),
                      // Text(orders[index]['item_name'])
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(orders[index]['item_name']),
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
                                    ),
                                  ),
                                  Icon(Icons.arrow_forward),
                                ],
                              ))
                        ],
                      )
                    ],
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
