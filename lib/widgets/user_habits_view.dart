import 'package:flutter/material.dart';
import 'package:habitata_app/helpers/intensity_of_habit.dart';
import 'package:habitata_app/models/habit.dart';

class UserHabitsView extends StatelessWidget {
  final UserHabits userHabits;
  final void Function(String name, bool isBad) onRemove;
  final void Function(String name, bool isBad, HabitIntensity intensity)
  onChangeIntensity;

  const UserHabitsView({
    super.key,
    required this.userHabits,
    required this.onRemove,
    required this.onChangeIntensity,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (userHabits.goodHabits.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: Text(
                  'Good Habits',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),

              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 300),
                child: ListView(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  children:
                      userHabits.goodHabits
                          .map((h) => _buildHabitTile(h, false))
                          .toList(),
                ),
              ),
            ],
          ),
        if (userHabits.badHabits.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: Text(
                  'Bad Habits',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 300),
                child: ListView(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  children:
                      userHabits.badHabits
                          .map((h) => _buildHabitTile(h, true))
                          .toList(),
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildHabitTile(UserHabit h, bool isBadHabit) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        leading: Text(h.habit.emoji, style: const TextStyle(fontSize: 24)),
        title: Text(h.habit.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isBadHabit
                  ? IntensityOfHabit.problemLevelText(h.intensity)
                  : IntensityOfHabit.cravingLevelText(h.intensity),
            ),
            Slider(
              value: h.intensity.index.toDouble(),
              min: 0,
              max: 2,
              divisions: 2,
              onChanged: (value) {
                onChangeIntensity(
                  h.habit.name,
                  isBadHabit,
                  HabitIntensity.values[value.toInt()],
                );
              },
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => onRemove(h.habit.name, isBadHabit),
        ),
      ),
    );
  }

}
