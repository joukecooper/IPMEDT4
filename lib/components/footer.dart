import 'package:flutter/material.dart';
import '../pages/home_page.dart';
import '../pages/leaderboard.dart';
import '../pages/profiel.dart';
import '../pages/login_page.dart';
import '../pages/map_page.dart';

int currentPageIndex = 0;

class Footer extends StatefulWidget {
  const Footer({super.key});

  @override
  State<Footer> createState() => _FooterState();
}

class _FooterState extends State<Footer> {

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
        switch(index) {
          case 0:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
            break;
          case 1:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MapPage()),
            );
            break;
          case 2:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Leaderboard()),
            );
            break;
          case 3:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Profiel()),
            );
            break;
          default:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage(title: "Joejoe")),
            );
        }
      },
      selectedIndex: currentPageIndex,
    );
  }
}