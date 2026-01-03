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
    } catch (e) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Erreur',
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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 14),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Update your password",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            SizedBox(height: 10),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildInput(
                    "Your Current Password",
                    InputPassword(
                      controller: _currentPasswordController,
                      placeholder: Text(
                        "",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  _buildInput(
                    "New Password",
                    InputPassword(
                      controller: _newPasswordController,
                      placeholder: Text(
                        "",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  _buildInput(
                    "Confirm New Password",
                    InputPassword(
                      controller: _confirmNewPasswordController,
                      placeholder: Text(
                        "",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        update(
                          _currentPasswordController.text,
                          _newPasswordController.text,
                        );
                        Navigator.pop(context);
                      }
                    },
                    style: ButtonStyle(
                      minimumSize: WidgetStatePropertyAll(
                        Size(double.infinity, 50),
                      ),
                      backgroundColor: WidgetStatePropertyAll(Colors.blue),
                    ),
                    child: Text(
                      "update",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
