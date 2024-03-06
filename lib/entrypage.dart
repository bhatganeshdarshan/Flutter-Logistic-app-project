import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logisticapp/screens/account-page/account.dart';
import 'package:logisticapp/screens/drawer.dart';
import 'package:logisticapp/screens/home-page/home.dart';
import 'package:logisticapp/screens/order-page/order.dart';
import 'package:logisticapp/screens/payment-page/wallet_screen.dart';

import 'constants/constants.dart';
import 'controllers/tab_index_controller.dart';

class MainScreen extends StatelessWidget {
   MainScreen({super.key});

   List<Widget> pageList= const [
     HomePage(),
     myorder(),
     WalletScreen(),
     myaccount(),
   ];

   @override
   Widget build(BuildContext context) {
     final controller = Get.put(TabIndexController());

     return Obx(() => Scaffold(
       body: Stack(children: [
         pageList[controller.tabIndex],
         Align(
           alignment: Alignment.bottomCenter,
           child: Theme(
             data: Theme.of(context).copyWith(canvasColor: kPrimary),
             child: BottomNavigationBar(
               showUnselectedLabels: true,
               unselectedIconTheme:
               const IconThemeData(color: Colors.black38),
               selectedIconTheme: const IconThemeData(color: Colors.white),
               unselectedItemColor: Colors.black38,
               selectedItemColor: Colors.white,
               onTap: (value) {
                 controller.setTabIndex = value;
               },
               currentIndex: controller.tabIndex,
               items: const [
                 BottomNavigationBarItem(
                     icon: Icon(Icons.home), label: 'Home'),
                 BottomNavigationBarItem(
                     icon:Badge(
                         label: Text('1'),
                         child: Icon(Icons.assignment_outlined)), label: 'Order'),
                 BottomNavigationBarItem(
                     icon: Icon(Icons.payment), label: 'Payment'),
                 BottomNavigationBarItem(
                     icon: Icon(Icons.person), label: 'Account'),
               ],
             ),
           ),
         )
       ]),
     ));
   }
}
