import 'package:flutter/material.dart';
import 'package:habitata_app/widgets/report_daily_screen.dart';
import 'package:provider/provider.dart';

import '../models/report.dart';
import '../models/reportRepository/local_report_repository.dart';
import '../models/reportsFilledRepository/local_report_filled_repository.dart';

class OpenReportTile extends StatelessWidget {
  final DailyReport report;

  const OpenReportTile({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    final dateStr =
        '${report.date.year}-${report.date.month.toString().padLeft(2, '0')}-${report.date.day.toString().padLeft(2, '0')}';

    return ListTile(
      title: Text(dateStr),
      trailing: const Icon(Icons.pending_actions, color: Colors.red),
      onTap: () {
        final filledRepo = Provider.of<LocalReportFilledRepository>(context, listen: false);
        final openRepo = Provider.of<LocalReportRepository>(context, listen: false);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ReportDetailScreen(
              report: report,
              onSave: filledRepo.saveReport,
              onRemove: openRepo.removeReport,
            ),
          ),
        );
      },
    );
  }
}
