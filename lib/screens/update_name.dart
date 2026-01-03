import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hydratation/providers/name_provider.dart';
import 'package:hydratation/utils/path.dart';
import 'package:hydratation/widgets/custom_input.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class UpdateName extends StatefulWidget {
  const UpdateName({super.key});

  @override
  State<UpdateName> createState() => _UpdateNameState();
}

class _UpdateNameState extends State<UpdateName> {
  late TextEditingController _nameController;
  late TextEditingController _newNameController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _newNameController = TextEditingController();
  }

  Future<void> update(String newName) async {
    try {
      final prov = Provider.of<NameProvider>(context, listen: false);
      await Dio().put(
        "${PathBackend().baseUrl}/users/updatename",
        data: {"id": prov.id, "name": newName},
      );
      prov.setName(newName);
      Navigator.pop(context);
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
    _nameController.text = Provider.of<NameProvider>(context).name;
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
              "Update your name",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            SizedBox(height: 10),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildInput(
                    "Your Current Name",
                    CustomInput(
                      controller: _nameController,
                      readOnly: true,
                      placeholder: Text(
                        "",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  _buildInput(
                    "New Name",
                    CustomInput(
                      controller: _newNameController,
                      errorText: 'New name required',
                      placeholder: Text(
                        "",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if(_formKey.currentState!.validate()){
                        update(_newNameController.text);
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
