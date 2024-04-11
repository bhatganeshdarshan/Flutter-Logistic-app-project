import 'package:flutter/material.dart';
import 'package:logisticapp/entrypage.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
 @override
  void initState(){
   super.initState();
   _navigatetohome();
 }
 
 _navigatetohome()async{
   await Future.delayed(Duration(seconds:5 ),(){});
   Navigator.push(context, MaterialPageRoute(builder: (context)=> MainScreen()));
 }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Set background color
      body: Center(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/splashscreen.gif'),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
