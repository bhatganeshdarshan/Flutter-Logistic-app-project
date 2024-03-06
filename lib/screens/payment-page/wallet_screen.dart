import 'package:flutter/material.dart';

class WalletScreen extends StatelessWidget{
  const WalletScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(

        appBar: AppBar(
        title: Text("Payment"),

      ), body: const Center(
    child: Text('Order Page'))
    );
  }
  
}