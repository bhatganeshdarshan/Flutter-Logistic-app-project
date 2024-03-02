import 'package:flutter/material.dart';
import 'package:logisticapp/custom_widgets/drawer_items.dart';
import 'package:logisticapp/custom_widgets/drawer_profile_container.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawer(
        child: SingleChildScrollView(
          child: Column(
            children: [
              DrawerProfileHeader(),
              SizedBox(
                height: 20,
              ),
              DrawerItems(),
            ],
          ),
        ),
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
