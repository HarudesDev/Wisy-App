import 'package:wisy/models/photo.dart';
//import 'package:wisy/providers/auth_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wisy/repositories/firebase_auth_repository.dart';
import 'package:wisy/repositories/firebase_firestore_repository.dart';

part 'photos_provider.g.dart';

@riverpod
Stream<List<Photo>> photos(PhotosRef ref) {
  final storage = ref.watch(firestoreProvider);
  final authService = ref.watch(firebaseAuthRepositoryProvider);
  //ref.watch(authProvider);
  return storage
      .collection('users')
      .doc(authService.getID())
      .collection('photos')
      .orderBy('dateTime')
      .withConverter(
          fromFirestore: Photo.fromFirestore,
          toFirestore: (Photo photo, _) => photo.toJson())
      .snapshots()
      .map((query) {
    return query.docs.map((doc) => doc.data()).toList();
  });
}
