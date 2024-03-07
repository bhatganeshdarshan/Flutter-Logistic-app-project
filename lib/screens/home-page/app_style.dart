import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle appStyle(double size,Color color,FontWeight fw){
  return GoogleFonts.poppins(
    fontSize: size,color: color,fontWeight: fw
  );
}