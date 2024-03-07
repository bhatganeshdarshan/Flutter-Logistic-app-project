import 'package:flutter/material.dart';

Widget homePage() {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 26, horizontal: 20),
    // color: Colors.amber,
    height: 200,
    width: double.infinity,
    child: Card(
      elevation: 4,
      shadowColor: Colors.black,
      child: Text("hello"),
    ),
  );
}
