import 'package:habitata_app/models/habit.dart';

class IntensityOfHabit {
  static String cravingLevelText(HabitIntensity intensity) {
    switch (intensity) {
      case HabitIntensity.low:
        return 'Craving: Low';
      case HabitIntensity.medium:
        return 'Craving: Moderate';
      case HabitIntensity.high:
        return 'Craving: Intense';
    }
  }

  static String problemLevelText(HabitIntensity intensity) {
    switch (intensity) {
      case HabitIntensity.low:
        return 'Problem: Minor';
      case HabitIntensity.medium:
        return 'Problem: Significant';
      case HabitIntensity.high:
        return 'Problem: Severe';
    }
  }
}
