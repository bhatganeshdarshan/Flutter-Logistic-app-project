import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseManager {
  Future readData() async {
    var response = await Supabase.instance.client.from('vehicles').select();
    return response;
  }
}
