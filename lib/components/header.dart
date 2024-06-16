import 'package:flutter/material.dart';
import '../pages/profiel.dart';

class Header extends StatelessWidget implements PreferredSizeWidget {
  const Header({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(80);

  @override
  Widget build(BuildContext context) {

    return AppBar(
      title: const Text('Hike Hero'),
      actions: <Widget>[
        IconButton(
          icon: const Icon(
            size: 40,
            Icons.settings_rounded
          ),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute<void>(
              builder: (BuildContext context) {
                return const Profiel();
              },
            ));
          },
        ),
      ],
    );

  }
}
