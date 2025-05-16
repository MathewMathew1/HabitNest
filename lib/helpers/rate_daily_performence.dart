import 'package:habitata_app/models/report.dart';

class DailyPerformance {
  static int calculateDailyPerformanceScore(
    List<UserRatingWithHabit> badHabitsRated,
    List<UserRatingWithHabit> goodHabitsRated,
  ) {
    double badScore = 0;
    int maxBadScore = 0;

    for (final item in badHabitsRated) {
      final severity = item.userHabit.intensity;
      final rating = item.rating;
      badScore += (rating - 1) * severity.toNumeric();
      maxBadScore += (5-1) * severity.toNumeric();
    }

    double maxGoodScore = 0;

    double goodScore = 0;

    for (final item in goodHabitsRated) {
      final severity = item.userHabit.intensity;
      final rating = item.rating;
      goodScore += rating * severity.toNumeric();
      maxGoodScore += 5 * severity.toNumeric();
    }

    double maximumScore = maxGoodScore + maxBadScore;
    double score = badScore + maxGoodScore - goodScore;
    double percentageOfScore = score/maximumScore;

    int removedPoints = (10 * percentageOfScore).round();

    int points = 10 - removedPoints;

    return points;
  }
}
