import 'package:flutter/material.dart';
import 'package:weight_tracker/models/weight_entry.dart';

class WeightEntryTile extends StatelessWidget {
  final WeightEntry entry;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const WeightEntryTile({
    Key? key,
    required this.entry,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('${entry.userWeight} lbs'),
      subtitle: Text('Logged on: ${entry.dateCreated.toString()}'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            onPressed: onEdit,
            icon: const Icon(Icons.edit),
          ),
          IconButton(
            onPressed: onDelete,
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
    );
  }
}
