import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
              return Card(
                // color: isExpanded ? ApplicationColors.mainThemeBlue : null,
                child: InkWell(
                  child: ExpansionTile(
                    maintainState: true,
                    // tilePadding: EdgeInsets.only(bottom: 40),
                    backgroundColor:
                        isExpanded ? null : ApplicationColors.mainThemeBlue,
                    onExpansionChanged: (value) {
                      setState(() {
                        isExpanded = value;
                      });
                      print(isExpanded);
                    },
                    title: Text(
                      orders[index]['item_name'],
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                      ),
                    ),
                    trailing: Column(
                      children: [
                        Text(
                          "₹${orders[index]['amount']}",
                          style: GoogleFonts.poppins(fontSize: 12),
                        ),
                        isExpanded
                            ? const Icon(Icons.arrow_drop_up)
                            : const Icon(Icons.arrow_drop_down)
                      ],
                    ),
                    children: [
                      Text(orders[index]['user_phone']),
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
