import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hydratation/providers/name_provider.dart';
import 'package:hydratation/utils/path.dart';
import 'package:hydratation/widgets/custom_input.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class UpdateEmail extends StatefulWidget {
  const UpdateEmail({super.key});

  @override
  State<UpdateEmail> createState() => _UpdateEmailState();
}

class _UpdateEmailState extends State<UpdateEmail> {
  late TextEditingController _emailController;
  final dio = Dio();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
  }

  Future<void> update(String newEmail) async {
    try {
      final prov = Provider.of<NameProvider>(context, listen: false);
      await dio.put(
        "${PathBackend().baseUrl}/users/updatemail",
        data: {"id": prov.id, "name": newEmail},
      );
      prov.setEmail(newEmail);
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
              "Update your email",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            SizedBox(height: 10),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildInput(
                    "New Email",
                    CustomInput(
                      controller: _emailController,
                      errorText: "new email required",
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
                        update(_emailController.text);
                        Navigator.pop(context);
                      } else {
                        if (kDebugMode) {
                          print("_formKey invalid");
                        }
                      }
                    },
                    style: ButtonStyle(
                      minimumSize: WidgetStatePropertyAll(
                        Size(double.infinity, 50),
                      ),
                      backgroundColor: WidgetStatePropertyAll(Colors.blue),
                    ),
                    child: Text(
                      "Confirm",
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
