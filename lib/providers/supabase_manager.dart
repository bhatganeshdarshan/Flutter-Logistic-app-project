import 'package:logisticapp/utils/app_constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseManager {
  Future readData() async {
    var response = await Supabase.instance.client.from('vehicles').select();
    print(response);
    return response;
  }
}

class SupabaseUserManager {
  Future readData() async {
    try {
      var response = await Supabase.instance.client
          .from('users')
          .select()
          .eq('id', userId);
      return response;
    } catch (e) {
      print("error : $e");
    }
  }
}

class SupabaseUpdateProfile {
  Future updateData(String firstName, String lastName) async {
    try {
      await Supabase.instance.client
          .from('users')
          .update({'first_name': firstName}).match({'id': userId});
      await Supabase.instance.client
          .from('users')
          .update({'last_name': lastName}).match({'id': userId});
    } catch (e) {
      print("error while updating data : ${e}");
    }
  }
}
