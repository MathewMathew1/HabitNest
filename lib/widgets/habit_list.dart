import 'package:flutter/material.dart';
import 'package:habitata_app/models/filter_type.dart';
import '../models/habit.dart';

class HabitList extends StatefulWidget {
  final List<Habit> habits;
  final String searchQuery;
  final HabitFilterType filterType;
  final List<UserHabit> badHabits;
  final List<UserHabit> goodHabits;
  final void Function(Habit habit) onHabitTap;



  const HabitList({
    super.key,
    required this.habits,
    this.searchQuery = '',
    required this.badHabits,
    required this.goodHabits,
    this.filterType = HabitFilterType.all,
     required this.onHabitTap,
  });

  @override
  State<HabitList> createState() => _HabitListState();
}

class _HabitListState extends State<HabitList> {
  late List<Habit> sortedHabits;
  List<Habit> visibleHabits = [];

  @override
  void didUpdateWidget(covariant HabitList oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.searchQuery != widget.searchQuery ||
        oldWidget.filterType != widget.filterType) {
      _applyFilters();
    }
  }

  @override
  void initState() {
    sortedHabits = [...widget.habits]
      ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    _applyFilters();
  }

  void _applyFilters() {

    setState(() {
      visibleHabits =
          sortedHabits.where((habit) {
            final matchesSearch = habit.name.toLowerCase().contains(
              widget.searchQuery.toLowerCase(),
            );

            if(!matchesSearch) return false;

            final matchesFilter =
                widget.filterType == HabitFilterType.all ||
                (widget.filterType == HabitFilterType.good &&
                    habit.isPositiveHabit) ||
                (widget.filterType == HabitFilterType.bad &&
                    !habit.isPositiveHabit);
                    
            if(!matchesFilter) return false;

            final isAlreadyOnList = widget.badHabits.any((h)=>h.habit.name == habit.name) ||  widget.goodHabits.any((h)=>h.habit.name == habit.name);

            if(isAlreadyOnList) return false;

            return true;
          }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: ListView.builder(
        itemCount: visibleHabits.length,
        itemBuilder: (context, index) {
          final habit = visibleHabits[index];
          return ListTile(
            leading: Text(habit.emoji, style: const TextStyle(fontSize: 24)),
            title: Text(habit.name),
            trailing: Icon(
              habit.isPositiveHabit ? Icons.thumb_up : Icons.thumb_down,
              color: habit.isPositiveHabit ? Colors.green : Colors.red,
            ),
            onTap: () => widget.onHabitTap(habit)
          );
        },
      ),
    );
  }
}
