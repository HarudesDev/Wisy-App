import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? _user;
  bool get isAuthenticated => _user != null;

  Auth() {
    _user = _firebaseAuth.currentUser;
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential user = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return user;
    } catch (e) {
      print('Error: ${e.toString()}');
      return null;
    }
  }

  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
    } catch (e) {
      print('Error: ${e.toString()}');
      return null;
    }
  }

  Future signOut() async {
    try {
      await _firebaseAuth.signOut();
      _user = null;
    } catch (e) {
      print('Error: ${e.toString()}');
      return null;
    }
  }

  String? getID() {
    return _firebaseAuth.currentUser?.uid;
  }
}
