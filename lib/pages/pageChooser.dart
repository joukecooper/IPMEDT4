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

  void onClicked(int index) {
    setState(() {
      currentPageIndex = index;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: Header()
      ),
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