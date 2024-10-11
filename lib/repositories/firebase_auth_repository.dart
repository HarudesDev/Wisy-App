import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FirebaseAuthRepository {
  FirebaseAuth firebaseAuth;

  FirebaseAuthRepository(this.firebaseAuth);

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential user = await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return user;
    } catch (e) {
      return null;
    }
  }

  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
    } catch (e) {
      return null;
    }
  }

  Future signOut() async {
    try {
      await firebaseAuth.signOut();
    } catch (e) {
      return null;
    }
  }

  String? getID() => firebaseAuth.currentUser?.uid;
}

final firebaseAuthRepositoryProvider = Provider<FirebaseAuthRepository>(
    (ref) => FirebaseAuthRepository(ref.read(firebaseAuthProvider)));

final firebaseAuthProvider =
    Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);
