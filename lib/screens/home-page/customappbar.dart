import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:logisticapp/constants/constants.dart';
import 'package:logisticapp/screens/home-page/app_style.dart';
import 'package:logisticapp/screens/home-page/reusable_text.dart';

class customappbar extends StatelessWidget {
  const customappbar({super.key});

  @override
  Widget build(BuildContext context) {
    return
      Container(
        padding:  EdgeInsets.symmetric(horizontal: 12.w,vertical: 6.h),
        height: 110.h,
        width: width,
        color: kOffWhite,
        child: Container(
          margin: EdgeInsets.only(top: 20.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
               crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  CircleAvatar(
                    radius: 23.r,
                    backgroundColor: kRed,
                    backgroundImage: AssetImage("assets/images/icons8-location.gif"),

                  ),

                  Padding(
                    padding: EdgeInsets.only(bottom: 6.h,left: 12.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ReusableText(text: "Delivery to", style: appStyle(12, kTertiary, FontWeight.w600)),
                        SizedBox(
                          width: width*0.65,
                          child: Text("F302,Doddalballapur Main Rd,Bengaluru,Karnataka",
                            overflow: TextOverflow.ellipsis,
                            style: appStyle(11, kGray, FontWeight.normal),),
                        ),



                      ],
                    ),
                  ),
                   Text(getTimeOfDay(),style: const TextStyle(fontSize:35 ),)
                ],
              ),
            ],
          ),
        ),

      );
  }
}

  String getTimeOfDay(){
   DateTime now =DateTime.now();
   int hour=now.hour;
   if (hour>=0 && hour<12) {
     return '☀️';
   }
   else if(hour >=12  && hour <16){
     return '⛅';
   }else{
     return '🌙';
   }
  }