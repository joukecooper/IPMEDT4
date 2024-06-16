import 'dart:async';

import 'package:flutter/material.dart';
import '../components/header.dart';
import '../components/footer.dart';
import 'package:ipmedt4/pages/login_page.dart';
import 'package:ipmedt4/services/auth_service.dart';

class Profiel extends StatefulWidget {
  const Profiel({super.key});

  @override
  State<Profiel> createState() => _HomePageState();
}

class _HomePageState extends State<Profiel> {
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
        appBar: const Header(),
        bottomNavigationBar: const Footer(),
        body: Center(
          child: FilledButton(
            onPressed: () => {_auth.logout()},
            child: const Text("Logout"),
          ),
        ));
  }

  @override
  void dispose() {
    super.dispose();
    _loginSubscription.cancel();
  }
}
