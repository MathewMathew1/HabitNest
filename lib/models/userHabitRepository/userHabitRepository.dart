import 'package:habitata_app/models/habit.dart';


class HabitsStored {
  List<UserHabit> goodHabits;
  List<UserHabit> badHabits;

  HabitsStored({
    required this.goodHabits,
    required this.badHabits,
  });

  factory HabitsStored.fromJson(Map<String, dynamic> json) {
    return HabitsStored(
      goodHabits: (json['goodHabits'] as List)
          .map((item) => UserHabit.fromJson(item))
          .toList(),
      badHabits: (json['badHabits'] as List)
          .map((item) => UserHabit.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'goodHabits': goodHabits.map((h) => h.toJson()).toList(),
      'badHabits': badHabits.map((h) => h.toJson()).toList(),
    };
  }
}


abstract class UserHabitsRepository {
  Future<HabitsStored> fetchHabits();
  Future<void> saveHabits(HabitsStored habits);
}

