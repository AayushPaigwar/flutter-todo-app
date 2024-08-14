import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:supabase_todo/supabase_function.dart';

class TodoScreen extends StatelessWidget {
  const TodoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo App'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () => showTaskDialog(context),
        child: const Icon(EneftyIcons.add_outline),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: SupabaseFunction.fetchData(),
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
                              onPressed: () =>
                                  showTaskDialog(context, todo: todo),
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
        ],
      ),
    );
  }

  void showTaskDialog(BuildContext context, {Map<String, dynamic>? todo}) {
    final isUpdate = todo != null;
    final nameController =
        TextEditingController(text: isUpdate ? todo['name'] : '');
    final emailController =
        TextEditingController(text: isUpdate ? todo['email'] : '');

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(isUpdate ? 'Update Task' : 'Add Task'),
          content: SizedBox(
            height: MediaQuery.of(context).size.height * 0.25,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Task Title'),
                ),
                const SizedBox(height: 30),
                TextField(
                  maxLines: 3,
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
                if (nameController.text.isNotEmpty &&
                    emailController.text.isNotEmpty) {
                  if (isUpdate) {
                    SupabaseFunction.updateData(
                        todo['id'], nameController.text, emailController.text);
                  } else {
                    SupabaseFunction.insertData(
                        emailController.text, nameController.text);
                  }
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
                      width: 500.0,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  );
                }
              },
              child: Text(isUpdate ? 'Update' : 'Add'),
            ),
          ],
        );
      },
    );
  }
}
