import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hydratation/utils/path.dart';
import 'package:hydratation/widgets/custom_input.dart';
import 'package:hydratation/widgets/input_password.dart';
import 'package:quickalert/quickalert.dart';

class Signup extends StatefulWidget {
  Signup({Key? key}) : super(key: key);

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _fullnameController;
  final _formKey = GlobalKey<FormState>();
  bool isChecked = false;
  final dio = Dio();
  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _fullnameController = TextEditingController();
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

  Future<dynamic> createUser(String name, String email, String pass) async {
    return await dio.post(
      "${PathBackend().baseUrl}/users/create",
      data: {"name": name, "email": email, "password": pass},
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
            context.go('/started');
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
                "Join Us",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Start your hydration journey today. It only takes a minute.",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 48),
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
                        "Full Name",
                        CustomInput(
                          controller: _fullnameController,
                          errorText: "Required",
                          hintText: "e.g. John Doe",
                          prefixIcon: const Icon(Icons.person_outline, color: Colors.blue, size: 20),
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildInput(
                        "Email Address",
                        CustomInput(
                          controller: _emailController,
                          errorText: "Required",
                          hintText: "name@example.com",
                          prefixIcon: const Icon(Icons.email_outlined, color: Colors.blue, size: 20),
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildInput(
                        "Password",
                        InputPassword(
                          controller: _passwordController,
                          errorText: 'Min. 8 characters',
                          placeholder: Text(
                            "Create a password",
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
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      Response result = await createUser(
                        _fullnameController.text,
                        _emailController.text,
                        _passwordController.text,
                      );
                      if (result.statusCode == 200) {
                        if (!mounted) return;
                        QuickAlert.show(
                          context: context,
                          type: QuickAlertType.success,
                          title: 'Account created',
                          confirmBtnColor: Colors.blue,
                          onConfirmBtnTap: () {
                            context.go('/signin');
                          },
                          confirmBtnText: 'Sign In',
                        );
                      }
                    } catch (e) {
                      String errorMsg = "An error occurred";
                      if (e is DioException) {
                        errorMsg = e.response?.data['detail'] ?? e.message ?? "Connection error";
                      }
                      if (!mounted) return;
                      QuickAlert.show(
                        context: context,
                        type: QuickAlertType.info,
                        title: errorMsg,
                        confirmBtnColor: Colors.blue,
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: const Text(
                  "Create Account",
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Have an account?",
                    style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 14),
                  ),
                  TextButton(
                    onPressed: () {
                      context.go('/signin');
                    },
                    child: const Text(
                      "Sign In",
                      style: TextStyle(color: Colors.blue, fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
