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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            context.go('/started');
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
              "Let's make a account",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            SizedBox(height: 10),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildInput(
                    "Full Name",
                    CustomInput(
                      controller: _fullnameController,
                      errorText: "Please enter your full name",
                      placeholder: Text(
                        "your full name",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  _buildInput(
                    "Email",
                    CustomInput(
                      controller: _emailController,
                      errorText: "Please enter your email",
                      placeholder: Text(
                        "your email",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  _buildInput(
                    "Password",
                    InputPassword(
                      controller: _passwordController,
                      errorText: 'Password is empty or < 8',
                      placeholder: Text(
                        "your password",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      String email = _emailController.text;
                      String name = _fullnameController.text;
                      String pass = _passwordController.text;
                      if (_formKey.currentState!.validate()) {
                        try {
                          Response result = await createUser(name, email, pass);
                          if (result.statusCode == 200) {
                            QuickAlert.show(
                              context: context,
                              type: QuickAlertType.success,
                              title: 'Account created',
                              onConfirmBtnTap: () {
                                context.go('/signin');
                              },
                              confirmBtnText: 'Sign In',
                              confirmBtnTextStyle: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          }
                        } catch (e) {
                          QuickAlert.show(
                            context: context,
                            type: QuickAlertType.info,
                            title: 'Account already exists',
                            confirmBtnTextStyle: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                          );
                        }
                      } else {}
                    },
                    style: ButtonStyle(
                      minimumSize: WidgetStatePropertyAll(
                        Size(double.infinity, 50),
                      ),
                      backgroundColor: WidgetStatePropertyAll(Colors.blue),
                    ),
                    child: Text(
                      "Sign Up",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already have a account?",
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
                TextButton(
                  onPressed: () {
                    context.go('/signin');
                  },
                  child: Text(
                    "Sign In here",
                    style: TextStyle(color: Colors.blueAccent, fontSize: 12),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
