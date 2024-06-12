import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ipmedt4/pages/home_page.dart';
import 'package:ipmedt4/services/auth_service.dart';
import '../components/footer.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.title});

  final String title;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  final _auth = AuthService();

  late StreamSubscription _loginSubscription;

  @override
  void initState() {
    super.initState();
    _loginSubscription = _auth.listenToUser().listen((user) {
      if (user != null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Welkom bij de app"),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'email',
              ),
            ),
            TextField(
              obscureText: true,
              controller: _passwordController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () => {
                          _auth.loginUser(
                              _passwordController.text, _emailController.text)
                        },
                    child: Text("Login")),
                ElevatedButton(
                    onPressed: () => {
                          // Lambda functie
                          _auth.registerUser(
                              _passwordController.text, _emailController.text)
                        },
                    child: Text("register"))
              ],
            )
          ],
        ),
      ),
        bottomNavigationBar: const Footer()
    );
  }
}
