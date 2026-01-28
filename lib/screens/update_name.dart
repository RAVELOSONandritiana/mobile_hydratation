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

      if (!mounted) return;
      await QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        title: 'Succès',
        text: 'Votre nom a été mis à jour.',
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
    _nameController.text = Provider.of<NameProvider>(context).name;
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
                "Update Name",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Change your display name as it appears to others.",
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
                        "Current Name",
                        CustomInput(
                          controller: _nameController,
                          readOnly: true,
                          prefixIcon: const Icon(Icons.person_outline, color: Colors.blue, size: 20),
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildInput(
                        "New Display Name",
                        CustomInput(
                          controller: _newNameController,
                          errorText: 'New name required',
                          hintText: "Enter your new name",
                          prefixIcon: const Icon(Icons.edit_outlined, color: Colors.blue, size: 20),
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
                    update(_newNameController.text);
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
