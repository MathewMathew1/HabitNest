import 'package:flutter/material.dart';
import 'package:habitata_app/models/preferences/user_preferences.dart';
import 'package:provider/provider.dart';

class PreferencesScreen extends StatelessWidget {
  const PreferencesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final prefs = Provider.of<UserPreferences>(context);
    final controller = TextEditingController(
      text: prefs.reportGenerationHour.toString(),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Preferences')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Report creation hour (0–23)',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final value = controller.text.trim();
                final hour = int.tryParse(value);
                if (hour != null && hour >= 0 && hour <= 23) {
                  prefs.setReportGenerationHour(hour);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Preference updated')),
                  );
                } else {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('Invalid hour')));
                }
              },
              child: const Text('Save Preferences'),
            ),
          ],
        ),
      ),
    );
  }
}
