import 'package:flutter/material.dart';
import '../components/footer.dart';
import '../services/auth_service.dart'; // Importeer je AuthService

class StorePage extends StatefulWidget {
  @override
  _StorePageState createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  int coins = 0; // Base value of coins
  String? currentUserID;

  final List<Map<String, dynamic>> storeItems = [
    {
      'name': 'Premium Version',
      'price': 2.99,
      'image':
      'https://www.wereldwijdwandelen.nl/wp-content/uploads/2023/05/beste-goedkope-wandelschoenen-2.png',
      'isPremium': true,
    },
    {
      'name': 'Item 1',
      'price': 200,
      'image': 'https://via.placeholder.com/100',
      'isPremium': false,
    },
    {
      'name': 'Item 2',
      'price': 200,
      'image': 'https://via.placeholder.com/100',
      'isPremium': false,
    },
    {
      'name': 'Item 3',
      'price': 200,
      'image': 'https://via.placeholder.com/100',
      'isPremium': false,
    },
    {
      'name': 'Item 4',
      'price': 200,
      'image': 'https://via.placeholder.com/100',
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const Footer(),
      appBar: AppBar(
        title: const Text('Store Page'),
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
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        subtitle: Text('\$${item['price']}/month'),
        trailing: ElevatedButton(
          onPressed: () {
            // Buy premium version logic
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.blue,
          ),
          child: const Text('Buy'),
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
            Image.network(
              item['image'],
              width: 110, // Fixed width
              height: 110, // Fixed height
              fit: BoxFit.cover,
            ),
            Text(
              '${item['price']} Coins',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Buy item logic
                int price = item['price'];
                if (coins >= price) {
                  setState(() {
                    coins -= price;
                  });
                } else {
                  // Show insufficient coins message
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: const Text('Not enough coins!'),
                  ));
                }
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.green,
              ),
              child: const Text('Buy'),
            ),
          ],
        ),
      ),
    );
  }
}
