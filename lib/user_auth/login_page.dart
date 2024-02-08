import 'package:flutter/material.dart';
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
    return Container(
      child: Column(
        children: [
          loginBackgroundShape(),
          const SizedBox(
            height: 10,
          ),
          loginFormDetails(),
        ],
      ),
    );
  }
}
