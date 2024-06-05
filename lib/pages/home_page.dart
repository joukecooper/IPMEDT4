import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ipmedt4/pages/login_page.dart';
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
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // TRY THIS: Try changing the color here to a specific color (to
          // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
          // change color while the other colors stay the same.
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(_auth.getUser()?.email ?? "User not found"),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () => {_auth.logout()},
            child: Text("Logout"),
          ),
        ));
  }

  @override
  void dispose() {
    super.dispose();
    _loginSubscription.cancel();
  }
}
