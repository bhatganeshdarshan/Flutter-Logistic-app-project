import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget homePage() {
  List<int> testList = [1, 2, 3, 4, 5];
  return Column(
    children: [
      Container(
        padding: const EdgeInsets.symmetric(vertical: 26, horizontal: 20),
        // color: Colors.amber,
        height: 220,
        width: double.infinity,
        child: Card(
          elevation: 4,
          shadowColor: Colors.black,
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Icon(
                      Icons.gps_fixed,
                      color: Color(0xff9BCF53),
                    ),
                    Text(
                      "Enter Pickup Location",
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                      ),
                    ),
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.add,
                          color: Color(0xff9BCF53),
                          size: 30,
                        )),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Icon(
                      Icons.gps_not_fixed_outlined,
                      color: Color(0xff9BCF53),
                    ),
                    Text(
                      "Enter Drop Location    ",
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                      ),
                    ),
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.add,
                          color: Color(0xff9BCF53),
                          size: 30,
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      Expanded(
        child: ListView.builder(
          itemCount: testList.length,
          itemBuilder: (context, index) {
            return Container(
              // color: Colors.red,
              height: 180,
              width: double.infinity,
              child: Card(
                // color: Colors.green,
                shadowColor: Colors.black,
                elevation: 5,
                margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                child: Text("$index"),
              ),
            );
          },
        ),
      ),
    ],
  );
}
