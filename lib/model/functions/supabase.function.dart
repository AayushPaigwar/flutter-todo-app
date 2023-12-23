// ignore_for_file: avoid_print

import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseFunction {
  Future<List<Map<String, dynamic>>> getCountries() async {
    final response = await Supabase.instance.client.from('countries').select();
    if (response.error != null) {
      print('Error fetching countries: ${response.error!.message}');
      return [];
    }
    return response.data as List<Map<String, dynamic>>;
  }

  Future<List<Map<String, dynamic>>> addCity(String city, String name) async {
    final response = await Supabase.instance.client.from('countries').insert(
      [
        {'city': city, 'name': name},
      ],
    ).select();
    if (response.error != null) {
      print('Error adding city: ${response.error!.message}');
      return [];
    }
    return response.data as List<Map<String, dynamic>>;
  }
}

// Error: NoSuchMethodError: Class 'List <dynamic>' has no instance getter 'error'.
// Receiver: Instance(length:27) of '_GrowableList'
// Tried calling: error

