import 'dart:developer';

import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseFunction {
  // insert data | Create
  static Future<bool> insertData(String email, String name) async {
    try {
      final response = await Supabase.instance.client.from('todo-list').insert(
        {
          'email': email,
          'name': name,
        },
      );

      if (response == null) {
        log('Data Inserted Successfully'); // if response null then success
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

  // fetch data | Read
  static Stream<List<Map<String, dynamic>>> fetchData() {
    return Supabase.instance.client
        .from('todo-list')
        .stream(primaryKey: ['id']);
  }

  // update data | Update
  static Future<void> updateData(int id, String email, String name) async {
    await Supabase.instance.client.from('todo-list').update({
      'email': email,
      'name': name,
    }).eq('id', id);
  }

  // delete data | Delete
  static Future<bool> deleteData(int id) async {
    final response = await Supabase.instance.client
        .from('todo-list')
        .delete()
        .match({'id': id});

    if (response == null) {
      log('Data Deleted Successfully');
      return true;
    }
    return false;
  }
}
