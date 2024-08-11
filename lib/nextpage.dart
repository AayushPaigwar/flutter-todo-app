import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:supa_base/supabase_function.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NextPage extends StatelessWidget {
  const NextPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To-do List'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: Supabase.instance.client
                  .from('todo-list')
                  .stream(primaryKey: ['id']),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final todoList = snapshot.data!;
                return ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: todoList.length,
                  itemBuilder: (context, index) {
                    final todo = todoList[index];
                    return Column(
                      children: [
                        Slidable(
                          endActionPane: ActionPane(
                            motion: const ScrollMotion(),
                            children: [
                              SlidableAction(
                                borderRadius: BorderRadius.circular(10),
                                onPressed: (context) {
                                  SupabaseFunction.deleteData(todo['id']);
                                },
                                backgroundColor: Colors.red,
                                icon: EneftyIcons.trash_outline,
                              ),
                            ],
                          ),
                          child: ListTile(
                            title: Text(todo['name']),
                            subtitle: Text(todo['email']),
                            trailing: IconButton(
                              onPressed: () => showUpdateDialog(context, todo),
                              icon: const Icon(EneftyIcons.edit_2_outline),
                            ),
                          ),
                        ),
                        const Divider(),
                      ],
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(40.0),
            child: FloatingActionButton(
              backgroundColor: Colors.white12,
              onPressed: () => showAddDataDialog(context),
              child: const Icon(EneftyIcons.add_outline),
            ),
          ),
        ],
      ),
    );
  }

  // Add data dialog
  void showAddDataDialog(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Task'),
          content: SizedBox(
            height: MediaQuery.of(context).size.height * 0.2,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Task Title'),
                ),
                TextField(
                  controller: emailController,
                  decoration:
                      const InputDecoration(labelText: 'Task Description'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (emailController.text.isNotEmpty &&
                    nameController.text.isNotEmpty) {
                  SupabaseFunction.insertData(
                      emailController.text, nameController.text);
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
                      width: 300.0,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 8.0),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
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

  // Show dialog for update
  void showUpdateDialog(BuildContext context, Map<String, dynamic> todo) {
    TextEditingController emailController =
        TextEditingController(text: todo['name']);
    TextEditingController nameController =
        TextEditingController(text: todo['email']);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Update Task'),
          content: SizedBox(
            height: MediaQuery.of(context).size.height * 0.25,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Column(
              children: [
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Task Title',
                  ),
                ),
                const SizedBox(height: 30),
                TextField(
                  maxLines: 3,
                  controller: nameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Task Description',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (emailController.text.isNotEmpty &&
                    nameController.text.isNotEmpty) {
                  SupabaseFunction.updateData(
                      todo['id'], nameController.text, emailController.text);
                  Navigator.of(context).pop();
                  SupabaseFunction.fetchData();
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
                      width: 300.0,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 8.0),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  );
                }
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }
}
