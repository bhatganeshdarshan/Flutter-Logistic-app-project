import 'package:flutter/material.dart';
import 'package:logisticapp/custom_widgets/drawer_items.dart';
import 'package:logisticapp/custom_widgets/drawer_profile_container.dart';
import 'package:logisticapp/order_track/track_order.dart';
import 'package:logisticapp/screens/about_screen.dart';
import 'package:logisticapp/screens/drawer.dart';
import 'package:logisticapp/screens/setting_screens.dart';
import 'package:logisticapp/screens/wallet_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
<<<<<<< HEAD
  List<ListTile> drawerItems = [
    ListTile(
      leading: const Icon(Icons.account_box),
      title: const Text("Profile"),
      onTap: () {},
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerProfileHeader(),
            const SizedBox(
              height: 20,
            ),
            ListView.builder(
              itemCount: drawerItems.length,
              itemBuilder: (context, index) {
                return DrawerItems(context, drawerItems[index]);
              },
            )
          ],
        ),
=======
  void setScreen(String activeScreen) {
    if (activeScreen == 'home') {
      Navigator.of(context).pop();
    } else if (activeScreen == 'wallet') {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => WalletScreen(setScreen: setScreen),
        ),
      );
    } else if (activeScreen == 'track') {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => TrackOrder(),
        ),
      );
    } else if (activeScreen == 'setting') {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => SettingScreen(setScreen: setScreen),
        ),
      );
    } else if (activeScreen == 'about') {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => AboutScreen(setScreen: setScreen),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(
        setScreen: setScreen,
>>>>>>> origin/main
      ),
      appBar: AppBar(
        title: const Center(
          child: Text("App logo"),
        ),
      ),
      body: const SingleChildScrollView(
        child: Column(
          children: [],
        ),
      ),
    );
  }
}
