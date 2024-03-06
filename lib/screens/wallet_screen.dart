import 'package:flutter/material.dart';
import 'package:logisticapp/screens/drawer.dart';

class WalletScreen extends StatelessWidget{
  const WalletScreen({super.key, required this.setScreen});
  
  final void Function(String identifier) setScreen;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(setScreen: setScreen),
        appBar: AppBar(
        title: const Center(
          child: Text("Wallet"),
        ),
      ),
    );
  }
  
}