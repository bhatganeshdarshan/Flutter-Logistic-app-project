import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logisticapp/screens/home-page/edit_profile.dart';

class DrawerProfileHeader extends StatefulWidget {
  const DrawerProfileHeader({super.key});

  @override
  State<DrawerProfileHeader> createState() => _DrawerProfileHeaderState();
}

class _DrawerProfileHeaderState extends State<DrawerProfileHeader> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      width: double.infinity,
      height: 250,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.all(10),
            height: 80,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage("assets/images/profile.jpg"),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Ganeshdarshan Bhat",
                style: GoogleFonts.poppins(
                  //fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return const EditProfile();
                    },
                  ));
                },
              ),
            ],
          ),
          const Text(
            "+91-7411151871",
          ),
        ],
      ),
    );
  }
}
