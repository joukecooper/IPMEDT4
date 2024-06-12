import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ipmedt4/pages/login_page.dart';
import 'themedata.dart';


import 'firebase_options.dart';

Future<void> main() async {
  //  dart pub add firebase_core
  // dart pub add firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: buildCustomTheme(),
      home: const LoginPage(title: 'Flutter Demo Home Page'),
    );
  }
}
