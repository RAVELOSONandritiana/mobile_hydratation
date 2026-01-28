import 'package:flutter/material.dart';
import 'package:hydratation/services/notification_service.dart';

class RemindersScreen extends StatefulWidget {
  const RemindersScreen({super.key});

  @override
  State<RemindersScreen> createState() => _RemindersScreenState();
}

class _RemindersScreenState extends State<RemindersScreen> {
  bool _isReminderEnabled = true;

  @override
  Widget build(BuildContext context) {
    final tips = [
      {
        "icon": Icons.lightbulb,
        "title": "Stay Consistent",
        "desc": "Drink water at the same time every day to build a habit."
      },
      {
        "icon": Icons.local_drink,
        "title": "Add Flavor",
        "desc": "Try adding lemon or cucumber to make water more refreshing."
      },
      {
        "icon": Icons.wb_sunny,
        "title": "Hot Weather",
        "desc": "Increase your intake on hot days or when exercising."
      },
      {
        "icon": Icons.bed,
        "title": "Before Bed",
        "desc": "A glass of water before sleep can help detoxify."
      }
    ];

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Hydration Tips",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              "Maintain your health with these simple tips",
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.separated(
                itemCount: tips.length,
                separatorBuilder: (context, index) => const SizedBox(height: 15),
                itemBuilder: (context, index) {
                  final tip = tips[index];
                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white10,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(tip['icon'] as IconData, color: Colors.blue, size: 30),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tip['title'] as String,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                tip['desc'] as String,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.blue.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.notifications_active, color: Colors.blue),
                  const SizedBox(width: 15),
                  const Expanded(
                    child: Text(
                      "Smart Reminders",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Switch(
                    value: _isReminderEnabled,
                    onChanged: (v) {
                      setState(() {
                        _isReminderEnabled = v;
                      });
                      if (v) {
                        NotificationService.scheduleHourlyReminder();
                      } else {
                        NotificationService.cancelAll();
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            v ? "Reminders enabled" : "Reminders disabled",
                            style: const TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Colors.blue,
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                    activeColor: Colors.blue,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
