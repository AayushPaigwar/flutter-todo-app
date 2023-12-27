// ignore_for_file: avoid_print

import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseFunction {
  //add City
  Future<List<Map<String, dynamic>>> addCity(String city, String name) async {
    try {
      final response = await Supabase.instance.client.from('countries').insert(
        [
          {'city': city, 'name': name},
        ],
      ).select();

      if (response is List && response.isNotEmpty) {
        print('Response: $response');
        return response.cast<Map<String, dynamic>>();
      } else {
        print('Unexpected response: $response');
        return [];
      }
    } catch (e) {
      print('Error adding city: $e');
      return [];
    }
  }

  //Delete City
  deleteData(int id) async {
    await Supabase.instance.client.from('countries').delete().match(
      {'id': id},
    );
  }

  //fetch city

  Future<List<Map<String, dynamic>>> fetchData() async {
    final response = await Supabase.instance.client.from('countries').select();

    if (response is! List) {
      print('Error fetching countries: Unexpected response format');
      return [];
    }
    final List<dynamic> responseData = response;

    /* To fix - error: type 'List<dynamic>' is not a subtype of type 'List<Map<String, dynamic>>' in type cast */

    // Convert dynamic list to List<Map<String, dynamic>>
    final List<Map<String, dynamic>> resultList =
        List<Map<String, dynamic>>.from(responseData);

    return resultList;
  }

// error: type 'List<dynamic>' is not a subtype of type 'List<Map<String, dynamic>>' in type cast

  //Update Data
  updateData(int id, String city, String name) async {
    await Supabase.instance.client.from('countries').upsert(
      {'id': id, 'city': city, 'name': name},
    );
  }

// Error: NoSuchMethodError: Class 'List <dynamic>' has no instance getter 'error'.
// Receiver: Instance(length:27) of '_GrowableList'
// Tried calling: error
}
