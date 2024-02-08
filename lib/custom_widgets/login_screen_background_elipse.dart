import 'package:flutter/material.dart';

Widget loginBackgroundShape(double height, double width) {
  return Container(
    height: height * 0.6,
    width: width,
    decoration: const BoxDecoration(
      color: Colors.transparent,
      image: DecorationImage(
          image: AssetImage('assets/images/login_background.png'),
          fit: BoxFit.cover),
    ),
  );
}
