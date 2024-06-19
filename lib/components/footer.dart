import 'package:flutter/material.dart';

int currentPageIndex = 0;

class Footer extends StatelessWidget {
  final currentPageIndex;
  ValueChanged<int> onClicked;

  Footer({
    this.currentPageIndex,
    required this.onClicked,
    super.key
  });

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
      selectedIndex: currentPageIndex,
      onDestinationSelected: onClicked,
    );
  }
}