import 'package:flutter/material.dart';
import 'package:hydratation/providers/name_provider.dart';
import 'package:provider/provider.dart';

class AvatarWidget extends StatefulWidget {
  final String path;
  const AvatarWidget({super.key, required this.path});

  @override
  State<AvatarWidget> createState() => _AvatarWidgetState();
}

class _AvatarWidgetState extends State<AvatarWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white10,
      ),
      child: Column(
        spacing: 10,
        children: [
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              image: DecorationImage(
                image: AssetImage('assets/images/${widget.path}'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Consumer<NameProvider>(
            builder: (context, prov, child) {
              return Column(
                children: [
                  Text(
                    prov.name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    prov.email,
                    style: TextStyle(
                      color: Colors.orange,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    prov.accountState,
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
