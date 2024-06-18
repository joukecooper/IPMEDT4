import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../themedata.dart';
import '../components/header.dart';
import '../components/footer.dart';

class Player {
  int? id;
  String username = "Pipo";
  String? profilePic;
  String coinCount = "0"; // Changed to String to support large numbers

  Player({
    this.id,
    required this.username,
    this.profilePic,
    required this.coinCount,
  });

  Player.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    profilePic = json['picture'];
    coinCount = json['coins'].toString(); // Ensure coinCount is converted to String
  }
}

class Leaderboard extends StatefulWidget {
  const Leaderboard({Key? key}) : super(key: key);

  @override
  _LeaderboardState createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {
  List<Player> players = [];

  @override
  void initState() {
    super.initState();
    _loadPlayers('http://dsf-server.nl/api/top-users');
  }

  Future<void> _loadPlayers(String apiUrl) async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List<Player> loadedPlayers = [];

        for (var player in jsonData['top_users']) {
          loadedPlayers.add(Player.fromJson(player));
        }

        setState(() {
          players = loadedPlayers;
        });

        print('Players loaded successfully: $players'); // Debug statement
      } else {
        throw Exception('Failed to load players');
      }
    } catch (e) {
      print('Error loading players: $e');
      // Handle error if necessary
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Header(),
      bottomNavigationBar: const Footer(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: FilledButton(
                    onPressed: () {
                      _loadPlayers('http://dsf-server.nl/api/top-users');
                    },
                    child: const Text("Wereld"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: OutlinedButton(
                    onPressed: () {
                      _loadPlayers('http://dsf-server.nl/api/user/1/top-friends');
                    },
                    child: const Text("Vrienden"),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Card(
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: players.length,
                  itemBuilder: (context, index) {
                    final player = players[index];
                    return Container(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const SizedBox(width: 5),
                          Container(
                            width: 34,
                            height: 34,
                            decoration: BoxDecoration(
                              borderRadius:
                              const BorderRadius.all(Radius.circular(50)),
                              border: Border.all(
                                color: secondaryColor,
                                width: 2,
                              ),
                            ),
                            child: Center(child: Text((index + 1).toString())),
                          ),
                          const SizedBox(width: 5),
                          player.profilePic != null && player.profilePic!.isNotEmpty
                              ? CircleAvatar(
                            radius: 17,
                            backgroundImage: NetworkImage(player.profilePic!),
                          )
                              : const Icon(
                            color: secondaryColor,
                            size: 40,
                            Icons.account_circle_rounded,
                          ),
                          const SizedBox(width: 5),
                          Expanded(child: Text(player.username)),
                          const SizedBox(width: 5),
                          const Icon(color: secondaryColor, Icons.attach_money_rounded),
                          SizedBox(
                            width: 60, // Increased width to accommodate larger coin counts
                            child: Text(
                              player.coinCount,
                              style: TextStyle(fontSize: 18), // Adjust font size as needed
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(width: 5),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}