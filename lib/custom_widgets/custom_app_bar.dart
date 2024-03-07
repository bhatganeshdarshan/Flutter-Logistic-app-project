import 'package:flutter/material.dart';

PreferredSizeWidget? customAppbar() {
  return AppBar(
    elevation: 3,
    actions: <Widget>[
      IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
      IconButton(onPressed: () {}, icon: const Icon(Icons.person)),
    ],
  );
}
