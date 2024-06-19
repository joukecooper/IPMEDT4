import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../pages/account_page.dart';


class Header extends StatefulWidget {
  @override
  _HeaderState createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  int coins = 0;
  String? currentUserID;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      getCurrentUserID();
    });
  }

  Future<void> getCurrentUserID() async {
    final authService = AuthService();
    final uid = await authService.getCurrentUID();
    setState(() {
      currentUserID = uid;
    });

    if (currentUserID != null) {
      _loadCoins();
    }
  }

  Future<void> _loadCoins() async {
    try {
      final fetchedCoins = await fetchCoins();
      setState(() {
        coins = fetchedCoins;
      });
    } catch (e) {
      print('Failed to fetch coins: $e');
    }
  }

  Future<int> fetchCoins() async {
    final url = Uri.parse('http://dsf-server.nl/api/user/$currentUserID/coins');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['coins'];
      } else {
        throw Exception('Failed to load coins');
      }
    } catch (e) {
      throw Exception('Failed to load coins: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Hike Hero'),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(
              'Coins: $coins',
              style: const TextStyle(fontSize: 18),
            ),
          ),
        ),
      ],
    );
  }
}
