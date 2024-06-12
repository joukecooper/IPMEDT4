import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ipmedt4/pages/login_page.dart';
import 'package:ipmedt4/pages/map_page.dart';
import 'package:ipmedt4/services/auth_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _auth = AuthService();

  late StreamSubscription _loginSubscription;

  @override
  void initState() {
    super.initState();
    _loginSubscription = _auth.listenToUser().listen((user) {
      if (user == null) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => LoginPage(title: "Je bent uitgelogd")));
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
        title: Text(_auth.getUser()?.email ?? "User not found"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MapPage()), // Navigeer naar MapPage
                );
              },
              child: Text("Open Map"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => {_auth.logout()},
              child: Text("Logout"),
            ),
          ],
        ),
      ),
    );
  }
}