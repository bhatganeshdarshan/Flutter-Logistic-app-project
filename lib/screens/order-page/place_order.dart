// import 'package:flutter/material.dart';
//
// class PlaceOrder extends StatefulWidget {
//   const PlaceOrder({super.key});
//
//   @override
//   State<PlaceOrder> createState() => _PlaceOrderState();
// }
//
// class _PlaceOrderState extends State<PlaceOrder> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: const Text("Checkout"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           children: [
//             SizedBox(
//               height: 80,
//               width: double.infinity,
//               child: Card(
//                 elevation: 1,
//                 color: Colors.white,
//                 child: Text("Order details"),
//               ),
//             ),
//             const SizedBox(
//               height: 20,
//             ),
//             SizedBox(
//               height: 160,
//               width: double.infinity,
//               child: Card(
//                 elevation: 1,
//                 color: Colors.white,
//                 child: Text("Order summary"),
//               ),
//             ),
//             const SizedBox(
//               height: 20,
//             ),
//             SizedBox(
//               height: 60,
//               width: double.infinity,
//               child: Card(
//                 elevation: 1,
//                 color: Colors.white,
//                 child: Text("coupon code"),
//               ),
//             ),
//             const SizedBox(
//               height: 20,
//             ),
//             SizedBox(
//               height: 220,
//               width: double.infinity,
//               child: Card(
//                 elevation: 1,
//                 color: Colors.white,
//                 child: Text("payment method"),
//               ),
//             ),
//             const SizedBox(
//               height: 20,
//             ),
//             FilledButton(
//               onPressed: () {},
//               style: FilledButton.styleFrom(
//                 minimumSize: const Size.fromHeight(48),
//                 backgroundColor: Colors.blue[700],
//               ),
//               child: const Text("Pay Now"),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
