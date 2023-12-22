import 'package:flutter/material.dart';
import 'package:supa_base/model/functions/supabase.function.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NextPage extends StatelessWidget {
  final _future = SupabaseFunction();

  NextPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cities'),
      ),
      body: FutureBuilder(
        future: _future.getCountries(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final todotable = snapshot.data!;

          return Column(
            children: [
              ListView.builder(
                itemCount: todotable.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(todotable[index]['city']),
                    subtitle: Text(todotable[index]['name']),
                  );
                },
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddCityDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddCityDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController cityController = TextEditingController();
        TextEditingController nameController = TextEditingController();

        return AlertDialog(
          title: const Text('Add City'),
          content: Column(
            children: [
              TextField(
                controller: cityController,
                decoration: const InputDecoration(labelText: 'City Name'),
              ),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
            ],
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
                String city = cityController.text.trim();
                String name = nameController.text.trim();
                if (city.isNotEmpty && name.isNotEmpty) {
                  _future.addCity(city, name).then(
                    (result) {
                      Navigator.of(context).pop();
                    },
                  );
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
