import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/services.dart';
import 'package:logisticapp/user_auth/authentication_service.dart';
import 'package:logisticapp/user_auth/otp_verify.dart';
import 'package:firebase_auth/firebase_auth.dart';

Widget loginFormDetails(BuildContext context) {
  final numbercontroller = TextEditingController();
  CountryCode _countryCode = CountryCode(code: 'IN', dialCode: '+91');
  final _authenticationService = AuthenticationService();

  return Container(
    alignment: Alignment.topLeft,
    padding: const EdgeInsets.symmetric(horizontal: 25),
    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Welcome , Please Login to continue",
            style: GoogleFonts.poppins(fontSize: 12),
          ),
          const SizedBox(
            height: 15,
          ),
          Text(
            "Please Enter Your Mobile Number",
            style:
                GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 40,
          ),
          Container(
            width: double.infinity,
            height: 70,
            decoration: BoxDecoration(
              boxShadow: const [
                BoxShadow(
                  color: Color.fromARGB(30, 0, 0, 0),
                  spreadRadius: 5,
                  blurRadius: 3,
                ),
              ],
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(children: [
              Expanded(
                flex: 3,
                child: Container(
                  child: const CountryCodePicker(
                    initialSelection: 'IN',
                    showCountryOnly: false,
                    showOnlyCountryWhenClosed: false,
                    alignLeft: false,
                  ),
                ),
              ),
              Container(
                width: 1,
                height: 60,
                color: const Color.fromARGB(30, 0, 0, 0),
              ),
              Expanded(
                flex: 6,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    controller: numbercontroller,
                    keyboardType: TextInputType.phone,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter your phone number',
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                // onPressed: () async {
                //   await FirebaseAuth.instance.verifyPhoneNumber(
                //       verificationCompleted:
                //           (PhoneAuthCredential credential) {},
                //       verificationFailed: (FirebaseAuthException ex) {},
                //       codeSent: (String verificationId, int? resendToken) {
                //         Navigator.push(
                //           context,
                //           MaterialPageRoute(
                //               builder: (context) => OtpVerify(
                //                     verificationId: verificationId,
                //                   )),
                //         );
                //       },
                //       codeAutoRetrievalTimeout: (String verificationId) {},
                //       phoneNumber: "+91${numbercontroller.text}");
                // },
                onPressed: () async {
                  await _authenticationService.signInUser(
                      phoneNumber: "91${numbercontroller.text}");
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => OtpVerify(
                                phoneController:
                                    "91${numbercontroller.text.toString()}",
                              )));
                },
                style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue[300],
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(10)),
                child: const Icon(Icons.arrow_forward_rounded),
              ),
            ]),
          ),
          const SizedBox(
            height: 40,
          ),
          RichText(
              text: TextSpan(
                  style: GoogleFonts.poppins(color: Colors.black, fontSize: 12),
                  children: [
                const TextSpan(text: "By Logging in you are accepting our "),
                TextSpan(
                  text: "Terms and Conditions",
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                ),
              ])),
        ],
      ),
    ),
  );
}
