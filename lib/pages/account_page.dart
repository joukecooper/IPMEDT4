import 'package:flutter/material.dart';
import '../components/footer.dart';
import '../components/header.dart';
import '../services/auth_service.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  String username = 'User Name';
  bool isEditingUsername = false;
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController addFriendController = TextEditingController();

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

    print('Current User ID in AccountPage: $currentUserID');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Header(),
      bottomNavigationBar: const Footer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Icon(
                    Icons.account_circle,
                    size: 100.0,
                    color: Colors.blue,
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isEditingUsername = true;
                      });
                    },
                    child: isEditingUsername
                        ? Column(
                      children: [
                        TextField(
                          controller: usernameController,
                          decoration: const InputDecoration(
                            labelText: 'Enter new username',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              username = usernameController.text;
                              isEditingUsername = false;
                            });
                          },
                          child: const Text('Update Username'),
                        ),
                      ],
                    )
                        : Text(
                      username,
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Text(
                            'Friends',
                            style: TextStyle(fontSize: 18),
                          ),
                          Text(
                            '25', // Replace with dynamic friend count
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Text(
                            'Email',
                            style: TextStyle(fontSize: 18),
                          ),
                          Text(
                            'user@example.com', // Replace with dynamic email
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          controller: addFriendController,
                          decoration: const InputDecoration(
                            labelText: 'Friend Username',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          // Add friends button logic
                        },
                        child: const Text(
                          'Add Friends',
                          style: TextStyle(
                            fontSize: 16, // Adjust the font size
                            color: Colors.white, // Change the text color to white
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue, // Change the button color
                          padding: const EdgeInsets.symmetric(
                            vertical: 12, // Adjust the vertical padding
                            horizontal: 24, // Adjust the horizontal padding
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
