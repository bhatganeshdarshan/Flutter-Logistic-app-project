import 'package:flutter/material.dart';
import 'package:logisticapp/screens/account-page/about_screen.dart';
import 'package:logisticapp/screens/account-page/setting_screens.dart';

import '../drawer.dart';

// class myaccount extends StatefulWidget {
//   const myaccount({super.key});

//   @override
//   State<myaccount> createState() => _myaccountState();
// }

// class _myaccountState extends State<myaccount> {
//   void setScreen(String activeScreen) {
//     if (activeScreen == 'setting') {
//       Navigator.of(context).push(
//         MaterialPageRoute(
//           builder: (ctx) => SettingScreen(setScreen: setScreen),
//         ),
//       );
//     } else if (activeScreen == 'about') {
//       Navigator.of(context).push(
//         MaterialPageRoute(
//           builder: (ctx) => AboutScreen(setScreen: setScreen),
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Account '),
//       ),
//       body: MyDrawer(
//       setScreen: setScreen,
//     ),
//     );
//   }
// }

Widget myAccount() {
  return const Center(child: Text("my account"));
}
