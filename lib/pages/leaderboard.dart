import 'package:flutter/material.dart';

import 'package:ipmedt4/themedata.dart';

import '../components/header.dart';
import '../components/footer.dart';


//LET OP, volg dit: https://medium.com/@ashishpimpre/how-to-fetch-data-from-an-api-and-display-it-in-listview-in-flutter-770863f85959


class Player {
  int? id;
  String username = "Pipo";
  String? profilePic;
  int coinCount = 0;

  Player({
    this.id,
    required this.username,
    this.profilePic,
    required this.coinCount
  });

  Player.fromJson(Map<String, dynamic> json) {
  id = json['id'];
  username = json['username'];
  profilePic = json['picture'];
  coinCount = json['coins'];
  }
}

class Leaderboard extends StatelessWidget {
  Leaderboard({super.key});

  final List<Player> players = [
    Player(id: 1, username: "Pipo", coinCount: 12),
    Player(id: 2, username: "Ado", coinCount: 10),
    Player(id: 3, username: "Olaf", coinCount: 9)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Header(),
      bottomNavigationBar: const Footer(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        child: Column(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                    height: 50,
                    width: 90,
                    child: Card( child: Text("Wereld") )
                ),
                SizedBox(
                    height: 50,
                    width: 90,
                    child: Card( child: Text("Vrienden") )
                ),
              ]
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
                              borderRadius: const BorderRadius.all(Radius.circular(50)),
                              border: Border.all(
                                color: secondaryColor,
                                width: 2,
                              )
                            ),
                            child: Center(child: Text((index + 1).toString()))
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
                          const Icon(
                            color: secondaryColor,
                            Icons.attach_money_rounded
                          ),
                          SizedBox(
                            width: 20,
                            child: Text(player.coinCount.toString())
                          ),
                          const SizedBox(width: 5),
                        ]
                      ),
                    );
                  },
                ),
              ),
            )
        ])
      )
    );
  }
}