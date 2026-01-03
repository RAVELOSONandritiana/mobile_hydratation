import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hydratation/widgets/notif.dart';

class History extends StatefulWidget {
  History({Key? key}) : super(key: key);

  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "All History",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20,),
              ...List.generate(20, (index) {
                return Notif(
                  showCloseButton: true,
                  success: Random().nextBool(),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
