import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ipmedt4/pages/login_page.dart';
import 'package:ipmedt4/services/auth_service.dart';
import '../themedata.dart';

import '../components/header.dart';
import '../components/footer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Header(),
      bottomNavigationBar: const Footer(),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 24,
          mainAxisSpacing: 24,
          children: [
            Card (
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: Icon(
                      color: secondaryColor.withOpacity(0.5),
                      size: 100.0,
                      Icons.attach_money_rounded,
                    )
                  ),
                  const Align(
                    alignment: Alignment.center,
                    child: Text(
                      "24",
                      style: TextStyle(fontSize: 80)
                    ),
                  ),
                  const Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      "Munten",
                    )
                  )
                ]
              ),
            ),
            Card(
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: Icon(
                      color: secondaryColor.withOpacity(0.5),
                      size: 100.0,
                      Icons.local_fire_department_rounded,
                    )
                  ),
                  const Align(
                    alignment: Alignment.center,
                    child: Text(
                      "5",
                      style: TextStyle(fontSize: 80)
                    ),
                  ),
                  const Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      "Dagen streak",
                    )
                  )
                ]
              ),
            ),
            const Card(
              child: Text("Joejoe"),
            )
          ]
        )
      ),
    );
  }
}
