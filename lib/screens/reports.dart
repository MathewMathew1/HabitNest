import 'package:flutter/material.dart';
import 'package:habitata_app/models/reportRepository/local_report_repository.dart';
import 'package:habitata_app/models/reportsFilledRepository/local_report_filled_repository.dart';
import 'package:habitata_app/models/userHabitRepository/localJsonHabitRepository.dart';
import 'package:habitata_app/models/userHabitRepository/userHabitRepository.dart';
import 'package:habitata_app/widgets/open_title.dart';
import 'package:habitata_app/widgets/report_filled_habit.dart';
import 'package:provider/provider.dart';
import '../models/report.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {

  late UserHabitsRepository dataHandler;

  @override
  void initState() {
    super.initState();

    dataHandler = Provider.of<LocalHabitsRepository>(context, listen: false);
  }


  Widget _buildFilledTile(DailyReportFilled r) {
    final dateStr =
        '${r.date.year}-${r.date.month.toString().padLeft(2, '0')}-${r.date.day.toString().padLeft(2, '0')}';
    final score = r.ratingOfReport.clamp(1, 10);
    return ListTile(
      title: Text(dateStr),
      subtitle: LinearProgressIndicator(
        value: (score) / 10,
        color: Color.lerp(Colors.red, Colors.green, (score) / 10),
        backgroundColor: Colors.grey[300],
        minHeight: 6,
      ),
      trailing: Text('$score/10'),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ReportFilledDetailScreen(report: r),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final openReports = context.watch<LocalReportRepository>().reports;
    final filledReports = context.watch<LocalReportFilledRepository>().reports;

    return Scaffold(
      appBar: AppBar(title: const Text('Daily Reports')),
      body: ListView(
        children: [
          if (openReports.isNotEmpty) ...[
            const Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                'Reports to fill',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            ...openReports.map((r) => OpenReportTile(report: r)),
            const Divider(),
          ],
          if (filledReports.isNotEmpty) ...[
            const Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                'Filled reports',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            ...filledReports.map(_buildFilledTile),
          ],
        ],
      ),
    );
  }
}
