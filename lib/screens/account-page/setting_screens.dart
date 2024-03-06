import 'package:flutter/material.dart';
import 'package:logisticapp/screens/drawer.dart';

class SettingScreen extends StatelessWidget {
  
  const SettingScreen({super.key, required this.setScreen});
  
  final void Function(String identifier) setScreen;

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        appBar: AppBar(
        title: const Center(
          child: Text("Settings"),
        ),
      ),
    );
  }
}
