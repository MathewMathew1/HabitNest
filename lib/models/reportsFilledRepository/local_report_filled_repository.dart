import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:habitata_app/helpers/rate_daily_performence.dart';
import 'package:habitata_app/models/report.dart';
import 'package:habitata_app/models/reportsFilledRepository/report_filled_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalReportFilledRepository extends ChangeNotifier implements ReportFilledRepository {
  static const _key = 'filled_reports';

  final List<DailyReportFilled> _reports = [];
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    try {
      _initialized = true;
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_key);

      if (raw == null) return;

      final data = (jsonDecode(raw) as List)
          .map((e) => DailyReportFilled.fromJson(e))
          .toList();

      _reports
        ..clear()
        ..addAll(data..sort((a, b) => b.date.compareTo(a.date)));

      notifyListeners();
    } catch (e) {
      print('Error initializing filled reports: $e');
    }
  }

  List<DailyReportFilled> get reports => List.unmodifiable(_reports);

  @override
  Future<List<DailyReportFilled>> fetchReports() async {
    if (!_initialized) await init();
    return reports;
  }

  @override
  Future<void> saveReport(
    DailyReport report,
    Map<String, UserRatingWithHabit> ratingMap,
  ) async {
    final good = ratingMap.values
        .where((e) => e.userHabit.habit.isPositiveHabit)
        .toList();

    final bad = ratingMap.values
        .where((e) => !e.userHabit.habit.isPositiveHabit)
        .toList();

    final filled = DailyReportFilled(
      id: report.id,
      date: report.date,
      filledOn: DateTime.now(),
      goodHabitsRated: good,
      badHabitsRated: bad,
      ratingOfReport: DailyPerformance.calculateDailyPerformanceScore(bad, good),
    );

    _reports.add(filled);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _key,
      jsonEncode(_reports.map((e) => e.toJson()).toList()),
    );

    notifyListeners(); 
  }
}
