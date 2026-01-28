import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hydratation/providers/name_provider.dart';
import 'package:hydratation/utils/path.dart';
import 'package:hydratation/widgets/input_password.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class UpdatePassword extends StatefulWidget {
  const UpdatePassword({super.key});

  @override
  State<UpdatePassword> createState() => _UpdatePasswordState();
}

class _UpdatePasswordState extends State<UpdatePassword> {
  late TextEditingController _currentPasswordController;
  late TextEditingController _newPasswordController;
  late TextEditingController _confirmNewPasswordController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _currentPasswordController = TextEditingController();
    _newPasswordController = TextEditingController();
    _confirmNewPasswordController = TextEditingController();
  }

  Future<void> update(String current, String password) async {
    try {
      final prov = Provider.of<NameProvider>(context, listen: false);
      await Dio().put(
        "${PathBackend().baseUrl}/users/updatepassword",
        data: {
          "id": prov.id,
          "current_password": current,
          "password": password,
        },
      );

      if (!mounted) return;
      await QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        title: 'Succès',
        text: 'Votre mot de passe a été mis à jour.',
        onConfirmBtnTap: () {
          Navigator.pop(context); // Close alert
          Navigator.pop(context); // Go back to settings
        },
      );
    } catch (e) {
      String errorMsg = "Une erreur est survenue";
      if (e is DioException) {
        errorMsg = e.response?.data['detail'] ?? e.message ?? "Erreur de connexion";
      }
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Erreur',
        text: errorMsg,
        confirmBtnTextStyle: TextStyle(
          fontSize: 12,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      );
    }
  }

  Widget _buildInput(String label, Widget input) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.grey, fontSize: 14)),
        SizedBox(height: 10),
        input,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                "Update Password",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Ensure your account is secure with a strong password.",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.white.withOpacity(0.05)),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buildInput(
                        "Current Password",
                        InputPassword(
                          controller: _currentPasswordController,
                          placeholder: Text(
                            "Enter current password",
                            style: TextStyle(color: Colors.white.withOpacity(0.2)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildInput(
                        "New Password",
                        InputPassword(
                          controller: _newPasswordController,
                          placeholder: Text(
                            "Enter new password",
                            style: TextStyle(color: Colors.white.withOpacity(0.2)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildInput(
                        "Confirm New Password",
                        InputPassword(
                          controller: _confirmNewPasswordController,
                          placeholder: Text(
                            "Repeat new password",
                            style: TextStyle(color: Colors.white.withOpacity(0.2)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    if (_newPasswordController.text != _confirmNewPasswordController.text) {
                      QuickAlert.show(
                        context: context,
                        type: QuickAlertType.warning,
                        confirmBtnColor: Colors.blue,
                        text: "New passwords do not match.",
                      );
                      return;
                    }
                    update(
                      _currentPasswordController.text,
                      _newPasswordController.text,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: const Text(
                  "Confirm Change",
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
