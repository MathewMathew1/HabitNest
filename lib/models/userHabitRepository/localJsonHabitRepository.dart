import 'dart:convert';
import 'package:habitata_app/models/userHabitRepository/userHabitRepository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalHabitsRepository implements UserHabitsRepository {
  static const String _storageKey = 'user_habits';

  late HabitsStored _habits;
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_storageKey);

    _habits = jsonString == null
        ? HabitsStored(goodHabits: [], badHabits: [])
        : HabitsStored.fromJson(jsonDecode(jsonString));
  }

  HabitsStored get habits => _habits;

  @override
  Future<HabitsStored> fetchHabits() async {
    if (!_initialized) await init();
    return _habits;
  }

  @override
  Future<void> saveHabits(HabitsStored habits) async {
    _habits = habits;
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(habits.toJson());
    await prefs.setString(_storageKey, jsonString);
  }
}

