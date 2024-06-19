import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ipmedt4/pages/login_page.dart';
import 'package:ipmedt4/pages/map_page.dart';
import 'dart:convert';
import '../components/footer.dart';
import '../components/header.dart';
import '../services/auth_service.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  String username = 'Loading...';
  bool isEditingUsername = false;
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController addFriendController = TextEditingController();

  String? currentUserID;
  int friendsCount = 0;  // Initialize friend count
  final AuthService _auth = AuthService(); // Instance of AuthService for logout

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
    fetchUsername(uid!);
    fetchFriendsCount(uid!);  // Fetch the initial friend count
    print('Current User ID in AccountPage: $currentUserID');
  }

  Future<void> fetchUsername(String userID) async {
    final response = await http.get(Uri.parse('http://dsf-server.nl/api/user/$userID/username'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        username = data['username'];
        print(data['username']);
      });
    } else {
      setState(() {
        username = 'Error loading username';
      });
    }
  }

  Future<void> fetchFriendsCount(String userID) async {
    final response = await http.get(Uri.parse('http://dsf-server.nl/api/user/$userID/friends/count'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        friendsCount = data['total_friends'];
      });
    } else {
      setState(() {
        friendsCount = 0;
      });
    }
  }

  Future<void> updateUsername(String userID, String newUsername) async {
    final response = await http.put(
      Uri.parse('http://dsf-server.nl/api/user/$userID/username'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': newUsername,
      }),
    );

    if (response.statusCode == 200) {
      fetchUsername(userID);
    } else {
      setState(() {
        username = 'Error updating username';
      });
    }
  }

  Future<void> addFriend(String userID, String friendUsername) async {
    final response = await http.post(
      Uri.parse('http://dsf-server.nl/api/user/$userID/friends'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'friendUsername': friendUsername,
      }),
    );

    if (response.statusCode == 200) {
      fetchFriendsCount(userID);  // Refresh the friends count after successfully adding a friend
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Friend added successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to add friend'),
          backgroundColor: Colors.red,  // Set the background color to red
        ),
      );
    }
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
                    color: Colors.lightGreen,
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
                        FilledButton(
                          onPressed: () {
                            updateUsername(currentUserID!, usernameController.text);
                            setState(() {
                              isEditingUsername = false;
                            });
                          },
                          child: const Text('Update Username'),
                        ),
                      ],
                    )
                        : Text(
                      username,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          const Text(
                            'Friends',
                            style: TextStyle(fontSize: 18),
                          ),
                          Text(
                            '$friendsCount', // Use dynamic friend count
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          const Text(
                            'User ID',
                            style: TextStyle(fontSize: 18),
                          ),
                          Text(
                            currentUserID ?? 'Loading...', // Display the current user ID
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                      FilledButton(
                        onPressed: () {
                          addFriend(currentUserID!, addFriendController.text);
                        },
                        child: const Text(
                          'Add Friend',
                          style: TextStyle(
                            fontSize: 16, // Adjust the font size
                            color: Colors.white, // Change the text color to white
                          ),
                        ),
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12, // Adjust the vertical padding
                            horizontal: 24, // Adjust the horizontal padding
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  FilledButton(
                    onPressed: () => {
                    Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage(title: 'Login Page')), // Navigeer naar MapPage


                    ),
                      _auth.logout()},
                    child: const Text("Logout"),
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
