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

class SupabaseOrders {
  Future getOrders() async {
    try {
      var response = await Supabase.instance.client
          .from('orders')
          .select()
          .eq('user_id', userId);
      return response;
    } catch (e) {
      print("error occured while getting orders : $e");
    }
  }

  Future putOrders(userId, vehicleId, paymentType, pickLocLat, pickLocLong,
      dropLocLat, dropLocLong, fare) async {
    try {
      await Supabase.instance.client.from('available_orders').insert({
        'user_id': userId,
        'vehicle_id': vehicleId,
        'payment_type': paymentType,
        'pickup_loc_lat': pickLocLat,
        'pickup_loc_long': pickLocLong,
        'drop_loc_lat': dropLocLat,
        'drop_loc_long': dropLocLong,
        'fare': fare,
      });
    } catch (e) {
      print("Error : $e");
    }
  }
}
