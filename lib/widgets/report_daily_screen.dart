import 'package:flutter/material.dart';
import '../helpers/intensity_of_habit.dart';
import '../models/habit.dart';
import '../models/report.dart';

class ReportDetailScreen extends StatefulWidget {
  final DailyReport report;
  final Future<void> Function(
    DailyReport report,
    Map<String, UserRatingWithHabit> ratings,
  )
  onSave;
  final Future<void> Function(String id) onRemove;

  const ReportDetailScreen({
    super.key,
    required this.report,
    required this.onSave,
    required this.onRemove,
  });

  @override
  State<ReportDetailScreen> createState() => _ReportDetailScreenState();
}

class _ReportDetailScreenState extends State<ReportDetailScreen> {
  final Map<String, UserRatingWithHabit> _ratings = {};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print(context);
  }

  void _setRating(UserHabit habit, int rating) {
    setState(() {
      _ratings[habit.habit.name] = UserRatingWithHabit(
        rating: rating,
        userHabit: habit,
      );
    });
  }

  Widget _buildHabitRow(UserHabit habit) {
    final rating = _ratings[habit.habit.name]?.rating ?? 0;

    return ListTile(
      leading: Text(habit.habit.emoji, style: const TextStyle(fontSize: 24)),
      title: Text(habit.habit.name),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: List.generate(5, (i) {
              return IconButton(
                icon: Icon(
                  i < rating ? Icons.star : Icons.star_border,
                  color: i < rating ? Colors.orange : Colors.grey,
                  size: 20,
                ),
                onPressed: () => _setRating(habit, i + 1),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              );
            }),
          ),
          Text(
            habit.habit.isPositiveHabit
                ? IntensityOfHabit.cravingLevelText(habit.intensity)
                : IntensityOfHabit.problemLevelText(habit.intensity),
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dateStr =
        '${widget.report.date.year}-${widget.report.date.month.toString().padLeft(2, '0')}-${widget.report.date.day.toString().padLeft(2, '0')}';

    void fillReport() async {
      final amountOfHabits =
          widget.report.badHabits.length + widget.report.goodHabits.length;
      if (amountOfHabits > _ratings.length) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please rate all habits before saving.'),
            duration: Duration(seconds: 2),
          ),
        );
        return;
      }
      await widget.onSave(widget.report, _ratings);
      await widget.onRemove(widget.report.id);
      if (mounted) Navigator.pop(context, true);
    }

    return Scaffold(
      appBar: AppBar(title: Text('Daily Report: $dateStr')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.report.goodHabits.isNotEmpty) ...[
              const Text(
                'Good Habits',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...widget.report.goodHabits.map(_buildHabitRow),
              const Divider(height: 32),
            ],
            if (widget.report.badHabits.isNotEmpty) ...[
              const Text(
                'Bad Habits',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...widget.report.badHabits.map(_buildHabitRow),
            ],
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: () async {
            fillReport();
          },
          child: const Text('Save Report'),
        ),
      ),
    );
  }
}
