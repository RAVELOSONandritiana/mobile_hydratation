import 'package:flutter/material.dart';

class SwitchCustom extends StatefulWidget {
  const SwitchCustom({super.key});

  @override
  State<SwitchCustom> createState() => _SwitchCustomState();
}

class _SwitchCustomState extends State<SwitchCustom> {
  bool isActive = false;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 25,
      child: FittedBox(
        child: Switch(
          value: isActive,
          onChanged: (value) {
            setState(() {
              isActive = value;
            });
          },
          activeThumbColor: Colors.blue,
          thumbColor: WidgetStatePropertyAll(Colors.blue),
        ),
      ),
    );
  }
}
