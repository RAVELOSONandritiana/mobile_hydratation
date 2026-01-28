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
    return InkWell(
      onTap: widget.onPressed,
      splashColor: Colors.blue.withOpacity(0.1),
      highlightColor: Colors.blue.withOpacity(0.05),
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        child: Row(
          children: [
            Container(
              height: 44,
              width: 44,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.blue.withOpacity(0.15),
                    Colors.blue.withOpacity(0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.blue.withOpacity(0.1)),
              ),
              child: Center(
                child: widget.icons ?? const Icon(Icons.settings, color: Colors.blue, size: 22),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (widget.subtitle.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        widget.subtitle,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.35),
                          fontSize: 12,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            widget.trailing ?? Icon(Icons.chevron_right_rounded, color: Colors.white.withOpacity(0.2), size: 22),
          ],
        ),
      ),
    );
  }
}
