import 'package:flutter/material.dart';
import 'package:logisticapp/providers/supabase_manager.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final orderData = SupabaseOrders();
  late dynamic orders;

  @override
  void initState() {
    getOrders();
    super.initState();
  }

  getOrders() async {
    orders = await orderData.getOrders();
    print("orders : $orders");
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 30),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            Text("order no : ${index + 1}"),
            Text("item name : ${orders[index]['item_name']}"),
            Text("ph.no : ${orders[index]['user_phone']}"),
            Text("pick location : ${orders[index]['pick_location']}"),
            Text("drop location : ${orders[index]['drop_location']}"),
            Text("amount : ${orders[index]['amount']}"),
            Text("driver : ${orders[index]['driver_name']}"),
            Text("driver phone : ${orders[index]['driver_phone']}"),
            const SizedBox(
              height: 30,
            )
          ],
        );
      },
    );
  }
}
