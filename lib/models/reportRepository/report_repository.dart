import 'package:habitata_app/models/report.dart';

abstract class ReportRepository {
  Future<List<DailyReport>> fetchReports();
  Future<void> removeReport(String reportId);
  Future<void> saveReports(List<DailyReport> reports);
}
