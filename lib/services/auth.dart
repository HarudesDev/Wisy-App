import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? _user;
  bool get isAuthenticated => _user != null;

  final Ref ref;

  AuthService(this.ref) {
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

final authServiceProvider = Provider<AuthService>((ref) => AuthService(ref));