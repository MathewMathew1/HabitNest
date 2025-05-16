import 'package:flutter/material.dart';
import 'package:habitata_app/models/preferences/user_preferences.dart';
import 'package:habitata_app/models/reportRepository/local_report_repository.dart';
import 'package:habitata_app/models/userHabitRepository/localJsonHabitRepository.dart';
import 'package:habitata_app/models/userHabitRepository/userHabitRepository.dart';
import 'package:habitata_app/screens/delete_data_screen.dart';
import 'package:habitata_app/screens/help_screen.dart';
import 'package:habitata_app/screens/preference_screen.dart';
import 'package:habitata_app/screens/reports.dart';
import 'package:provider/provider.dart';
import '../helpers/report_generation_worker.dart';
import 'daily_routine_screen.dart';
import 'report_graph_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _openReports = 0;
  ReportGenerationWorker? _worker;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadOpenCount();

      final habitsRepo = Provider.of<LocalHabitsRepository>(
        context,
        listen: false,
      );
      final reportRepo = Provider.of<LocalReportRepository>(
        context,
        listen: false,
      );
      final userPreferences = Provider.of<UserPreferences>(
        context,
        listen: false,
      );
      _worker = ReportGenerationWorker(
        habitsRepo: habitsRepo,
        reportRepo: reportRepo,
        userPreferences: userPreferences,
      )..start();
    });
  }

  @override
  void dispose() {
    _worker?.stop();
    super.dispose();
  }

  Future<void> _loadOpenCount() async {
    final repo = Provider.of<LocalReportRepository>(context, listen: false);
    final list = await repo.fetchReports();

    if (mounted) setState(() => _openReports = list.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: IntrinsicWidth(
          stepWidth: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(200, 48),
                ),
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DailyRoutineScreen(),
                    ),
                  );
                  setState(() {});
                },
                child: const Text('Habits Routine'),
              ),
              const SizedBox(height: 20),
              Stack(
                alignment: Alignment.topRight,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(200, 48),
                    ),
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ReportsScreen(),
                        ),
                      );
                      _loadOpenCount();
                    },
                    child: const Text('Reports'),
                  ),
                  if (_openReports > 0)
                    Positioned(
                      right: 4,
                      top: 4,
                      child: CircleAvatar(
                        radius: 10,
                        backgroundColor: Colors.red,
                        child: Text(
                          '$_openReports',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(200, 48),
                ),
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ReportGraphScreen(),
                    ),
                  );
                },
                child: const Text('Performance'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(200, 48),
                ),
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PreferencesScreen(),
                    ),
                  );
                },
                child: const Text('Settings'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(200, 48),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HelperScreen(),
                    ),
                  );
                },
                child: const Text('How This App Works'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(200, 48),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DeleteDataScreen(),
                    ),
                  );
                },
                child: const Text('Data'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
