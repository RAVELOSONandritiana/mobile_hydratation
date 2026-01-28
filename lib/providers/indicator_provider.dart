import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hydratation/utils/path.dart';

class IndicatorProvider extends ChangeNotifier {
  double max = 2500;
  double current = 0;
  List<dynamic> history = [];
  final dio = Dio();

  setMax(double value) {
    max = value;
    notifyListeners();
  }

  setCurrent(double value) {
    current = value;
    notifyListeners();
  }

  setHistory(List<dynamic> value) {
    history = value;
    notifyListeners();
  }

  double get averageIntake {
    if (history.isEmpty) return 0;
    double total = history.fold(0, (sum, item) => sum + (item['score'] as num).toDouble());
    return total / history.length;
  }

  Map<String, dynamic>? get bestDay {
    if (history.isEmpty) return null;
    return history.reduce((a, b) => (a['score'] as num).toDouble() > (b['score'] as num).toDouble() ? a : b);
  }

  List<double> get lastSevenDays {
    if (history.isEmpty) return List.filled(7, 0.0);
    final sorted = List.from(history)..sort((a, b) => (b['date'] as String).compareTo(a['date'] as String));
    return sorted.take(7).map((e) => (e['score'] as num).toDouble()).toList().reversed.toList();
  }

  Future<void> fetchData(int userId) async {
    if (userId == 0) return;
    try {
      // Fetch today's score
      final responseToday = await dio.get("${PathBackend().baseUrl}/users/$userId/today");
      if (responseToday.statusCode == 200) {
        current = (responseToday.data['total_today'] as num).toDouble();
      }

      // Fetch history
      final responseHistory = await dio.get("${PathBackend().baseUrl}/users/$userId/scores");
      if (responseHistory.statusCode == 200) {
        history = responseHistory.data;
      }

      notifyListeners();
    } catch (e) {
      debugPrint("Error fetching data: $e");
    }
  }
}