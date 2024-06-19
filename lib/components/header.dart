import 'package:flutter/material.dart';
import '../pages/account_page.dart';
import '../services/auth_service.dart';

class Header extends StatelessWidget implements PreferredSizeWidget {
  const Header({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(80);

  @override
  Widget build(BuildContext context) {
    String? currentUserID;

    Future<void> getCurrentUserID() async {
      final authService = AuthService();
      final uid = await authService.getCurrentUID();
      currentUserID = uid;
      (context as Element).markNeedsBuild();
    }

    getCurrentUserID();

    return FutureBuilder(
      future: getCurrentUserID(),
      builder: (context, snapshot) {
        return AppBar(
          title: const Text('Hike Hero'),
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.settings_rounded,
                size: 40,
              ),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute<void>(
                  builder: (BuildContext context) {
                    return AccountPage();
                  },
                ));
              },
            ),
            if (currentUserID != null)
              IconButton(
                icon: const Icon(Icons.person),
                onPressed: () {
                  // Debugging voor testen of juist is gegaan
                  print('Current User ID: $currentUserID');
                },
              ),
          ],
        );
      },
    );
  }
}
