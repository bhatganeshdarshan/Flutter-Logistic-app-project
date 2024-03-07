import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:logisticapp/screens/home-page/customappbar.dart';


class HomePage extends StatelessWidget {
 const  HomePage({super.key});





   @override
  Widget build(BuildContext context) {
    return Scaffold(

          appBar: PreferredSize(preferredSize: Size.fromHeight(130.h),child: const customappbar(),),
          body:const Center(child :Text('Home page'))
        );
  }
}
