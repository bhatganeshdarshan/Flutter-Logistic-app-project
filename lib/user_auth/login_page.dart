import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logisticapp/custom_widgets/login_screen_background_elipse.dart';
import 'package:logisticapp/custom_widgets/login_screen_details_form.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              loginBackgroundShape(height, width),
              const SizedBox(
                height: 40,
              ),
              loginFormDetails(),
            ],
          ),
        ),
      ),
    );
  }
}
