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
                    color: Colors.black12,
                    border: Border.fromBorderSide(
                      BorderSide(
                        color: Colors.white12,
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
                                  showUpdateDialog(context, todo);
                                },
                                icon: const Icon(EneftyIcons.edit_2_outline),
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
              shape: const CircleBorder(),
              backgroundColor: Colors.white12,
              onPressed: () {
                showAddCityDialog(context);
              },
              child: const Icon(EneftyIcons.add_outline),
            ),
          ),
        ],
      ),
    );
  }
}
