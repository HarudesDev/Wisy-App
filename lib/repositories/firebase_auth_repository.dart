import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wisy/providers/auth_provider.dart';

class FirebaseAuthRepository{

  final Ref ref;

  FirebaseAuthRepository(this.ref);

  Future signInWithEmailAndPassword(String email, String password) async {
    final firebaseAuth = ref.watch(firebaseAuthProvider);
    try {
      UserCredential user = await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return user;
    } catch (e) {
      return null;
    }
  }
  
  Future registerWithEmailAndPassword(String email, String password) async {
    final firebaseAuth = ref.watch(firebaseAuthProvider);
    try {
      await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
    } catch (e) {
      return null;
    }
  }
  
  Future signOut() async {
    final firebaseAuth = ref.watch(firebaseAuthProvider);
    try {
      await firebaseAuth.signOut();
    } catch (e) {
      return null;
    }
  }

  
  String? getID()=> ref.watch(firebaseAuthProvider).currentUser?.uid;
  
}

final firebaseAuthRepositoryProvider = Provider<FirebaseAuthRepository>((ref) => FirebaseAuthRepository(ref));