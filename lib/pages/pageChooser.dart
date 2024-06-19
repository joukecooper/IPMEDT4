import 'package:flutter/material.dart';

import '../components/header.dart';
import '../components/footer.dart';
import 'account_page.dart';
import 'home_page.dart';
import 'leaderboard.dart';
import 'map_page.dart';
import 'store_page.dart';

class PageChooser extends StatefulWidget {
  const PageChooser({super.key});
  @override
  State<PageChooser> createState() => _PageChooserState();
}

class _PageChooserState extends State<PageChooser> {
  int currentPageIndex = 0;
  List screens = [
    const HomePage(),
    const MapPage(),
    const Leaderboard(),
    const AccountPage(),
    StorePage(),
  ];

  int coins = 0; // Base value of coins
  String? currentUserID;

  void onClicked(int index) {
    setState(() {
      currentPageIndex = index;
    });
  }

  Widget headerAction() {
    if (currentPageIndex == 4) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Text(
            'Coins: $coins',
            style: const TextStyle(fontSize: 18),
          ),
        ),
      );
    } else {
      return IconButton(
        icon: const Icon(
            size: 40,
            Icons.settings_rounded
        ),
        onPressed: () {
          currentPageIndex = 3;
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Header(),
      body: Center(
        child: screens.elementAt(currentPageIndex),
      ),
      bottomNavigationBar: Footer(
        currentPageIndex: currentPageIndex,
        onClicked: onClicked,
      ),
    );
  }
}