import 'package:flutter/material.dart';

import 'package:ipmedt4/services/auth_service.dart';

import '../components/header.dart';
import '../components/footer.dart';

class Profiel extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Header(),
      bottomNavigationBar: const Footer(),
      body: Center(
          child: Text("Logout"),
      ),
    );
  }
}