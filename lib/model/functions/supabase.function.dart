// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
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

    /* To fix - error: type 'List<dynamic>' is not a subtype of type 'List<Map<String, dynamic>>' in type cast 
    
       Error: NoSuchMethodError: Class 'List <dynamic>' has no instance getter 'error'.
       Receiver: Instance(length:27) of '_GrowableList'
       Tried calling: error*/

    // Convert dynamic list to List<Map<String, dynamic>>
    final List<Map<String, dynamic>> resultList =
        List<Map<String, dynamic>>.from(responseData);

    return resultList;
  }

  //Update Data
  updateData(int id, String city, String name) async {
    await Supabase.instance.client.from('countries').upsert(
      {'id': id, 'city': city, 'name': name},
    );
  }
}

// _showUpdateDialog
void showUpdateDialog(BuildContext ctx, Map<String, dynamic> todo) {
  TextEditingController cityController =
      TextEditingController(text: todo['name']);
  TextEditingController nameController =
      TextEditingController(text: todo['city']);
  showDialog(
    context: ctx,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Update City'),
        content: SizedBox(
          height: MediaQuery.of(context).size.height * 0.2,
          width: MediaQuery.of(context).size.width * 0.8,
          child: Column(
            children: [
              TextField(
                controller: cityController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'City Name'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (cityController.text.isNotEmpty &&
                  nameController.text.isNotEmpty) {
                SupabaseFunction().updateData(
                    todo['id'], nameController.text, cityController.text);

                Navigator.of(context).pop();
                SupabaseFunction().fetchData();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          'Please fill all fields!',
                          style: TextStyle(fontSize: 17),
                        ),
                      ),
                    ),
                    duration: const Duration(milliseconds: 1500),
                    width: 300.0, // Width of the SnackBar.
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 8.0 // Inner padding for SnackBar content.
                        ),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                );
              }
            },
            child: const Text(
              'Update',
            ),
          ),
        ],
      );
    },
  );
}

// _showAddDialog
void showAddCityDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      TextEditingController nameController = TextEditingController();
      TextEditingController cityController = TextEditingController();

      return AlertDialog(
        title: const Text('Add City'),
        content: SizedBox(
          height: MediaQuery.of(context).size.height * 0.2,
          width: MediaQuery.of(context).size.width * 0.8,
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: cityController,
                decoration: const InputDecoration(labelText: 'City Name'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (cityController.text.isNotEmpty &&
                  nameController.text.isNotEmpty) {
                SupabaseFunction()
                    .addCity(cityController.text, nameController.text);
                Navigator.of(context).pop();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          'Please fill all fields!',
                          style: TextStyle(fontSize: 17),
                        ),
                      ),
                    ),
                    duration: const Duration(milliseconds: 1500),
                    width: 300.0, // Width of the SnackBar.
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 8.0 // Inner padding for SnackBar content.
                        ),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                );
              }
            },
            child: const Text(
              'Add',
            ),
          ),
        ],
      );
    },
  );
}
