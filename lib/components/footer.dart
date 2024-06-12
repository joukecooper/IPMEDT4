import 'package:flutter/material.dart';

class Footer extends StatefulWidget {
  const Footer({super.key});

  @override
  State<Footer> createState() => _FooterState();
}

class _FooterState extends State<Footer> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {

    return NavigationBar(
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_rounded),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(Icons.map),
          label: 'Kaart',
        ),
        NavigationDestination(
            icon: Icon(Icons.emoji_events),
            label: 'Leaderboard',
        ),
        NavigationDestination(
            icon: Icon(Icons.account_circle_rounded),
            label: 'Profiel'
        ),
        NavigationDestination(
            icon: Icon(Icons.shopping_cart),
            label: 'Winkel'
        )
      ],
      onDestinationSelected: (int index) {
        setState(() {
          currentPageIndex = index;
        });
      },
      selectedIndex: currentPageIndex,
    );
  }
}