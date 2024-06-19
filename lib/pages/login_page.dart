import 'dart:async';

import '../themedata.dart';
import 'package:flutter/material.dart';
import 'package:ipmedt4/pages/page_chooser.dart';
import 'package:ipmedt4/pages/register_page.dart';
import 'package:ipmedt4/services/auth_service.dart';

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
            context, MaterialPageRoute(builder: (context) => const PageChooser()));
      }
    });
  }

  @override
  void dispose() {
    _loginSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Hike Hero',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: accentColor,
                ),
              ),
              Text(
                'Login',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: tertiaryColor,
                ),
              ),
              SizedBox(height: 40),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                obscureText: true,
                controller: _passwordController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  await _auth.loginUser(
                      _emailController.text, _passwordController.text);
                },
                child: Text("Login"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentColor,
                  minimumSize: Size(double.infinity, 50),
                ),
              ),
              SizedBox(height: 20), // Voeg ruimte toe tussen de knoppen en de tekst
              Text("Nog geen account?"),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterPage(title: 'Register Page')),
                  );
                },
                child: Text(
                  'Registreer hier',
                  style: TextStyle(
                    color: accentColor,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
