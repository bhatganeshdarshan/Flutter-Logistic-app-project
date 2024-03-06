import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logisticapp/controllers/tab_index_controller.dart';


class HomePage extends StatelessWidget {
 const  HomePage({super.key});





   @override
  Widget build(BuildContext context) {
    final controller = Get.put(TabIndexController());

    return Scaffold(

          appBar: AppBar(
            title:Text("EasyLogistics"),

          ),
          body:const Center(child :Text('Home page'))
        );
  }
}
