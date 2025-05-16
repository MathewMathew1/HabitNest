import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeleteDataScreen extends StatelessWidget {
  const DeleteDataScreen({super.key});

  void deleteAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  void _confirmDeletion(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Are you sure?'),
            content: const Text(
              'This will permanently delete all data on this device. '
              'This action cannot be undone.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () {
                  Navigator.of(ctx).pop(); // Close dialog
                  deleteAllData(); // Trigger delete
                  
                },
                child: const Text('Delete'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reset App Data')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '⚠️ Deleting your data',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              'If you delete all data, everything you’ve recorded will be permanently erased from your device. To see changes you will need to restart app',
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () => _confirmDeletion(context),
                child: const Text('Delete All Data'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
