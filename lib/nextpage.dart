import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:supa_base/model/functions/supabase.function.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NextPage extends StatelessWidget {
  //Add City function
  final _futureadd = SupabaseFunction();
  
  //get Countries Data to Screen
  final _future = Supabase.instance.client
      .from('countries')
      .select<List<Map<String, dynamic>>>();

  NextPage({super.key});

  void _showAddCityDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController cityController = TextEditingController();
        TextEditingController nameController = TextEditingController();

        return AlertDialog(
          title: const Text('Add City'),
          content: SizedBox(
            height: MediaQuery.of(context).size.height * 0.2,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Column(
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
                  _futureadd.addCity(cityController.text, nameController.text);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cities'),
        centerTitle: true,
        
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: Supabase.instance.client
                  .from('countries')
                  .stream(primaryKey: ['id']),
              // future: _future,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final todotable = snapshot.data!;
                return Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.all(10),
                  height: MediaQuery.of(context).size.height * 0.1,
                  decoration: const BoxDecoration(
                    color: Colors.white60,
                    border: Border.fromBorderSide(
                      BorderSide(
                        color: Colors.black26,
                        width: 1,
                      ),
                    ),
                    // shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: ListView.builder(
                    itemCount: todotable.length,
                    itemBuilder: ((context, index) {
                      final todo = todotable[index];
                      return Column(
                        children: [
                          Slidable(
                            endActionPane: ActionPane(
                              motion: const StretchMotion(),
                              children: [
                                SlidableAction(
                                  borderRadius: BorderRadius.circular(10),
                                  onPressed: (context) {
                                    _futureadd.deleteData(todo['id']);
                                  },
                                  backgroundColor: Colors.red,
                                  icon: EneftyIcons.trash_outline,
                                ),
                              ],
                            ),
                            child: ListTile(
                              title: Text(todo['name']),
                              subtitle: Text(todo['city']),
                              trailing: IconButton(
                                onPressed: () async {
                                  _showUpdateDialog(context, todo);
                                },
                                icon: const Icon(Icons.edit),
                              ),
                            ),
                          ),
                          const Divider()
                        ],
                      );
                    }),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(40.0),
            child: FloatingActionButton(
              onPressed: () {
                _showAddCityDialog(context);
              },
              child: const Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }
}

void _showUpdateDialog(BuildContext ctx, Map<String, dynamic> todo) {
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
                decoration: const InputDecoration(labelText: 'City Name'),
              ),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
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
