import 'package:habitata_app/models/report.dart';

abstract class ReportFilledRepository {
  Future<List<DailyReportFilled>> fetchReports();
  Future<void> saveReport(DailyReport reports, Map<String, UserRatingWithHabit> userMapWithRating);

}
