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
  bool setting1 = false;
  bool setting2 = false;
  bool setting3 = false;
  bool setting4 = false;

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
  TextEditingController();

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
              // Top half of the screen
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Icon(
                    Icons.account_circle,
                    size: 100.0,
                    color: Colors.blue,
                  ),
                  SizedBox(height: 10),
                  const Text(
                    'User Name',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
                      padding: EdgeInsets.symmetric(
                        vertical: 12, // Adjust the vertical padding
                        horizontal: 24, // Adjust the horizontal padding
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(),
              // Bottom half of the screen
              Row(
                children: <Widget>[
                  // Left column with settings and sliders
                  Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        buildSettingRow('Setting 1', setting1, (bool value) {
                          setState(() {
                            setting1 = value;
                          });
                        }),
                        buildSettingRow('Setting 2', setting2, (bool value) {
                          setState(() {
                            setting2 = value;
                          });
                        }),
                        buildSettingRow('Setting 3', setting3, (bool value) {
                          setState(() {
                            setting3 = value;
                          });
                        }),
                        buildSettingRow('Setting 4', setting4, (bool value) {
                          setState(() {
                            setting4 = value;
                          });
                        }),
                      ],
                    ),
                  ),
                  // Right column with text fields
                  Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        buildTextField('Username', usernameController),
                        buildTextField('Email', emailController),
                        buildTextField('Password', passwordController,
                            obscureText: true),
                        buildTextField(
                            'Confirm Password', confirmPasswordController,
                            obscureText: true),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSettingRow(
      String title, bool value, ValueChanged<bool> onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(title),
        Switch(
          value: value,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget buildTextField(String label, TextEditingController controller,
      {bool obscureText = false}) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(
          vertical: 8.0, // Adjust the vertical padding to reduce height
          horizontal: 12.0, // Adjust the horizontal padding as needed
        ),
      ),
    );
  }
}
