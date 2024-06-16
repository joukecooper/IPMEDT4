import 'package:flutter/material.dart';

import 'package:ipmedt4/services/auth_service.dart';

import '../components/header.dart';
import '../components/footer.dart';

class Profiel extends StatelessWidget {
  const Profiel({super.key});
  
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: Header(),
      bottomNavigationBar: Footer(),
      body: Center(
          child: Text("Logout"),
      ),
    );
  }
}