import 'dart:io';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:logisticapp/constants/constants.dart';
import 'package:logisticapp/entrypage.dart';
import 'package:logisticapp/screens/home-page/home.dart';

import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:logisticapp/user_auth/login_page.dart';
import 'package:firebase_core/firebase_core.dart';


//for the default page to be open you can modify it here
Widget defaultPage= MainScreen();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Set the fit size (Find your UI design, look at the dimensions of the device screen and fill it in,unit in dp)
    return ScreenUtilInit(
      designSize: const Size(375, 825),
      minTextAdapt: true,
      splitScreenMode: true,
      // Use builder only if you need to use library outside ScreenUtilInit context
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Logistic',
          // You can use the library anywhere in the app even in theme
          theme: ThemeData(
            scaffoldBackgroundColor:kOffWhite,
            iconTheme: IconThemeData(color: kDark),
            primarySwatch: Colors.grey
           ),
          home: child,
        );
      },
      child:  MainScreen(),
    );
  }
}
