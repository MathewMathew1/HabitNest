import 'package:flutter/material.dart';
import 'package:habitata_app/models/preferences/user_preferences.dart';
import 'package:habitata_app/models/reportRepository/local_report_repository.dart';
import 'package:habitata_app/models/reportsFilledRepository/local_report_filled_repository.dart';
import 'package:habitata_app/models/userHabitRepository/localJsonHabitRepository.dart';
import 'package:habitata_app/widgets/restart_widget.dart';
import 'package:provider/provider.dart';
import 'screens/main_screen.dart';


void main() async {
  final reportRepo = LocalReportRepository();
  final userHabitsRepo = LocalHabitsRepository();
  final reportFilledRepo = LocalReportFilledRepository();
  final userPrefs = UserPreferences();

  await Future.wait([reportFilledRepo.init(), reportRepo.init(), userHabitsRepo.init(), userPrefs.init(),]);

runApp(
    RestartWidget(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider<LocalReportRepository>.value(value: reportRepo),
          ChangeNotifierProvider<LocalReportFilledRepository>.value(value: reportFilledRepo),
          Provider<LocalHabitsRepository>.value(value: userHabitsRepo),
          ChangeNotifierProvider<UserPreferences>.value(value: userPrefs),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Habit Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}
