import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:habitata_app/models/preferences/user_preferences.dart';
import 'package:habitata_app/models/reportRepository/local_report_repository.dart';
import '../models/userHabitRepository/userHabitRepository.dart';

class ReportGenerationWorker {
  final UserHabitsRepository habitsRepo;
  final LocalReportRepository reportRepo;
  final UserPreferences userPreferences;
  final int cutoffHour;

  Timer? _timer;

  ReportGenerationWorker({
    required this.habitsRepo,
    required this.reportRepo,
    required this.userPreferences,
    this.cutoffHour = 22,
  });

  void start() {
    _checkAndGenerate();
    _timer?.cancel(); 
    _timer = Timer.periodic(const Duration(seconds: 10), (_) => _checkAndGenerate());
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
  }

  Future<void> _checkAndGenerate() async {
    try {
      final habits = await habitsRepo.fetchHabits();
      final goodHabits = habits.goodHabits;
      final badHabits = habits.badHabits;

      if (goodHabits.isEmpty && badHabits.isEmpty) return;

      await reportRepo.generateMissingReports(
        goodHabits: goodHabits,
        badHabits: badHabits,
        cutoffHour: userPreferences.reportGenerationHour,
      );
    } catch (e) {
      debugPrint('Error in ReportGenerationWorker: $e');
    }
  }
}
