//  IMPORTANT !!! -> Don't Remove commented lines

import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logisticapp/user_auth/authentication_service.dart';
import 'package:pinput/pinput.dart';

import '../screens/home-page/home.dart';

Widget otpDetails(BuildContext context, TextEditingController pinController,
    FocusNode focusNode, String phoneController) {
  final _authenticationService = AuthenticationService();
  const focusedBorderColor = Color.fromRGBO(23, 171, 144, 1);
  const fillColor = Color.fromRGBO(243, 246, 249, 0);
  const borderColor = Color.fromRGBO(23, 171, 144, 0.4);
  final defaultPinTheme = PinTheme(
    width: 56,
    height: 56,
    textStyle: const TextStyle(
      fontSize: 22,
      color: Color.fromRGBO(30, 60, 87, 1),
    ),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(19),
      border: Border.all(color: borderColor),
    ),
  );
  return Container(
    child: SingleChildScrollView(
      child: Column(
        children: [
          Text(
            "Please Enter the OTP",
            style: GoogleFonts.poppins(
                color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
          ),
          const SizedBox(
            height: 30,
          ),
          Form(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: Pinput(
                    length: 6,
                    controller: pinController,
                    focusNode: focusNode,
                    // androidSmsAutofillMethod:
                    //     AndroidSmsAutofillMethod.smsUserConsentApi,
                    // listenForMultipleSmsOnAndroid: true,
                    defaultPinTheme: defaultPinTheme,
                    separatorBuilder: (index) => const SizedBox(width: 8),
                    // validator: (value) {
                    //   return value == verificationId ? null : 'Incorrect OTP';
                    // },
                    hapticFeedbackType: HapticFeedbackType.lightImpact,
                    // onCompleted: (pin) {
                    //   debugPrint('onCompleted: $pin');
                    // },
                    onChanged: (value) {
                      debugPrint('onChanged: $value');
                    },
                    cursor: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 9),
                          width: 22,
                          height: 1,
                          color: focusedBorderColor,
                        ),
                      ],
                    ),
                    focusedPinTheme: defaultPinTheme.copyWith(
                      decoration: defaultPinTheme.decoration!.copyWith(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: focusedBorderColor),
                      ),
                    ),
                    submittedPinTheme: defaultPinTheme.copyWith(
                      decoration: defaultPinTheme.decoration!.copyWith(
                        color: fillColor,
                        borderRadius: BorderRadius.circular(19),
                        border: Border.all(color: focusedBorderColor),
                      ),
                    ),
                    errorPinTheme: defaultPinTheme.copyBorderWith(
                      border: Border.all(color: Colors.redAccent),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[200],
                  ),
                  // onPressed: () async {
                  //   focusNode.unfocus();
                  //   try {
                  //     PhoneAuthCredential credential =
                  //         await PhoneAuthProvider.credential(
                  //             verificationId: verificationId,
                  //             smsCode: pinController.text.toString());
                  //     FirebaseAuth.instance
                  //         .signInWithCredential(credential)
                  //         .then((value) {
                  //       Navigator.pushReplacement(
                  //           context,
                  //           MaterialPageRoute(
                  //               builder: (context) => const HomePage()));
                  //     });
                  //   } catch (ex) {
                  //     log(ex.toString());
                  //   }
                  // },
                  onPressed: () async {
                    focusNode.unfocus();
                    try {
                      print(pinController.text.toString());
                      print(phoneController);
                      await _authenticationService.verifyUser(
                          otp: pinController.text.toString(),
                          phoneNumber: phoneController);
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomePage()));
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Login Failed : $e")));
                    }
                  },
                  child: Text(
                    'Submit',
                    style: GoogleFonts.poppins(
                      color: Colors.black38,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    ),
  );
}
