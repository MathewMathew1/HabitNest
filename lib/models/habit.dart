import 'package:habitata_app/models/userHabitRepository/userHabitRepository.dart';

class Habit {
  final String name;
  final String emoji;
  final bool isPositiveHabit;

  Habit({
    required this.name,
    required this.emoji,
    required this.isPositiveHabit,
  });

  factory Habit.fromJson(Map<String, dynamic> json) {
    return Habit(
      name: json['name'],
      emoji: json['emoji'],
      isPositiveHabit: json['isPositiveHabit'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'emoji': emoji, 'isPositiveHabit': isPositiveHabit};
  }
}

enum HabitIntensity {
  low,
  medium,
  high;

  static HabitIntensity fromString(String value) {
    return HabitIntensity.values.firstWhere(
      (e) => e.toString().split('.').last == value,
    );
  }

  int toNumeric() {
    switch (this) {
      case HabitIntensity.low:
        return 1;
      case HabitIntensity.medium:
        return 2;
      case HabitIntensity.high:
        return 3;
    }
  }

  String toShortString() => toString().split('.').last;
}

enum CravingLevel { low, moderate, intense }

enum ProblemLevel { minor, significant, severe }

class UserHabit {
  final Habit habit;
  HabitIntensity intensity;

  UserHabit({required this.habit, required this.intensity});

  factory UserHabit.fromJson(Map<String, dynamic> json) {
    return UserHabit(
      habit: Habit.fromJson(json['habit']),
      intensity: HabitIntensity.fromString(json['intensity']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'habit': habit.toJson(), 'intensity': intensity.toShortString()};
  }
}

class UserHabits {
  List<UserHabit> goodHabits = [];
  List<UserHabit> badHabits = [];
  final UserHabitsRepository dataHandler;

  UserHabits({required this.dataHandler});

  Future<void> fetchData() async {
    final data = await dataHandler.fetchHabits();
    goodHabits = data.goodHabits;
    badHabits = data.badHabits;
  }

  void addHabit(Habit habit) {
    final UserHabit userHabit = UserHabit(
      habit: habit,
      intensity: HabitIntensity.medium,
    );
    if (habit.isPositiveHabit) {
      if (goodHabits.any((h) => h.habit.name == habit.name)) return;
      goodHabits.add(userHabit);
      return;
    }

    if (badHabits.any((h) => h.habit.name == habit.name)) return;
    badHabits.add(userHabit);
  }

  Future<void> saveData() async {
    await dataHandler.saveHabits(
      HabitsStored(goodHabits: goodHabits, badHabits: badHabits),
    );
  }

  void removeHabitByName(String name, bool isBadHabit) {
    if (isBadHabit) {
      final index = badHabits.indexWhere((h) => h.habit.name == name);
      if (index != -1) badHabits.removeAt(index);
      return;
    }
    final index = goodHabits.indexWhere((h) => h.habit.name == name);
    if (index != -1) goodHabits.removeAt(index);
  }

  void changeIntensity(HabitIntensity intensity, String name, bool isBadHabit) {
    if (isBadHabit) {
      final index = badHabits.indexWhere((h) => h.habit.name == name);
      if (index != -1) badHabits[index].intensity = intensity;
      return;
    }
    final index = goodHabits.indexWhere((h) => h.habit.name == name);
    if (index != -1) goodHabits[index].intensity = intensity;
  }
}

