import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences extends ChangeNotifier {
  static const _reportHourKey = 'report_generation_hour';
  int _reportGenerationHour = 22;

  int get reportGenerationHour => _reportGenerationHour;


  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _reportGenerationHour = prefs.getInt(_reportHourKey) ?? 22;
  }

  Future<void> setReportGenerationHour(int hour) async {
    _reportGenerationHour = hour;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_reportHourKey, hour);
    notifyListeners();
  }

  Map<String, dynamic> toJson() {
    return {
      'reportGenerationHour': _reportGenerationHour,
    };
  }

  @override
  String toString() => 'UserPreferences(${toJson()})';
}
