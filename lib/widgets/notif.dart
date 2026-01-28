import 'package:faker/faker.dart';
import 'package:flutter/material.dart';

class Notif extends StatefulWidget {
  final bool? showCloseButton;
  final bool success;
  final String? message;
  final String? date;

  const Notif({
    Key? key,
    this.showCloseButton,
    required this.success,
    this.message,
    this.date,
  }) : super(key: key);

  @override
  _NotifState createState() => _NotifState();
}

class _NotifState extends State<Notif> {
  bool _visible = true;
  bool dis = false;

  @override
  Widget build(BuildContext context) {
    if (dis) {
      return SizedBox.shrink();
    }
    return AnimatedScale(
      scale: _visible ? 1 : 0,
      duration: Duration(milliseconds: 400),
      onEnd: () {
        setState(() {
          dis = true;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        margin: EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              widget.success ? Icons.water_drop_rounded : Icons.no_drinks,
              color: widget.success ? Colors.blue : Colors.white,
              size: 32,
            ),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.message ?? (widget.success
                      ? "Objective achieved"
                      : "Objective not achieved"),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  widget.date ?? Faker().date.dateTime().toIso8601String(),
                  style: const TextStyle(color: Colors.grey, fontSize: 10),
                ),
              ],
            ),
            const Spacer(),
            if (widget.showCloseButton == true)
              GestureDetector(
                onTap: () {
                  setState(() {
                    _visible = false;
                  });
                },
                child: const Icon(Icons.close_rounded, color: Colors.redAccent),
              ),
          ],
        ),
      ),
    );
  }
}
