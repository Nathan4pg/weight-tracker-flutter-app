import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weight_tracker/models/weight_entry.dart';
import 'package:weight_tracker/providers/user_provider.dart';
import 'package:weight_tracker/providers/weight_entry_provider.dart'; // Import your weight log entry model
import 'package:firebase_auth/firebase_auth.dart';
import 'package:weight_tracker/widgets/weight_entry_tile.dart';

class LoggingScreen extends StatefulWidget {
  const LoggingScreen({super.key});

  @override
  State<LoggingScreen> createState() => _LoggingScreenState();
}

class _LoggingScreenState extends State<LoggingScreen> {
  final TextEditingController _weightController = TextEditingController();
  Future<void> signOut(context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, '/sign-in');
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final weightLogsProvider = Provider.of<WeightEntryProvider>(context);

    void showEditDialog(BuildContext context, WeightEntry? entry) {
      showDialog<int>(
        context: context,
        builder: (context) {
          bool isExistingEntry = entry != null;

          if (isExistingEntry) {
            _weightController.value =
                TextEditingValue(text: entry.userWeight.toString());
          }

          return AlertDialog(
            title: const Text('Edit Weight Entry'),
            content: TextField(
              controller: _weightController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(hintText: 'Enter your weight'),
            ),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _weightController.clear();
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  int weight = int.tryParse(_weightController.text) ?? 0;
                  if (weight > 0) {
                    if (isExistingEntry) {
                      WeightEntry updatedEntry = WeightEntry(
                        id: entry.id,
                        userId: entry.userId,
                        userWeight: weight,
                        dateCreated: entry.dateCreated,
                      );

                      weightLogsProvider.updateWeightLog(updatedEntry);
                    } else {
                      weightLogsProvider.addWeightLog(weight);
                    }

                    _weightController.clear();
                    Navigator.of(context).pop();
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          );
        },
      );
    }

    void showDeleteDialog(BuildContext context, WeightEntry entry) {
      showDialog<int>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Delete Weight Entry'),
            content: const Text('This action is irreversible. Are you sure?'),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  weightLogsProvider.deleteWeightLog(entry.id);
                  Navigator.of(context).pop();
                },
                child: const Text('Confirm'),
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showEditDialog(context, null);
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: const SizedBox(width: 0),
        leadingWidth: 0,
        titleSpacing: 15,
        centerTitle: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Weight Logger'),
            const SizedBox(height: 2),
            Text(
              'User: ${userProvider.user!.uid}',
              style: const TextStyle(
                color: Colors.black38,
                fontSize: 10,
              ),
            ),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: OutlinedButton(
              style: ButtonStyle(
                side: MaterialStatePropertyAll(
                  BorderSide(color: Theme.of(context).colorScheme.primary),
                ),
              ),
              child: const Text('sign out'),
              onPressed: () => signOut(context),
            ),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          const SizedBox(height: 10),
          Expanded(
            child: StreamBuilder<List<WeightEntry>>(
              stream: weightLogsProvider.userWeightLogs,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No weight logs found."));
                }

                List<WeightEntry> sortedLogs = snapshot.data!;
                sortedLogs
                    .sort((a, b) => b.dateCreated.compareTo(a.dateCreated));

                return ListView.builder(
                  itemCount: sortedLogs.length,
                  itemBuilder: (context, index) {
                    final entry = sortedLogs[index];
                    return WeightEntryTile(
                      entry: entry,
                      onEdit: () => showEditDialog(context, entry),
                      onDelete: () => showDeleteDialog(context, entry),
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
}
