import 'package:flutter/material.dart';
import 'package:logisticapp/custom_widgets/drawer_items.dart';
import 'package:logisticapp/custom_widgets/drawer_profile_container.dart';

class MyDrawer extends StatelessWidget {

  const MyDrawer({super.key, required this.setScreen});

  final void Function(String identifier) setScreen;
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const DrawerProfileHeader(),
              const SizedBox(
                height:20,
              ),
              DrawerItems(ontap: setScreen),
            ],
          ),
        ),
      );
  }
}