import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../themedata.dart';
import '../components/header.dart';
import '../components/footer.dart';
import 'map_page.dart';
import '../services/auth_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int coins = 0;
  int streakCount = 0;
  String? currentUserID;

  @override
  void initState() {
    super.initState();
    getCurrentUserID();
    _loadStats();
  }

  Future<void> getCurrentUserID() async {
    final authService = AuthService();
    final uid = await authService.getCurrentUID();
    setState(() {
      currentUserID = uid;
    });
  }

  Future<void> _loadStats() async {
    if (currentUserID == null) return;

    try {
      final coinsUrl = Uri.parse('http://dsf-server.nl/api/user/$currentUserID/coins');
      final streakUrl = Uri.parse('http://dsf-server.nl/api/user/$currentUserID/streak_count');

      final coinsResponse = await http.get(coinsUrl);
      final streakResponse = await http.get(streakUrl);

      if (coinsResponse.statusCode == 200 && streakResponse.statusCode == 200) {
        final coinsData = json.decode(coinsResponse.body);
        final streakData = json.decode(streakResponse.body);

        setState(() {
          coins = coinsData['coins'];
          streakCount = streakData['streak_count'];
        });
      } else {
        throw Exception('Failed to load stats');
      }
    } catch (e) {
      print('Error loading stats: $e');
      // Handle error if necessary
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Header(),
      bottomNavigationBar: const Footer(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 1,
              child: Row(
                children: [
                  Expanded(
                    child: Card(
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.topRight,
                            child: Icon(
                              Icons.attach_money_rounded,
                              color: secondaryColor.withOpacity(0.5),
                              size: 100.0,
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              '$coins',
                              style: TextStyle(fontSize: 80),
                            ),
                          ),
                          const Align(
                            alignment: Alignment.bottomRight,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 10.0, bottom: 2.0),
                              child: Text("Munten"),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Card(
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.topRight,
                            child: Icon(
                              Icons.local_fire_department_rounded,
                              color: secondaryColor.withOpacity(0.5),
                              size: 100.0,
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              '$streakCount',
                              style: TextStyle(fontSize: 80),
                            ),
                          ),
                          const Align(
                            alignment: Alignment.bottomRight,
                            child: Padding(
                              padding: EdgeInsets.only(right: 10.0, bottom: 2.0),
                              child: Text("Dagen streak"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Card(
                child: Image(
                  image: FileImage(stats.png),
                ), // Placeholder for stats
              ),
            ),
            Center(
              child: SizedBox(
                height: 50,
                width: 150,
                child: FilledButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const MapPage()), // Navigeer naar MapPage
                    );
                  },
                  child: const Text("Wandel nu!"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
