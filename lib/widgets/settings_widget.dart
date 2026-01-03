import 'package:flutter/material.dart';

// ignore: must_be_immutable
class SettingsWidget extends StatefulWidget {
  final String title;
  final String subtitle;
  Icon? icons;
  Widget? trailing;
  VoidCallback? onPressed;
  SettingsWidget({
    super.key,
    required this.title,
    required this.subtitle,
    this.icons,
    this.trailing,
    this.onPressed
  });

  @override
  State<SettingsWidget> createState() => _SettingsWidgetState();
}

class _SettingsWidgetState extends State<SettingsWidget> {
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: widget.onPressed,
      child: Container(
        padding: EdgeInsets.all(5),
        margin: EdgeInsets.symmetric(vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: 30, child: widget.icons ?? SizedBox.shrink()),
            SizedBox(width: 10,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
                Text(
                  widget.subtitle,
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
            Spacer(),
            widget.trailing ?? SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
