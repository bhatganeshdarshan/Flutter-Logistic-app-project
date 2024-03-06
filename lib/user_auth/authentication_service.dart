import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase/supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:logisticapp/utils/app_constants.dart';

class AuthenticationService {
  // final supabaseClient = SupabaseClient(supabaseUrl, supabaseKey);
  Future signInUser({required String phoneNumber}) async {
    await Supabase.instance.client.auth.signInWithOtp(
      phone: phoneNumber,
      shouldCreateUser: true,
    );
  }

  Future<User?> verifyUser(
      {required String otp, required String phoneNumber}) async {
    try {
      final response = await Supabase.instance.client.auth.verifyOTP(
        token: otp,
        type: OtpType.sms,
        phone: phoneNumber,
      );
      print(response.user);
      return response.user;
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }
}
