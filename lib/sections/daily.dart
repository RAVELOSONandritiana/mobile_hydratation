import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class StatisticsChart extends StatefulWidget {
  const StatisticsChart({super.key});

  @override
  State<StatisticsChart> createState() => _StatisticsChartState();
}

class _StatisticsChartState extends State<StatisticsChart> {
  int? touchedIndex;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        height: 200,
        child: LineChart(
          curve: Curves.bounceIn,
          LineChartData(
            gridData: FlGridData(show: true, drawVerticalLine: false),
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    const style = TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    );
                    switch (value.toInt()) {
                      case 0:
                        return Text('Mon', style: style);
                      case 1:
                        return Text('Tue', style: style);
                      case 2:
                        return Text('Wed', style: style);
                      case 3:
                        return Text('Thu', style: style);
                      case 4:
                        return Text('Fri', style: style);
                      case 5:
                        return Text('Sat', style: style);
                      case 6:
                        return Text('Sun', style: style);
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
            ),
            borderData: FlBorderData(show: true),
            minX: 0,
            maxX: 6,
            minY: 0,
            maxY: 4000,
            lineBarsData: [
              // Courbe 1
              LineChartBarData(
                spots: const [
                  FlSpot(0, 2500),
                  FlSpot(1, 1500),
                  FlSpot(2, 790),
                  FlSpot(3, 3000),
                  FlSpot(4, 598),
                  FlSpot(5, 2560),
                  FlSpot(6, 800),
                ],
                isCurved: true,
                color: Colors.blue,
                barWidth: 3,
                dotData: FlDotData(show: true),
              ),
              // Courbe 2
              LineChartBarData(
                spots: const [
                  FlSpot(0, 2000),
                  FlSpot(1, 1500),
                  FlSpot(2, 2000),
                  FlSpot(3, 1500),
                  FlSpot(4, 450),
                  FlSpot(5, 780),
                  FlSpot(6, 200),
                ],
                isCurved: true,
                color: Colors.redAccent,
                barWidth: 3,
                dotData: FlDotData(show: true),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
