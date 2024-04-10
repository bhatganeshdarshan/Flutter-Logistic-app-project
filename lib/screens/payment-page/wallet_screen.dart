import 'package:flutter/material.dart';
import 'package:logisticapp/screens/payment-page/payment.dart';
num order=5;
Widget myWallet() {
  return  Center(
    child: payment(order: order,),
  );
}
