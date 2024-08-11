import 'dart:developer';

import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseFunction {
  // insert data
  static Future<bool> insertData(String email, String name) async {
    try {
      final response = await Supabase.instance.client.from('todo-list').insert([
        {'email': email, 'name': name},
      ]);

      if (response == null) {
        log('Response: $response');
        return true;
      } else {
        log('Error adding data: $response');
        return false;
      }
    } catch (e) {
      log('Error adding email: $e');
      return false;
    }
  }

  // delete data
  static Future<bool> deleteData(int id) async {
    await Supabase.instance.client.from('todo-list').delete().match({'id': id});
    return true;
  }

  // fetch data
  static fetchData() async {
    Supabase.instance.client.from('todo-list').stream(primaryKey: ['id']);
  }

  // update data
  static Future<void> updateData(int id, String email, String name) async {
    await Supabase.instance.client.from('todo-list').upsert({
      'id': id,
      'email': email,
      'name': name,
    });
  }
}
