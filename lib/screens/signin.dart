import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hydratation/providers/name_provider.dart';
import 'package:hydratation/utils/path.dart';
import 'package:hydratation/widgets/custom_input.dart';
import 'package:hydratation/widgets/input_password.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';

class Signin extends StatefulWidget {
  const Signin({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SigninState createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  final _formKey = GlobalKey<FormState>();
  bool isChecked = false;
  final dio = Dio();

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  Future<void> singIn(String email, String password) async {
    try {
      Response result = await dio.get(
        "${PathBackend().baseUrl}/users/signin",
        data: {"email": email, "password": password},
      );
      Map<String, dynamic> data = result.data;
      // ignore: use_build_context_synchronously
      final prov = Provider.of<NameProvider>(context, listen: false);
      prov.setEmail(data['email']);
      prov.setName(data['name']);
      prov.setAccountState(data['account_state']);
      prov.setId(data['id']);
      // ignore: use_build_context_synchronously
      context.go('/home');
    } catch (e) {
      QuickAlert.show(
        // ignore: use_build_context_synchronously
        context: context,
        type: QuickAlertType.info,
        title: 'Account missing',
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
              "Sign in with your account",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            SizedBox(height: 10),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildInput(
                    "Email",
                    CustomInput(
                      controller: _emailController,
                      errorText: 'Email is required',
                      placeholder: Text(
                        "email",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  _buildInput(
                    "Password",
                    InputPassword(
                      controller: _passwordController,
                      errorText: 'short password or is empty',
                      placeholder: Text(
                        "your password",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: isChecked,
                              activeColor: Colors.blue,
                              shape: CircleBorder(),
                              onChanged: (value) {
                                setState(() {
                                  isChecked = value!;
                                });
                              },
                            ),
                            Text(
                              "Remember me",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        Spacer(),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            "Forgot password",
                            style: TextStyle(
                              color: Colors.blueAccent,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        singIn(
                          _emailController.text,
                          _passwordController.text,
                        );
                      }
                    },
                    style: ButtonStyle(
                      minimumSize: WidgetStatePropertyAll(
                        Size(double.infinity, 50),
                      ),
                      backgroundColor: WidgetStatePropertyAll(Colors.blue),
                    ),
                    child: Text(
                      "Sign In",
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
                  "Don't have a account?",
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
                TextButton(
                  onPressed: () {
                    context.go('/signup');
                  },
                  child: Text(
                    "Sign up here",
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
