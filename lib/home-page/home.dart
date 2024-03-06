import 'package:flutter/material.dart';
import 'package:logisticapp/custom_widgets/drawer_items.dart';
import 'package:logisticapp/custom_widgets/drawer_profile_container.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<ListTile> drawerItems = [
    ListTile(
      leading: const Icon(Icons.account_box),
      title: const Text("Profile"),
      onTap: () {},
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerProfileHeader(),
            const SizedBox(
              height: 20,
            ),
            ListView.builder(
              itemCount: drawerItems.length,
              itemBuilder: (context, index) {
                return DrawerItems(context, drawerItems[index]);
              },
            )
          ],
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
