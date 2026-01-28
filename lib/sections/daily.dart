import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hydratation/providers/indicator_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class StatisticsChart extends StatefulWidget {
  const StatisticsChart({super.key});

  @override
  State<StatisticsChart> createState() => _StatisticsChartState();
}

class _StatisticsChartState extends State<StatisticsChart> {
  int? touchedIndex;

  @override
  Widget build(BuildContext context) {
    return Consumer<IndicatorProvider>(
      builder: (context, indicator, _) {
        List<FlSpot> spots = [];
        
        // Take the last 7 items
        final recentHistory = indicator.history.length > 7 
            ? indicator.history.sublist(0, 7) 
            : indicator.history;
            
        final displayScores = recentHistory.reversed.toList();

        for (int i = 0; i < displayScores.length; i++) {
          spots.add(FlSpot(i.toDouble(), (displayScores[i]['score'] as num).toDouble()));
        }

        if (spots.isEmpty) {
          return const SizedBox(
            height: 150,
            child: Center(
              child: Text("No data for this week", style: TextStyle(color: Colors.white24, fontSize: 12)),
            ),
          );
        }

        return Container(
          height: 180,
          padding: const EdgeInsets.only(right: 20, left: 10, top: 10, bottom: 10),
          child: LineChart(
            LineChartData(
              gridData: const FlGridData(show: false),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      int index = value.toInt();
                      if (index >= 0 && index < displayScores.length) {
                        try {
                          DateTime date = DateTime.parse(displayScores[index]['date']);
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              DateFormat('E').format(date)[0], // First letter of day
                              style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                          );
                        } catch (_) {
                          return const SizedBox.shrink();
                        }
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 35,
                    getTitlesWidget: (value, meta) => Text(
                      "${(value / 1000).toStringAsFixed(1)}k",
                      style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 8),
                    ),
                  ),
                ),
              ),
              borderData: FlBorderData(show: false),
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: true,
                  color: Colors.blue,
                  barWidth: 3,
                  isStrokeCapRound: true,
                  dotData: const FlDotData(show: false),
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      colors: [
                        Colors.blue.withOpacity(0.2),
                        Colors.blue.withOpacity(0.0),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ],
              lineTouchData: LineTouchData(
                touchTooltipData: LineTouchTooltipData(
                  getTooltipColor: (touchedSpot) => const Color(0xFF1E293B),
                  getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                    return touchedBarSpots.map((barSpot) {
                      return LineTooltipItem(
                        '${barSpot.y.toInt()} ml',
                        const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      );
                    }).toList();
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
