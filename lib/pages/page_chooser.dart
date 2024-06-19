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
  List<Widget> screens = [];

  void onClicked(int index) {
    setState(() {
      currentPageIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    screens = [
      const HomePage(onClicked: onClicked),
      const MapPage(),
      const Leaderboard(),
      const AccountPage(),
      StorePage(),
    ];
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: Header()
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(19, 0, 19, 0),
        child: screens.elementAt(currentPageIndex),
      ),
      bottomNavigationBar: Footer(
        currentPageIndex: currentPageIndex,
        onClicked: onClicked,
      ),
    );
  }
}