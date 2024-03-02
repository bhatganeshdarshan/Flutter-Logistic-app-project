import 'package:flutter/material.dart';

class DrawerItems extends StatelessWidget {
  const DrawerItems({super.key});

  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        ListTile(
          leading: const Icon(
            Icons.home,
            size: 30,
          ),
          title: const Text(
            'Home',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
          ),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(
            Icons.wallet,
            size: 30,
          ),
          title: const Text(
            'Wallet',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
          ),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(
            Icons.delivery_dining,
            size: 30,
          ),
          title: const Text(
            'Track Order',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
          ),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(
            Icons.settings,
            size: 30,
          ),
          title: const Text(
            'Setting',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
          ),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(
            Icons.info_outline,
            size: 30,
          ),
          title: const Text(
            'About',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
          ),
          onTap: () {},
        ),
      ],
    );
  }
}
