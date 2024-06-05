import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;

  void registerUser(String password, String username) async {
    await _auth.createUserWithEmailAndPassword(
      email: username,
      password: password,
    );
  }

  User? getUser() {
    return _auth.currentUser;
  }

  void logout() async {
    await _auth.signOut();
  }

  Stream<User?> listenToUser() {
    return _auth.authStateChanges();
  }

  void loginUser(String password, String username) async {
    await _auth.signInWithEmailAndPassword(email: username, password: password);
  }
}
