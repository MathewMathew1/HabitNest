import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../habit.dart'; // assuming Habit model is defined there

class CustomHabitsRepository {
  static const String _storageKey = 'custom_habits';

  Future<List<Habit>> loadCustomHabits() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_storageKey);
    if (jsonString == null) return [];

    final List<dynamic> data = jsonDecode(jsonString);
    return data.map((item) => Habit(
      name: item['name'],
      emoji: item['emoji'],
      isPositiveHabit: item['isPositiveHabit'],
    )).toList();
  }

  Future<void> saveCustomHabits(List<Habit> habits) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = habits.map((habit) => {
      'name': habit.name,
      'emoji': habit.emoji,
      'isPositiveHabit': habit.isPositiveHabit,
    }).toList();
    await prefs.setString(_storageKey, jsonEncode(jsonList));
  }

  Future<void> addCustomHabit(Habit habit) async {
    final habits = await loadCustomHabits();
    habits.add(habit);
    await saveCustomHabits(habits);
  }

  Future<bool> nameExists(String name) async {
    final habits = await loadCustomHabits();
    return habits.any((h) => h.name.toLowerCase() == name.toLowerCase());
  }
}
