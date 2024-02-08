import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget loginFormDetails() {
  return Container(
    alignment: Alignment.topLeft,
    padding: const EdgeInsets.symmetric(horizontal: 25),
    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Welcome , Please Login to continue",
            style: GoogleFonts.poppins(fontSize: 12),
          ),
          const SizedBox(
            height: 15,
          ),
          Text(
            "Please Enter Your Mobile Number",
            style:
                GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 40,
          ),
          Container(
            width: double.infinity,
            height: 70,
            decoration: BoxDecoration(
              boxShadow: const [
                BoxShadow(
                  color: Color.fromARGB(30, 0, 0, 0),
                  spreadRadius: 1,
                  blurRadius: 4,
                ),
              ],
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(children: [
              Expanded(
                flex: 1,
                child: Container(),
              ),
              Container(
                width: 1,
                height: 60,
                color: const Color.fromARGB(30, 0, 0, 0),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Enter Your Mobile Number",
                        hintStyle: TextStyle(
                          color: Colors.grey,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
              ),
            ]),
          ),
          const SizedBox(
            height: 40,
          ),
          RichText(
              text: TextSpan(
                  style: GoogleFonts.poppins(color: Colors.black, fontSize: 12),
                  children: [
                const TextSpan(text: "By Logging in you are accepting our "),
                TextSpan(
                  text: "Terms and Conditions",
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                ),
              ])),
        ],
      ),
    ),
  );
}
