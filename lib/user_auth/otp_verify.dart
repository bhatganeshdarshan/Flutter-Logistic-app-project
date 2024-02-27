import 'package:flutter/material.dart';
import 'package:logisticapp/custom_widgets/login_screen_background_elipse.dart';
import 'package:logisticapp/custom_widgets/otp_details.dart';

class OtpVerify extends StatefulWidget {
  OtpVerify({super.key, required this.verificationId});
  final String verificationId;
  @override
  State<OtpVerify> createState() => _OtpVerifyState();
}

class _OtpVerifyState extends State<OtpVerify> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                loginBackgroundShape(height, width),
                const SizedBox(
                  height: 40,
                ),
                otpDetails(context, widget.verificationId),
              ],
            ),
          ),
          backButtonWidget(context),
        ],
      ),
    );
  }

  Positioned backButtonWidget(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      top: 0,
      child: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: Container(
          margin: const EdgeInsets.all(4),
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(8),
              alignment: Alignment.topLeft,
              shape: const CircleBorder(),
              foregroundColor: Colors.white,
              backgroundColor: Colors.blue[300],
            ),
            child: const Center(child: Icon(Icons.arrow_back)),
          ),
        ),
      ),
    );
  }
}
