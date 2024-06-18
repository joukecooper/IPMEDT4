import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../components/footer.dart';

class StorePage extends StatefulWidget {
  @override
  _StorePageState createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  int coins = 0; // Base value of coins

  final List<Map<String, dynamic>> storeItems = [
    {
      'name': 'Premium Version',
      'price': 2.99,
      'image': 'https://www.mykees.com/wp-content/uploads/2023/01/beste-wandelschoenen-868wig-1.jpg',
      'isPremium': true,
    },
    {
      'name': 'Item 1',
      'price': 200,
      'image': 'https://www.wereldwijdwandelen.nl/wp-content/uploads/2023/05/beste-goedkope-wandelschoenen-2.png',
      'isPremium': false,
    },
    {
      'name': 'Item 2',
      'price': 200,
      'image': 'https://www.mykees.com/wp-content/uploads/2023/01/beste-wandelschoenen-868wig-1.jpg',
      'isPremium': false,
    },
    {
      'name': 'Item 3',
      'price': 200,
      'image': 'https://vienta.nl/wp-content/uploads/My-project-1-14.png',
      'isPremium': false,
    },
    {
      'name': 'Item 4',
      'price': 200,
      'image': 'https://www.bfgcdn.com/1500_1500_90/103-1245-0111/stoic-womens-nordmarkst-hoody-softshelljack.jpg',
      'isPremium': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadCoins();
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
    final url = Uri.parse('http://dsf-server.nl/api/user/1/coins');

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
    final url = Uri.parse('http://dsf-server.nl/api/user/1/coins');
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const Footer(),
      appBar: AppBar(
        title: Text('Store Page'),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                'Coins: $coins',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: <Widget>[
          // Premium version card
          buildPremiumCard(storeItems[0]),
          SizedBox(height: 20),
          // 2x2 grid of store item cards
          GridView.count(
            physics: NeverScrollableScrollPhysics(), // Disable GridView's scrolling
            shrinkWrap: true, // Enable GridView to scroll inside ListView
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.7, // Adjust the height of the cards
            children: List.generate(4, (index) {
              return buildStoreItemCard(storeItems[index + 1]);
            }),
          ),
        ],
      ),
    );
  }

  Widget buildPremiumCard(Map<String, dynamic> item) {
    return Card(
      child: ListTile(
        leading: Image.network(item['image']),
        title: Text(
          item['name'],
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        subtitle: Text('\$${item['price']}/month'),
        trailing: ElevatedButton(
          onPressed: () {
            // Buy premium version logic
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white, backgroundColor: Colors.blue, // foreground color
          ),
          child: Text('Buy'),
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
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Image.network(
              item['image'],
              width: 110, // Fixed width
              height: 110, // Fixed height
              fit: BoxFit.cover,
            ),
            Text(
              '${item['price']} Coins',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                int price = item['price'];
                if (coins >= price) {
                  await purchaseItem(price);
                } else {
                  // Show insufficient coins message
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Not enough coins!'),
                  ));
                }
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.green, // foreground color
              ),
              child: Text('Buy'),
            ),
          ],
        ),
      ),
    );
  }
}