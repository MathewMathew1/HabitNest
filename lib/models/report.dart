import 'package:habitata_app/models/habit.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class DailyReport {
  final String id;
  final DateTime date;

  List<UserHabit> goodHabits;
  List<UserHabit> badHabits;

  DailyReport({
    String? id,
    required this.date,
    required this.badHabits,
    required this.goodHabits,
  }) : id = id ?? const Uuid().v4();

  factory DailyReport.fromJson(Map<String, dynamic> j) => DailyReport(
    id: j['id'],
    date: DateTime.parse(j['date'] as String),
    goodHabits:
        (j['goodHabits'] as List)
            .map((item) => UserHabit.fromJson(item))
            .toList(),
    badHabits:
        (j['badHabits'] as List)
            .map((item) => UserHabit.fromJson(item))
            .toList(),
  );

  Map<String, dynamic> toJson() => {
    'goodHabits': goodHabits.map((h) => h.toJson()).toList(),
    'badHabits': badHabits.map((h) => h.toJson()).toList(),
    'id': id,
    'date': date.toIso8601String(),
  };
}

class DailyReportFilled {
  final DateTime date;
  final DateTime filledOn;
  final String id;

  List<UserRatingWithHabit> goodHabitsRated;
  List<UserRatingWithHabit> badHabitsRated;

  int ratingOfReport = 0;

  DailyReportFilled({
    required this.id,
    required this.date,
    required this.filledOn,
    required this.goodHabitsRated,
    required this.badHabitsRated,
    required this.ratingOfReport,
  });

  factory DailyReportFilled.fromJson(Map<String, dynamic> j) =>
      DailyReportFilled(
        id: j['id'],
        date: DateTime.parse(j['date'] as String),
        filledOn: DateTime.parse(j['filledOn'] as String),
        ratingOfReport: j['ratingOfReport'],
        goodHabitsRated:
            (j['goodHabitsRated'] as List)
                .map((item) => UserRatingWithHabit.fromJson(item))
                .toList(),
        badHabitsRated:
            (j['badHabitsRated'] as List)
                .map((item) => UserRatingWithHabit.fromJson(item))
                .toList(),
      )..ratingOfReport = j['ratingOfReport'] ?? 0;

  Map<String, dynamic> toJson() => {
    'date': date.toIso8601String(),
    'filledOn': filledOn.toIso8601String(),
    'goodHabitsRated': goodHabitsRated.map((e) => e.toJson()).toList(),
    'badHabitsRated': badHabitsRated.map((e) => e.toJson()).toList(),
    'ratingOfReport': ratingOfReport,
    'id': id
  };
}

class DailyReportFilledWithDate extends DailyReportFilled {
  final String formattedDate;

  DailyReportFilledWithDate({
    required super.id,
    required super.date,
    required super.filledOn,
    required super.goodHabitsRated,
    required super.badHabitsRated,
    required super.ratingOfReport,
  }) : formattedDate = DateFormat('yyyy-MM-dd').format(date);

  factory DailyReportFilledWithDate.fromReport(DailyReportFilled r) {
    return DailyReportFilledWithDate(
      id: r.id,
      date: r.date,
      filledOn: r.filledOn,
      goodHabitsRated: r.goodHabitsRated,
      badHabitsRated: r.badHabitsRated,
      ratingOfReport: r.ratingOfReport,
    );
  }
}


class UserRatingWithHabit {
  final int rating;
  final UserHabit userHabit;

  UserRatingWithHabit({required this.rating, required this.userHabit});

  factory UserRatingWithHabit.fromJson(Map<String, dynamic> j) =>
      UserRatingWithHabit(
        rating: j['rating'] as int,
        userHabit: UserHabit.fromJson(j['userHabit']),
      );

  Map<String, dynamic> toJson() => {
    'rating': rating,
    'userHabit': userHabit.toJson(),
    
  };
}
