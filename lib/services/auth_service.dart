// import 'package:firebase_auth/firebase_auth.dart';
//
// class AuthService {
//   final _auth = FirebaseAuth.instance;
//
//   void registerUser(String password, String username) async {
//     await _auth.createUserWithEmailAndPassword(
//       email: username,
//       password: password,
//     );
//   }
//
//   User? getUser() {
//     return _auth.currentUser;
//   }
//
//   void logout() async {
//     await _auth.signOut();
//   }
//
//   Stream<User?> listenToUser() {
//     return _auth.authStateChanges();
//   }
//
//   void loginUser(String password, String username) async {
//     await _auth.signInWithEmailAndPassword(email: username, password: password);
//   }
// }

import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;

  Future<void> registerUser(String email, String password) async {
    await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  User? getUser() {
    return _auth.currentUser;
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  Stream<User?> listenToUser() {
    return _auth.authStateChanges();
  }

  Future<void> loginUser(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  bool isLoggedIn() {
    return _auth.currentUser != null;
  }
}
