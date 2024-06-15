import 'package:flutter/material.dart';

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
  const Leaderboard({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: Header(),
      bottomNavigationBar: Footer(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
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
            Expanded( child: Card(
                child: Text("Lijst")
            ))
          ]
        )
      )
    );
  }
}