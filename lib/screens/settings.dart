import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hydratation/screens/terms.dart';
import 'package:hydratation/screens/update_email.dart';
import 'package:hydratation/screens/update_name.dart';
import 'package:hydratation/screens/update_password.dart';
import 'package:hydratation/widgets/avatar.dart';
import 'package:hydratation/widgets/settings_widget.dart';
import 'package:hydratation/widgets/switch_custom.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              AvatarWidget(path: "avatar.jpg"),
              SizedBox(height: 30),
              SettingsWidget(
                title: 'Change Username',
                subtitle: 'update your lastname and firstname',
                icons: Icon(Icons.person, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UpdateName()),
                  );
                },
                trailing: Transform.scale(
                  scaleX: -1,
                  scaleY: 1,
                  child: Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.white,
                    size: 14,
                  ),
                ),
              ),
              SettingsWidget(
                title: 'Notitications',
                subtitle: 'Allow to send notification to you',
                trailing: SwitchCustom(),
                icons: Icon(Icons.notification_important, color: Colors.white),
              ),
              SettingsWidget(
                title: 'Change Password',
                subtitle: 'update your password',
                icons: Icon(Icons.password_outlined, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UpdatePassword()),
                  );
                },
                trailing: Transform.scale(
                  scaleX: -1,
                  scaleY: 1,
                  child: Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.white,
                    size: 14,
                  ),
                ),
              ),

              SettingsWidget(
                title: 'Change Email',
                subtitle: 'update your email',
                icons: Icon(Icons.email, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UpdateEmail()),
                  );
                },
                trailing: Transform.scale(
                  scaleX: -1,
                  scaleY: 1,
                  child: Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.white,
                    size: 14,
                  ),
                ),
              ),

              SettingsWidget(
                title: 'Terms & Policy',
                subtitle: '',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Terms()),
                  );
                },
                trailing: Transform.scale(
                  scaleX: -1,
                  scaleY: 1,
                  child: Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.white,
                    size: 14,
                  ),
                ),
              ),
              SizedBox(height: 10),
              OutlinedButton(
                onPressed: () {
                  context.go('/signin');
                },
                style: ButtonStyle(
                  minimumSize: WidgetStatePropertyAll(
                    Size(double.infinity, 50),
                  ),
                ),
                child: Text(
                  "Log Out",
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
