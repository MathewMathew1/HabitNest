import 'package:flutter/material.dart';
import '../helpers/intensity_of_habit.dart';
import '../models/report.dart';

class ReportFilledDetailScreen extends StatelessWidget {
  final DailyReportFilled report;

  const ReportFilledDetailScreen({super.key, required this.report});

 

  Widget _buildRatedHabitRow(UserRatingWithHabit rated) {
    return ListTile(
      leading: Text(rated.userHabit.habit.emoji, style: const TextStyle(fontSize: 24)),
      title: Text(rated.userHabit.habit.name),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: List.generate(5, (i) {
              return Icon(
                i < rated.rating ? Icons.star : Icons.star_border,
                color: i < rated.rating ? Colors.orange : Colors.grey,
                size: 20,
              );
            }),
          ),
          Text(
            rated.userHabit.habit.isPositiveHabit
                ? IntensityOfHabit.cravingLevelText(rated.userHabit.intensity)
                : IntensityOfHabit.problemLevelText(rated.userHabit.intensity),
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dateStr =
        '${report.date.year}-${report.date.month.toString().padLeft(2, '0')}-${report.date.day.toString().padLeft(2, '0')}';
 
    return Scaffold(
      appBar: AppBar(title: Text('Filled Report: $dateStr')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  const Text('Performance Score', style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 4),
                  Text(
                    '${report.ratingOfReport}/10',
                    style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  LinearProgressIndicator(
                    value: (report.ratingOfReport.clamp(1, 10) - 1) / 9,
                    color: Color.lerp(
                      Colors.red,
                      Colors.green,
                      (report.ratingOfReport.clamp(1, 10) - 1) / 9,
                    ),
                    backgroundColor: Colors.grey[300],
                    minHeight: 8,
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
            if (report.goodHabitsRated.isNotEmpty) ...[
              const Text(
                'Good Habits',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...report.goodHabitsRated.map(_buildRatedHabitRow),
              const Divider(height: 32),
            ],
            if (report.badHabitsRated.isNotEmpty) ...[
              const Text(
                'Bad Habits',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...report.badHabitsRated.map(_buildRatedHabitRow),
            ],
          ],
        ),
      ),
    );
  }
}
