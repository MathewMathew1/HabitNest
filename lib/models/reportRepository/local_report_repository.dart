import 'dart:convert';
import 'package:flutter/foundation.dart'; // Add this for ChangeNotifier
import 'package:habitata_app/models/habit.dart';
import 'package:habitata_app/models/report.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'report_repository.dart';

class LocalReportRepository extends ChangeNotifier implements ReportRepository {
  static const _key = 'daily_reports';

  final List<DailyReport> _reports = [];
  bool _initialized = false;

  static const _lastGeneratedKey = 'last_generated_at';
  DateTime? _lastGeneratedAt;

  Future<void> generateMissingReports({
    required List<UserHabit> goodHabits,
    required List<UserHabit> badHabits,
    int cutoffHour = 22,
  }) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final fromDate = _lastGeneratedAt ?? today;

    if (goodHabits.isEmpty && badHabits.isEmpty) return;

    final List<DailyReport> newReports = [];

    for (
      var date = fromDate;
      !date.isAfter(today);
      date = date.add(const Duration(days: 1))
    ) {
      final alreadyExists = _reports.any(
        (r) =>
            r.date.year == date.year &&
            r.date.month == date.month &&
            r.date.day == date.day,
      );


      if (date == today && (now.hour < cutoffHour && _lastGeneratedAt != null)) {
        continue;
      }

      if (!alreadyExists) {
        newReports.add(
          DailyReport(date: date, goodHabits: goodHabits, badHabits: badHabits),
        );
      }
    }

    if (newReports.isEmpty) return;

    _reports.addAll(newReports);
    _reports.sort((a, b) => b.date.compareTo(a.date));
    _lastGeneratedAt = today.add(const Duration(days: 1));

    await _persist();
    notifyListeners();
  }

  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return;

    final lastGenRaw = prefs.getString(_lastGeneratedKey);
    if (lastGenRaw != null) {
      _lastGeneratedAt = DateTime.tryParse(lastGenRaw);
    }

    final data =
        (jsonDecode(raw) as List).map((e) => DailyReport.fromJson(e)).toList();

    _reports
      ..clear()
      ..addAll(data..sort((a, b) => b.date.compareTo(a.date)));

    notifyListeners();
  }

  List<DailyReport> get reports => List.unmodifiable(_reports);

  @override
  Future<List<DailyReport>> fetchReports() async {
    if (!_initialized) await init();
    return reports;
  }

  @override
  Future<void> removeReport(String reportId) async {
    _reports.removeWhere((r) => r.id == reportId);
    await _persist();
    notifyListeners();
  }

  @override
  Future<void> saveReports(List<DailyReport> newReports) async {
    _reports
      ..clear()
      ..addAll(newReports);
    await _persist();
    notifyListeners();
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _key,
      jsonEncode(_reports.map((e) => e.toJson()).toList()),
    );
    if (_lastGeneratedAt != null) {
      await prefs.setString(
        _lastGeneratedKey,
        _lastGeneratedAt!.toIso8601String(),
      );
    }
  }
}
