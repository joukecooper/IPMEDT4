import 'package:flutter/material.dart';

import '../components/header.dart';
import '../components/footer.dart';

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