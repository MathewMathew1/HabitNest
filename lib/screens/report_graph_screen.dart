import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/reportsFilledRepository/local_report_filled_repository.dart';
import '../models/report.dart';

class ReportGraphScreen extends StatefulWidget {
  const ReportGraphScreen({super.key});

  @override
  State<ReportGraphScreen> createState() => _ReportGraphScreenState();
}

class _ReportGraphScreenState extends State<ReportGraphScreen> {
  List<DailyReportFilledWithDate> _data = [];

  @override
  void initState() {
    super.initState();
    final reports =
        Provider.of<LocalReportFilledRepository>(
          context,
          listen: false,
        ).reports;

    final sorted = List<DailyReportFilled>.from(reports)
      ..sort((a, b) => a.date.compareTo(b.date));

    _data = sorted.map((r) => DailyReportFilledWithDate.fromReport(r)).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (_data.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text('Performances')),
        body: const Center(child: Text("No data available")),
      );
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final desiredWidth = _data.length * 65.0;
    final chartWidth = desiredWidth < screenWidth ? screenWidth : desiredWidth;

    return Scaffold(
      appBar: AppBar(title: const Text('Daily Performance Graph')),
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: chartWidth,
            height: 300,

            child: Column(
              children: [
                Expanded(
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.start,
                      maxY: 10,
                      barTouchData: BarTouchData(enabled: true),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 30,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                value.toInt().toString(),
                                style: const TextStyle(fontSize: 12),
                              );
                            },
                          ),
                        ),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(
                            getTitlesWidget: (value, meta) => Container(),
                            showTitles: true,
                            reservedSize: 10,
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 1, // <-- Force titles on every bar
                            reservedSize: 40,
                            getTitlesWidget: (value, meta) {
                              final index = value.toInt();
                              if (index < 0 || index >= _data.length)
                                return const SizedBox.shrink();
                              final report = _data[index];
                              final date = report.date;

                              return SideTitleWidget(
                                axisSide: meta.axisSide,
                                space: 8,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      DateFormat('E').format(
                                        date,
                                      ), // Day of the week (e.g., Mon)
                                      style: const TextStyle(fontSize: 10),
                                    ),
                                    Text(
                                      report
                                          .formattedDate, // Already something like MM/dd
                                      style: const TextStyle(fontSize: 10),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      barGroups: List.generate(_data.length, (index) {
                        final report = _data[index];
                        final color = Color.lerp(
                          Colors.red,
                          Colors.green,
                          report.ratingOfReport / 10.0,
                        );
                        return BarChartGroupData(
                          x: index,
                          barRods: [
                            BarChartRodData(
                              toY: report.ratingOfReport.toDouble(),
                              color: color,
                              width: 55,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ],
                        );
                      }),
                      gridData: FlGridData(show: true),
                      borderData: FlBorderData(show: false),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
