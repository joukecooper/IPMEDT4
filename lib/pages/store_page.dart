import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../services/auth_service.dart';

class StorePage extends StatefulWidget {
  @override
  _StorePageState createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  int coins = 0;
  String? currentUserID;

  final List<Map<String, dynamic>> storeItems = [
    {
      'name': 'Premium Versie',
      'price': 2.99,
      'image': 'https://image.similarpng.com/very-thumbnail/2020/08/Golden-crown-design-Premium-vector-PNG.png',
      'isPremium': true,
    },
    {
      'name': 'Bergschoenen',
      'price': 200,
      'image': 'https://www.wereldwijdwandelen.nl/wp-content/uploads/2023/05/beste-goedkope-wandelschoenen-2.png',
      'isPremium': false,
    },
    {
      'name': 'Wandelschoenen',
      'price': 200,
      'image': 'https://www.mykees.com/wp-content/uploads/2023/01/beste-wandelschoenen-868wig-1.jpg',
      'isPremium': false,
    },
    {
      'name': 'Wandelrugtas',
      'price': 200,
      'image': 'https://vienta.nl/wp-content/uploads/My-project-1-14.png',
      'isPremium': false,
    },
    {
      'name': 'wandeljas',
      'price': 200,
      'image': 'https://www.bfgcdn.com/1500_1500_90/103-1245-0111/stoic-womens-nordmarkst-hoody-softshelljack.jpg',
      'isPremium': false,
    },
  ];

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

  Future<void> purchaseItem(int price) async {
    final url = Uri.parse('http://dsf-server.nl/api/user/$currentUserID/coins');
    final body = json.encode({'coins': price});

    try {
      final response = await http.delete(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        await _loadCoins();
      } else {
        throw Exception('Failed to purchase item');
      }
    } catch (e) {
      print('Failed to purchase item: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to purchase item!'),
      ));
    }
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      getCurrentUserID();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 19, horizontal: 0),
      children: <Widget>[
        buildPremiumCard(storeItems[0]),
        SizedBox(height: 20),
        GridView.count(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.6,
          children: List.generate(4, (index) {
            return buildStoreItemCard(storeItems[index + 1]);
          }),
        ),
      ],
    );
  }

  Widget buildPremiumCard(Map<String, dynamic> item) {
    return Card(
      child: ListTile(
        leading: Image.network(item['image']),
        title: Text(
          item['name'],
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        subtitle: Text('\$${item['price']}/month'),
        trailing: FilledButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: const Text('Bedankt voor je aankoop!'),
            ));
          },
          child: const Text('Koop nu'),
        ),
      ),
    );
  }

  Widget buildStoreItemCard(Map<String, dynamic> item) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              item['name'],
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              '10% korting',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: Colors.grey),
            ),
            Image.network(
              item['image'],
              width: 110,
              height: 110,
              fit: BoxFit.cover,
            ),
            Text(
              '${item['price']} Coins',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: () async {
                int price = item['price'];
                if (coins >= price) {
                  await purchaseItem(price);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: const Text('Niet genoeg munten!'),
                  ));
                }
              },
              child: const Text('Koop nu'),
            ),
          ],
        ),
      ),
    );
  }
}
