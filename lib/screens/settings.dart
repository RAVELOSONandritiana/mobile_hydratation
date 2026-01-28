import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hydratation/providers/name_provider.dart';
import 'package:hydratation/screens/terms.dart';
import 'package:hydratation/screens/update_email.dart';
import 'package:hydratation/screens/update_name.dart';
import 'package:hydratation/screens/update_password.dart';
import 'package:hydratation/utils/path.dart';
import 'package:hydratation/widgets/avatar.dart';
import 'package:hydratation/widgets/settings_widget.dart';
import 'package:hydratation/widgets/switch_custom.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final ImagePicker _picker = ImagePicker();
  final dio = Dio();

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 75,
      );
      
      if (image != null) {
        Uint8List bytes = await image.readAsBytes();
        String base64Image = base64Encode(bytes);
        
        // ignore: use_build_context_synchronously
        final prov = context.read<NameProvider>();
        
        final response = await dio.put(
          "${PathBackend().baseUrl}/users/updateprofile",
          data: {
            "id": prov.id,
            "profile_picture": base64Image,
          },
        );
        
        if (response.statusCode == 200) {
          prov.setProfilePicture(base64Image);
        }
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 60),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Settings",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Manage your profile and app preferences",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.4),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GestureDetector(
                onTap: _pickImage,
                child: const AvatarWidget(path: "avatar.jpg"),
              ),
            ),
            const SizedBox(height: 40),
            _buildSectionTitle("Account Settings"),
            const SizedBox(height: 16),
            _buildGroup([
              SettingsWidget(
                title: 'Personal Info',
                subtitle: 'Update name and identity',
                icons: const Icon(Icons.person_rounded, color: Colors.blue, size: 20),
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const UpdateName())),
              ),
              SettingsWidget(
                title: 'Email Address',
                subtitle: 'Manage your primary email',
                icons: const Icon(Icons.alternate_email_rounded, color: Colors.blue, size: 20),
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const UpdateEmail())),
              ),
              SettingsWidget(
                title: 'Password & Security',
                subtitle: 'Secure your hydration data',
                icons: const Icon(Icons.shield_rounded, color: Colors.blue, size: 20),
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const UpdatePassword())),
              ),
            ]),
            const SizedBox(height: 32),
            _buildSectionTitle("App Preferences"),
            const SizedBox(height: 16),
            _buildGroup([
              SettingsWidget(
                title: 'Notifications',
                subtitle: 'Smart daily reminders',
                icons: const Icon(Icons.notifications_active_rounded, color: Colors.blue, size: 20),
                trailing: const SwitchCustom(),
              ),
            ]),
            const SizedBox(height: 32),
            _buildSectionTitle("General"),
            const SizedBox(height: 16),
            _buildGroup([
              SettingsWidget(
                title: 'Terms of Service',
                subtitle: 'Legal and privacy information',
                icons: const Icon(Icons.description_rounded, color: Colors.blue, size: 20),
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const Terms())),
              ),
            ]),
            const SizedBox(height: 56),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.withOpacity(0.05),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: TextButton(
                  onPressed: () => context.go('/signin'),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.05),
                    foregroundColor: Colors.redAccent,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: Colors.redAccent.withOpacity(0.2)),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.logout_rounded, size: 20),
                      const SizedBox(width: 12),
                      const Text(
                        "Sign Out",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: Colors.blue.withOpacity(0.5),
          fontSize: 10,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _buildGroup(List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.03),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: Column(
          children: children,
        ),
      ),
    );
  }
}
