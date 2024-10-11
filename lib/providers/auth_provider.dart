import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wisy/repositories/firebase_auth_repository.dart';

part 'auth_provider.g.dart';

@riverpod
Stream<User?> auth(AuthRef ref) {
  final firebaseAuth = ref.watch(firebaseAuthProvider);
  return firebaseAuth.authStateChanges();
}
