import 'package:flutter/material.dart';

class HelperScreen extends StatelessWidget {
  const HelperScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('How This App Works')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '🛠 Setting Up Your Daily Routine',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Start by selecting your daily habits. You can pick from sample habits or create your own. Each custom habit can be marked as either a good habit (you want to strengthen it) or a bad habit (you want to reduce it).',
            ),
            const SizedBox(height: 24),
            const Text(
              '🔥 Habit Intensity',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'When adding habits, you’ll choose an "intensity" level:\n'
              '- For good habits: how important this habit is to nourish.\n'
              '- For bad habits: how problematic it is (more intense = worse).\n'
              'This affects the weight of each habit in your daily performance.',
            ),
            const SizedBox(height: 24),
            const Text(
              '📊 How Daily Performance is Calculated',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Each day, you rate your habits from 1 to 5.\n'
              'Here’s how it works:\n\n'
              '- Bad habits: lower ratings are better. The more intensely "bad" a habit is, the more it hurts your score if you rate it high.\n'
              '- Good habits: higher ratings are better. More intense habits help your score more when rated high.\n\n'
              'Your final score is a number from 0 to 10. The score reflects how well you balanced good and bad habits for the day.',
            ),
            const SizedBox(height: 24),
            const Text(
              '💾 Local-Only Storage',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'All your data is stored securely on your device. Nothing is sent to the internet or any server. You own your data fully.',
            ),
            const SizedBox(height: 24),
            const Text(
              '🕒 You Can Fill Reports Later',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'You don’t need to fill out your report exactly at the set hour. The app will automatically create empty reports after your chosen time each day. You can complete them later when you’re ready.',
            ),
          ],
        ),
      ),
    );
  }
}
